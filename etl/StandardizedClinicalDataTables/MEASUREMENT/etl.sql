-- LABS FROM labevents
WITH
"labevents" AS (
	SELECT
	mimic_id as measurement_id
	, subject_id
	, charttime as measurement_datetime
	, hadm_id
	, itemid
	, coalesce(valueuom, extract_unit(value)) as unit_source_value
	, flag
	, value as value_source_value
	, extract_operator(value) as operator_name
	, extract_value_period_decimal(value) as value_as_number
	FROM labevents
),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"d_labitems" AS (SELECT itemid, label as measurement_source_value, fluid, loinc_code, category, mimic_id FROM d_labitems),
"gcpt_lab_label_to_concept" AS (SELECT label as measurement_source_value, concept_id as measurement_concept_id FROM gcpt_lab_label_to_concept),
"omop_loinc" AS (SELECT concept_id AS measurement_concept_id, concept_code as loinc_code FROM omop.concept WHERE vocabulary_id = 'LOINC' AND domain_id = 'Measurement'),
"omop_operator" AS (SELECT concept_name as operator_name, concept_id as operator_concept_id FROM omop.concept WHERE  domain_id ilike 'Meas Value Operator'),
"gcpt_lab_unit_to_concept" AS (SELECT unit as unit_source_value, concept_id as unit_concept_id FROM gcpt_lab_unit_to_concept),
"row_to_insert" AS (
SELECT
  labevents.measurement_id
, patients.person_id
, coalesce(omop_loinc.measurement_concept_id, gcpt_lab_label_to_concept.measurement_concept_id, 0) as measurement_concept_id
, labevents.measurement_datetime::date AS measurement_date
, labevents.measurement_datetime AS measurement_datetime
, CASE
     WHEN category ILIKE 'blood gas'  THEN  2000000010
     WHEN category ILIKE 'chemistry'  THEN  2000000011
     WHEN category ILIKE 'hematology' THEN  2000000009
     ELSE 44818702 --labs
  END AS measurement_type_concept_id -- Lab result
, operator_concept_id AS operator_concept_id -- =, >, ... operator
, labevents.value_as_number AS value_as_number
, 0::integer AS value_as_concept_id
, gcpt_lab_unit_to_concept.unit_concept_id
, null::double precision AS range_low
, null::double precision AS range_high
, null::bigint AS provider_id
, admissions.visit_occurrence_id AS visit_occurrence_id
, null::bigint As visit_detail_id
, d_labitems.itemid::text AS measurement_source_value       -- this might be linked to concept.concept_code
, d_labitems.mimic_id AS measurement_source_concept_id
, gcpt_lab_unit_to_concept.unit_source_value
, labevents.value_source_value
, specimen_concept_id
FROM labevents
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN d_labitems USING (itemid)
LEFT JOIN omop_loinc USING (loinc_code)
LEFT JOIN omop_operator USING (operator_name)
LEFT JOIN gcpt_lab_label_to_concept USING (measurement_source_value)
LEFT JOIN gcpt_lab_unit_to_concept USING (unit_source_value)
LEFT JOIN gcpt_labs_specimen_to_concept ON (d_labitems.fluid =  gcpt_labs_specimen_to_concept.label)
),
"specimen_lab" AS ( --generated specimen: each lab is associated with a fictive specimen
SELECT
  nextval('mimic_id_seq') as specimen_id    -- non NULL
, person_id                                 -- non NULL
, coalesce(specimen_concept_id, 0 ) as specimen_concept_id
, 581378 as specimen_type_concept_id    -- non NULL
, measurement_date as specimen_date
, measurement_datetime as specimen_datetime
, null::double precision as quantity
, null::integer unit_concept_id
, null::integer anatomic_site_concept_id
, null::integer disease_status_concept_id
, null::integer specimen_source_id
, null::text specimen_source_value
, null::text unit_source_value
, null::text anatomic_site_source_value
, null::text disease_status_source_value
, row_to_insert.measurement_id -- usefull for fact_relationship
FROM row_to_insert
),
"insert_specimen_lab" AS (
INSERT INTO omop.specimen
(
	  specimen_id
	, person_id
	, specimen_concept_id
	, specimen_type_concept_id
	, specimen_date
	, specimen_datetime
	, quantity
	, unit_concept_id
	, anatomic_site_concept_id
	, disease_status_concept_id
	, specimen_source_id
	, specimen_source_value
	, unit_source_value
	, anatomic_site_source_value
	, disease_status_source_value
)
SELECT
  specimen_id    -- non NULL
, person_id                         -- non NULL
, specimen_concept_id         -- non NULL
, specimen_type_concept_id    -- non NULL
, specimen_date
, specimen_datetime
, quantity
, unit_concept_id
, anatomic_site_concept_id
, disease_status_concept_id
, specimen_source_id
, specimen_source_value
, unit_source_value
, anatomic_site_source_value
, disease_status_source_value
FROM specimen_lab
RETURNING *
),
"insert_fact_relationship_specimen_measurement" AS (
    INSERT INTO omop.fact_relationship
    (SELECT
      36 AS domain_concept_id_1 -- Specimen
    , specimen_id as fact_id_1
    , 21 AS domain_concept_id_2 -- Measurement
    , measurement_id as fact_id_2
    , 44818854 as relationship_concept_id -- Specimen of (SNOMED)
    FROM specimen_lab
    UNION ALL
    SELECT
      21 AS domain_concept_id_1 -- Measurement
    , measurement_id as fact_id_1
    , 36 AS domain_concept_id_2 -- Specimen
    , specimen_id as fact_id_2
    , 44818756 as relationship_concept_id -- Has specimen (SNOMED)
    FROM specimen_lab
    )
)
INSERT INTO omop.measurement
(
	  measurement_id
	, person_id
	, measurement_concept_id
	, measurement_date
	, measurement_datetime
	, measurement_type_concept_id
	, operator_concept_id
	, value_as_number
	, value_as_concept_id
	, unit_concept_id
	, range_low
	, range_high
	, provider_id
	, visit_occurrence_id
	, visit_detail_id
	, measurement_source_value
	, measurement_source_concept_id
	, unit_source_value
	, value_source_value
)
SELECT
  row_to_insert.measurement_id
, row_to_insert.person_id
, row_to_insert.measurement_concept_id
, row_to_insert.measurement_date
, row_to_insert.measurement_datetime
, row_to_insert.measurement_type_concept_id
, row_to_insert.operator_concept_id
, row_to_insert.value_as_number
, row_to_insert.value_as_concept_id
, row_to_insert.unit_concept_id
, row_to_insert.range_low
, row_to_insert.range_high
, row_to_insert.provider_id
, row_to_insert.visit_occurrence_id
, row_to_insert.visit_detail_id
, row_to_insert.measurement_source_value
, row_to_insert.measurement_source_concept_id
, row_to_insert.unit_source_value
, row_to_insert.value_source_value
FROM row_to_insert;

-- LABS from chartevents
WITH
"chartevents_lab" AS (
	SELECT
	  chartevents.itemid
	, chartevents.mimic_id as measurement_id
	, subject_id
	, hadm_id
	, storetime as measurement_datetime --according to Alistair, storetime is the result time
	, charttime as specimen_datetime                -- according to Alistair, charttime is the specimen time
	, value as value_source_value
	, extract_operator(value) as operator_name
	, extract_value_period_decimal(value)    as value_as_number
	, coalesce(valueuom, extract_unit(value)) AS unit_source_value
	FROM chartevents
        JOIN omop.concept -- concept driven dispatcher
        ON (    concept_code  = itemid::Text
            AND domain_id     = 'Measurement'
            AND vocabulary_id = 'MIMIC d_items'
            AND concept_class_id IN ( 'Labs', 'Blood Gases', 'Hematology', 'Heme/Coag', 'Coags', 'CSF', 'Enzymes','Chemistry')

           )
	WHERE error IS NULL OR error= 0
),
"d_items" AS (SELECT itemid, category, label, mimic_id FROM d_items),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"omop_operator" AS (SELECT concept_name as operator_name, concept_id as operator_concept_id FROM omop.concept WHERE  domain_id ilike 'Meas Value Operator'),
"omop_loinc" AS (
	SELECT distinct on (concept_name) concept_id AS measurement_concept_id, concept_name as label
	FROM omop.concept
	WHERE vocabulary_id = 'LOINC'
	AND domain_id = 'Measurement'
	AND standard_concept = 'S'),
"gcpt_lab_label_to_concept" AS (SELECT label, concept_id as measurement_concept_id FROM gcpt_lab_label_to_concept),
"gcpt_lab_unit_to_concept" AS (SELECT unit as unit_source_value, concept_id as unit_concept_id FROM gcpt_lab_unit_to_concept),
"gcpt_labs_from_chartevents_to_concept" AS (SELECT label, category, measurement_type_concept_id from gcpt_labs_from_chartevents_to_concept),
"row_to_insert" AS (
	SELECT
  chartevents_lab.measurement_id
, patients.person_id
, coalesce(omop_loinc.measurement_concept_id, gcpt_lab_label_to_concept.measurement_concept_id, 0) as measurement_concept_id
, chartevents_lab.measurement_datetime::date AS measurement_date
, chartevents_lab.measurement_datetime AS measurement_datetime
, CASE
     WHEN category ILIKE 'blood gases'  THEN  2000000010
     WHEN lower(category) IN ('chemistry','enzymes')  THEN  2000000011
     WHEN lower(category) IN ('hematology','heme/coag','csf','coags') THEN  2000000009
     WHEN lower(category) IN ('labs') THEN coalesce(gcpt_labs_from_chartevents_to_concept.measurement_type_concept_id,44818702)
     ELSE 44818702 -- there no trivial way to classify
  END AS measurement_type_concept_id -- Lab result
, operator_concept_id AS operator_concept_id -- = operator
, chartevents_lab.value_as_number AS value_as_number
, null::bigint AS value_as_concept_id
, gcpt_lab_unit_to_concept.unit_concept_id
, null::double precision AS range_low
, null::double precision AS range_high
, null::bigint AS provider_id
, admissions.visit_occurrence_id AS visit_occurrence_id
, null::bigint As visit_detail_id
, d_items.label AS measurement_source_value
, d_items.mimic_id AS measurement_source_concept_id
, gcpt_lab_unit_to_concept.unit_source_value
, chartevents_lab.value_source_value
, specimen_datetime
  FROM chartevents_lab
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN d_items USING (itemid)
LEFT JOIN omop_loinc USING (label)
LEFT JOIN omop_operator USING (operator_name)
LEFT JOIN gcpt_lab_label_to_concept USING (label)
LEFT JOIN gcpt_labs_from_chartevents_to_concept USING (category, label)
LEFT JOIN gcpt_lab_unit_to_concept USING (unit_source_value)
),
"specimen_lab" AS ( -- generated specimen: each lab measurement is associated with a fictive specimen
SELECT
  nextval('mimic_id_seq') as specimen_id
, person_id
, 0::integer as specimen_concept_id         -- no information right now about any specimen provenance
, 581378 as specimen_type_concept_id
, specimen_datetime::date as specimen_date
, specimen_datetime as specimen_datetime
, null::double precision as quantity
, null::integer unit_concept_id
, null::integer anatomic_site_concept_id
, null::integer disease_status_concept_id
, null::integer specimen_source_id
, null::text specimen_source_value
, null::text unit_source_value
, null::text anatomic_site_source_value
, null::text disease_status_source_value
, row_to_insert.measurement_id -- usefull for fact_relationship
FROM row_to_insert
),
"insert_specimen_lab" AS (
INSERT INTO omop.specimen
(
	  specimen_id
	, person_id
	, specimen_concept_id
	, specimen_type_concept_id
	, specimen_date
	, specimen_datetime
	, quantity
	, unit_concept_id
	, anatomic_site_concept_id
	, disease_status_concept_id
	, specimen_source_id
	, specimen_source_value
	, unit_source_value
	, anatomic_site_source_value
	, disease_status_source_value
)
SELECT
  specimen_id    -- non NULL
, person_id                         -- non NULL
, specimen_concept_id         -- non NULL
, specimen_type_concept_id    -- non NULL
, specimen_date
, specimen_datetime
, quantity
, unit_concept_id
, anatomic_site_concept_id
, disease_status_concept_id
, specimen_source_id
, specimen_source_value
, unit_source_value
, anatomic_site_source_value
, disease_status_source_value
FROM specimen_lab
RETURNING *
),
"insert_fact_relationship_specimen_measurement" AS (
    INSERT INTO omop.fact_relationship
    (SELECT
      36 AS domain_concept_id_1 -- Specimen
    , specimen_id as fact_id_1
    , 21 AS domain_concept_id_2 -- Measurement
    , measurement_id as fact_id_2
    , 44818854 as relationship_concept_id -- Specimen of (SNOMED)
    FROM specimen_lab
    UNION ALL
    SELECT
      21 AS domain_concept_id_1 -- Measurement
    , measurement_id as fact_id_1
    , 36 AS domain_concept_id_2 -- Specimen
    , specimen_id as fact_id_2
    , 44818756 as relationship_concept_id -- Has specimen (SNOMED)
    FROM specimen_lab
    )
)
INSERT INTO omop.measurement
(
	  measurement_id
	, person_id
	, measurement_concept_id
	, measurement_date
	, measurement_datetime
	, measurement_type_concept_id
	, operator_concept_id
	, value_as_number
	, value_as_concept_id
	, unit_concept_id
	, range_low
	, range_high
	, provider_id
	, visit_occurrence_id
	, visit_detail_id --no visit_detail assignation since datetime is not relevant
	, measurement_source_value
	, measurement_source_concept_id
	, unit_source_value
	, value_source_value
)
SELECT
  row_to_insert.measurement_id
, row_to_insert.person_id
, row_to_insert.measurement_concept_id
, row_to_insert.measurement_date
, row_to_insert.measurement_datetime
, row_to_insert.measurement_type_concept_id
, row_to_insert.operator_concept_id
, row_to_insert.value_as_number
, row_to_insert.value_as_concept_id
, row_to_insert.unit_concept_id
, row_to_insert.range_low
, row_to_insert.range_high
, row_to_insert.provider_id
, row_to_insert.visit_occurrence_id
, row_to_insert.visit_detail_id --no visit_detail assignation since datetime is not relevant
, row_to_insert.measurement_source_value
, row_to_insert.measurement_source_concept_id
, row_to_insert.unit_source_value
, row_to_insert.value_source_value
FROM row_to_insert;

-- Microbiology
-- NOTICE: the number of culture is complicated to determine (the distinct on (coalesce).. is a result)
WITH
"culture" AS (
	SELECT
	        DISTINCT ON (subject_id, hadm_id, coalesce(charttime,chartdate)
		, coalesce(spec_itemid,0)
		, coalesce(org_name,'')) spec_itemid
	        , microbiologyevents.mimic_id as measurement_id
		, chartdate as measurement_date
		, charttime as measurement_datetime
		, subject_id
		, hadm_id
		, org_name
		, spec_type_desc as measurement_source_value
		, spec_itemid as specimen_source_value -- TODO: add the specimen type local concepts
		--, specimen_source_id --TODO: wait for next mimic release that will ship the specimen details
		, specimen_concept_id
	FROM microbiologyevents
	LEFT JOIN gcpt_microbiology_specimen_to_concept ON (label = spec_type_desc)

),
"resistance" AS (
	SELECT
	spec_itemid
	, ab_itemid
	, nextval('mimic_id_seq') as measurement_id
	, chartdate as measurement_date
	, charttime as measurement_datetime
	, subject_id
	, hadm_id
	, extract_operator(dilution_comparison) as operator_name
	, extract_value_period_decimal(dilution_comparison) as value_as_number
	, ab_name as measurement_source_value
	, interpretation
	, dilution_text as value_source_value
	, org_name
	FROM microbiologyevents
	WHERE dilution_text IS NOT NULL
),
"fact_relationship" AS (
	SELECT
	  culture.measurement_id as fact_id_1
	, resistance.measurement_id AS fact_id_2
	FROM resistance
	LEFT JOIN culture ON (
		resistance.subject_id = culture.subject_id
		and resistance.hadm_id = culture.hadm_id
		AND coalesce(culture.measurement_datetime,culture.measurement_date) = coalesce(resistance.measurement_datetime,resistance.measurement_date)
		AND coalesce(resistance.spec_itemid,0) = coalesce(culture.spec_itemid,0)
		AND coalesce(resistance.org_name,'') = coalesce(culture.org_name,''))
),
"insert_fact_relationship" AS (
    INSERT INTO omop.fact_relationship
    (SELECT
      21 AS domain_concept_id_1 -- Measurement
    , fact_id_1
    , 21 AS domain_concept_id_2 -- Measurement
    , fact_id_2
    , 44818757 as relationship_concept_id -- Has interpretation (SNOMED) TODO find a better predicate
    FROM fact_relationship
UNION ALL
    SELECT
      21 AS domain_concept_id_1 -- Measurement
    , fact_id_2 as fact_id_1
    , 21 AS domain_concept_id_2 -- Measurement
    , fact_id_1 as  fact_id_2
    , 44818855  as relationship_concept_id --  Interpretation of (SNOMED) TODO find a better predicate
    FROM fact_relationship
    )
),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"specimen_culture" AS ( --generated specimen
SELECT
  nextval('mimic_id_seq') as specimen_id
, patients.person_id
, coalesce(specimen_concept_id,  0) as specimen_concept_id         -- found manually
, 581378 as specimen_type_concept_id
, culture.measurement_date as specimen_date               -- this is not really the specimen date but better than nothing
, culture.measurement_datetime as specimen_datetime
, null::double precision as quantity
, null::integer unit_concept_id
, null::integer anatomic_site_concept_id
, null::integer disease_status_concept_id
, null::integer specimen_source_id            --TODO: wait for next mimic release that will ship the specimen details
, specimen_source_value as specimen_source_value
, null::text unit_source_value
, null::text anatomic_site_source_value
, null::text disease_status_source_value
, culture.measurement_id -- usefull for fact_relationship
FROM culture
LEFT JOIN patients USING (subject_id)
),
"insert_specimen_culture" AS (
INSERT INTO omop.specimen
(
	  specimen_id
	, person_id
	, specimen_concept_id
	, specimen_type_concept_id
	, specimen_date
	, specimen_datetime
	, quantity
	, unit_concept_id
	, anatomic_site_concept_id
	, disease_status_concept_id
	, specimen_source_id
	, specimen_source_value
	, unit_source_value
	, anatomic_site_source_value
	, disease_status_source_value
)
SELECT
  specimen_id    -- non NULL
, person_id                         -- non NULL
, specimen_concept_id         -- non NULL
, specimen_type_concept_id    -- non NULL
, specimen_date               -- this is not really the specimen date but better than nothing
, specimen_datetime
, quantity
, unit_concept_id
, anatomic_site_concept_id
, disease_status_concept_id
, specimen_source_id
, specimen_source_value
, unit_source_value
, anatomic_site_source_value
, disease_status_source_value
FROM specimen_culture
RETURNING *
),
"insert_fact_relationship_specimen_measurement" AS (
    INSERT INTO omop.fact_relationship
    (SELECT
      36 AS domain_concept_id_1 -- Specimen
    , specimen_id as fact_id_1
    , 21 AS domain_concept_id_2 -- Measurement
    , measurement_id as fact_id_2
    , 44818854 as relationship_concept_id -- Specimen of (SNOMED)
    FROM specimen_culture
    UNION ALL
    SELECT
      21 AS domain_concept_id_1 -- Measurement
    , measurement_id as fact_id_1
    , 36 AS domain_concept_id_2 -- Specimen
    , specimen_id as fact_id_2
    , 44818756 as relationship_concept_id -- Has specimen (SNOMED)
    FROM specimen_culture
    )
),
"omop_operator" AS (SELECT concept_name as operator_name, concept_id as operator_concept_id FROM omop.concept WHERE  domain_id ilike 'Meas Value Operator'),
"gcpt_resistance_to_concept" AS (SELECT * FROM gcpt_resistance_to_concept),
"gcpt_org_name_to_concept" AS (SELECT org_name, concept_id AS value_as_concept_id FROM gcpt_org_name_to_concept JOIN omop.concept ON (concept_code = snomed::text AND vocabulary_id = 'SNOMED')),
"gcpt_spec_type_to_concept" AS (SELECT concept_id as measurement_concept_id, spec_type_desc as measurement_source_value FROM gcpt_spec_type_to_concept LEFT JOIN omop.concept ON (loinc = concept_code AND standard_concept ='S' AND domain_id = 'Measurement')),
"gcpt_atb_to_concept" AS (SELECT concept_id as measurement_concept_id, ab_name as measurement_source_value FROM gcpt_atb_to_concept LEFT JOIN omop.concept ON (concept.concept_code = gcpt_atb_to_concept.concept_code AND standard_concept = 'S' AND domain_id = 'Measurement')),
"d_items" AS (SELECT mimic_id as measurement_source_concept_id, itemid FROM d_items WHERE category IN ( 'SPECIMEN', 'ORGANISM')),
"row_to_insert" AS (SELECT
  culture.measurement_id AS measurement_id
, patients.person_id
, coalesce(gcpt_spec_type_to_concept.measurement_concept_id, 4098207) as measurement_concept_id      -- --30088009 -- Blood Culture but not done yet
, measurement_date AS measurement_date
, measurement_datetime AS measurement_datetime
, 2000000007 AS measurement_type_concept_id -- Lab result -- Microbiology - Culture
, null AS operator_concept_id
, null value_as_number
, CASE WHEN org_name IS NULL THEN 9189 ELSE coalesce(gcpt_org_name_to_concept.value_as_concept_id, 0) END AS value_as_concept_id           -- staphiloccocus OR negative in case nothing
, null::bigint AS unit_concept_id
, null::double precision AS range_low
, null::double precision AS range_high
, null::bigint AS provider_id
, admissions.visit_occurrence_id AS visit_occurrence_id
, null::bigint As visit_detail_id
, culture.measurement_source_value AS measurement_source_value -- BLOOD
, d_items.measurement_source_concept_id AS measurement_source_concept_id
, null::text AS unit_source_value
, culture.org_name AS value_source_value -- Staph...
FROM culture
LEFT JOIN d_items ON (spec_itemid = itemid)
LEFT JOIN gcpt_spec_type_to_concept USING (measurement_source_value)
LEFT JOIN gcpt_org_name_to_concept USING (org_name)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
UNION ALL
SELECT
  measurement_id AS measurement_id
, patients.person_id
, coalesce(gcpt_atb_to_concept.measurement_concept_id, 4170475) as measurement_concept_id      -- Culture Sensitivity
, measurement_date AS measurement_date
, measurement_datetime AS measurement_datetime
, 2000000008 AS measurement_type_concept_id -- Lab result
, operator_concept_id AS operator_concept_id -- = operator
, value_as_number AS value_as_number
, gcpt_resistance_to_concept.value_as_concept_id AS value_as_concept_id
, null::bigint AS unit_concept_id
, null::double precision AS range_low
, null::double precision AS range_high
, null::bigint AS provider_id
, admissions.visit_occurrence_id AS visit_occurrence_id
, null::bigint As visit_detail_id
, resistance.measurement_source_value AS measurement_source_value
, d_items.measurement_source_concept_id AS measurement_source_concept_id
, null::text AS unit_source_value
, value_source_value AS  value_source_value
FROM resistance
LEFT JOIN d_items ON (ab_itemid = itemid)
LEFT JOIN gcpt_resistance_to_concept USING (interpretation)
LEFT JOIN gcpt_atb_to_concept USING (measurement_source_value)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN omop_operator USING (operator_name)
)
INSERT INTO omop.measurement
(
	  measurement_id
	, person_id
	, measurement_concept_id
	, measurement_date
	, measurement_datetime
	, measurement_type_concept_id
	, operator_concept_id
	, value_as_number
	, value_as_concept_id
	, unit_concept_id
	, range_low
	, range_high
	, provider_id
	, visit_occurrence_id
	, visit_detail_id
	, measurement_source_value
	, measurement_source_concept_id
	, unit_source_value
	, value_source_value
)
SELECT
  row_to_insert.measurement_id
, row_to_insert.person_id
, row_to_insert.measurement_concept_id
, row_to_insert.measurement_date
, row_to_insert.measurement_datetime
, row_to_insert.measurement_type_concept_id
, row_to_insert.operator_concept_id
, row_to_insert.value_as_number
, row_to_insert.value_as_concept_id
, row_to_insert.unit_concept_id
, row_to_insert.range_low
, row_to_insert.range_high
, row_to_insert.provider_id
, row_to_insert.visit_occurrence_id
, row_to_insert.visit_detail_id --no visit_detail assignation since datetime is not relevant
, row_to_insert.measurement_source_value
, row_to_insert.measurement_source_concept_id
, row_to_insert.unit_source_value
, row_to_insert.value_source_value
FROM row_to_insert;


--MEASUREMENT from chartevents (without labs)
WITH
"chartevents" as (
SELECT
      c.mimic_id as measurement_id,
      c.subject_id,
      c.hadm_id,
      c.cgid,
      m.measurement_concept_id as measurement_concept_id,
      c.charttime as measurement_datetime,
      c.valuenum as value_as_number,
      v.concept_id as value_as_concept_id,
      m.unit_concept_id as unit_concept_id,
      concept.concept_id as measurement_source_concept_id,
      c.valueuom as unit_source_value,
      CASE
	WHEN d_items.category   = 'Text' THEN valuenum -- discreteous variable
        WHEN m.label_type = 'systolic_bp' AND value ~ '[0-9]+/[0-9]+' THEN regexp_replace(value,'([0-9]+)/[0-9]*',E'\\1','g')::double precision
        WHEN m.label_type = 'diastolic_bp' AND value ~ '[0-9]+/[0-9]+' THEN regexp_replace(value,'[0-9]*/([0-9]+)',E'\\1','g')::double precision
        WHEN m.label_type = 'map_bp' AND value ~ '[0-9]+/[0-9]+' THEN map_bp_calc(value)
        WHEN m.label_type = 'fio2' AND c.valuenum between 0 AND 1 THEN c.valuenum * 100
	WHEN m.label_type = 'temperature' AND c.VALUENUM > 85 THEN (c.VALUENUM - 32)*5/9
	WHEN m.label_type = 'pain_level' THEN CASE
		WHEN d_items.LABEL ~* 'level' THEN CASE
		      WHEN c.VALUE ~* 'unable' THEN NULL
		      WHEN c.VALUE ~* 'none' AND NOT c.VALUE ~* 'mild' THEN 0
		      WHEN c.VALUE ~* 'none' AND c.VALUE ~* 'mild' THEN 1
		      WHEN c.VALUE ~* 'mild' AND NOT c.VALUE ~* 'mod' THEN 2
		      WHEN c.VALUE ~* 'mild' AND c.VALUE ~* 'mod' THEN 3
		      WHEN c.VALUE ~* 'mod'  AND NOT c.VALUE ~* 'sev' THEN 4
		      WHEN c.VALUE ~* 'mod'  AND c.VALUE ~* 'sev' THEN 5
		      WHEN c.VALUE ~* 'sev'  AND NOT c.VALUE ~* 'wor' THEN 6
		      WHEN c.VALUE ~* 'sev'  AND c.VALUE ~* 'wor' THEN 7
		      WHEN c.VALUE ~* 'wor' THEN 8
		      ELSE NULL
		      END
		WHEN c.VALUE ~* 'no' THEN 0
		WHEN c.VALUE ~* 'yes' THEN  1
	        END
        WHEN m.label_type = 'sas_rass'  THEN CASE
                WHEN d_items.LABEL ~ '^Riker' THEN CASE
                      WHEN c.VALUE = 'Unarousable' THEN 1
                      WHEN c.VALUE = 'Very Sedated' THEN 2
                      WHEN c.VALUE = 'Sedated' THEN 3
                      WHEN c.VALUE = 'Calm/Cooperative' THEN 4
                      WHEN c.VALUE = 'Agitated' THEN 5
                      WHEN c.VALUE = 'Very Agitated' THEN 6
                      WHEN c.VALUE = 'Dangerous Agitation' THEN 7
                      ELSE NULL
                END
        END
	WHEN m.label_type = 'height_weight'  THEN CASE
		WHEN d_items.LABEL ~ 'W' THEN CASE
	           WHEN d_items.LABEL ~* 'lb' THEN 0.453592 * c.VALUENUM
		   ELSE NULL
		   END
		WHEN d_items.LABEL ~ 'cm' THEN c.VALUENUM / 100::numeric
		ELSE 0.0254 * c.VALUENUM
		END
	ELSE NULL
	END AS valuenum_fromvalue,
      c.value as value_source_value,
      m.value_lb as value_lb,
      m.value_ub as value_ub,
      concept.concept_code AS measurement_source_value
    FROM chartevents as c
    JOIN omop.concept -- concept driven dispatcher
    ON (    concept_code  = c.itemid::Text
	AND domain_id     = 'Measurement'
	AND vocabulary_id = 'MIMIC d_items'
	AND concept_class_id IS DISTINCT FROM 'Labs'
	AND concept_class_id IS DISTINCT FROM 'Blood Gases'
	AND concept_class_id IS DISTINCT FROM 'Hematology'
	AND concept_class_id IS DISTINCT FROM 'Chemistry'
	AND concept_class_id IS DISTINCT FROM 'Heme/Coag'
	AND concept_class_id IS DISTINCT FROM 'Coags'
	AND concept_class_id IS DISTINCT FROM 'CSF'
	AND concept_class_id IS DISTINCT FROM 'Enzymes'
       )  -- remove the labs, because done before
    LEFT JOIN d_items USING (itemid)
    LEFT JOIN gcpt_chart_label_to_concept as m ON (label = d_label)
    LEFT JOIN
       (
	SELECT mimic_name, concept_id, 'heart_rhythm'::text AS label_type
	FROM gcpt_heart_rhythm_to_concept
       ) as v  ON m.label_type = v.label_type AND c.value = v.mimic_name
    WHERE error IS NULL OR error= 0
  ),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"caregivers" AS (SELECT mimic_id AS provider_id, cgid FROM caregivers),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"row_to_insert" AS (SELECT
  measurement_id AS measurement_id
, patients.person_id
, coalesce(measurement_concept_id, 0) as measurement_concept_id
, measurement_datetime::date AS measurement_date
, measurement_datetime AS measurement_datetime
, 44818701 as measurement_type_concept_id  -- from physical examination
, 4172703 AS operator_concept_id
, coalesce(valuenum_fromvalue, value_as_number) AS value_as_number
, value_as_concept_id AS value_as_concept_id
, unit_concept_id AS unit_concept_id
, value_lb AS range_low
, value_ub AS range_high
, caregivers.provider_id AS provider_id
, admissions.visit_occurrence_id AS visit_occurrence_id
, null::bigint As visit_detail_id
, measurement_source_value
, measurement_source_concept_id AS measurement_source_concept_id
, unit_source_value AS unit_source_value
, value_source_value AS  value_source_value
FROM chartevents
LEFT JOIN patients USING (subject_id)
LEFT JOIN caregivers USING (cgid)
LEFT JOIN admissions USING (hadm_id))
INSERT INTO omop.measurement
(
	  measurement_id
	, person_id
	, measurement_concept_id
	, measurement_date
	, measurement_datetime
	, measurement_type_concept_id
	, operator_concept_id
	, value_as_number
	, value_as_concept_id
	, unit_concept_id
	, range_low
	, range_high
	, provider_id
	, visit_occurrence_id
	, visit_detail_id
	, measurement_source_value
	, measurement_source_concept_id
	, unit_source_value
	, value_source_value
)
SELECT
  row_to_insert.measurement_id
, row_to_insert.person_id
, row_to_insert.measurement_concept_id
, row_to_insert.measurement_date
, row_to_insert.measurement_datetime
, row_to_insert.measurement_type_concept_id
, row_to_insert.operator_concept_id
, row_to_insert.value_as_number
, row_to_insert.value_as_concept_id
, row_to_insert.unit_concept_id
, row_to_insert.range_low
, row_to_insert.range_high
, row_to_insert.provider_id
, row_to_insert.visit_occurrence_id
, visit_detail_assign.visit_detail_id
, row_to_insert.measurement_source_value
, row_to_insert.measurement_source_concept_id
, row_to_insert.unit_source_value
, row_to_insert.value_source_value
FROM row_to_insert
LEFT JOIN omop.visit_detail_assign
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND
(--only one visit_detail
(is_first IS TRUE AND is_last IS TRUE)
OR -- first
(is_first IS TRUE AND is_last IS FALSE AND row_to_insert.measurement_datetime <= visit_detail_assign.visit_end_datetime)
OR -- last
(is_last IS TRUE AND is_first IS FALSE AND row_to_insert.measurement_datetime > visit_detail_assign.visit_start_datetime)
OR -- middle
(is_last IS FALSE AND is_first IS FALSE AND row_to_insert.measurement_datetime > visit_detail_assign.visit_start_datetime AND row_to_insert.measurement_datetime <= visit_detail_assign.visit_end_datetime)
);

-- OUTPUT events
WITH
"outputevents" AS (SELECT
  subject_id
, hadm_id
, itemid
, cgid
, valueuom AS unit_source_value
, CASE
    WHEN itemid IN (227488,227489) THEN -1 * value
    ELSE value
  END AS value
, mimic_id as measurement_id
, charttime as measurement_datetime
FROM outputevents
where iserror is null
),
"gcpt_output_label_to_concept" AS (SELECT item_id as itemid, concept_id as measurement_concept_id FROM gcpt_output_label_to_concept),
"gcpt_lab_unit_to_concept" AS (SELECT unit as unit_source_value, concept_id as unit_concept_id FROM gcpt_lab_unit_to_concept),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"caregivers" AS (SELECT mimic_id AS provider_id, cgid FROM caregivers),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"row_to_insert" AS (SELECT
  measurement_id AS measurement_id
, patients.person_id
, coalesce(measurement_concept_id,0) as measurement_concept_id
, measurement_datetime::date AS measurement_date
, measurement_datetime AS measurement_datetime
, 2000000003 as measurement_type_concept_id
, 4172703 AS operator_concept_id
, value AS value_as_number
, null::bigint AS value_as_concept_id
, unit_concept_id AS unit_concept_id
, null::double precision AS range_low
, null::double precision AS range_high
, caregivers.provider_id AS provider_id
, admissions.visit_occurrence_id AS visit_occurrence_id
, null::bigint As visit_detail_id
, d_items.label AS measurement_source_value
, d_items.mimic_id AS measurement_source_concept_id
, outputevents.unit_source_value AS unit_source_value
, null::text AS value_source_value
FROM outputevents
LEFT JOIN gcpt_output_label_to_concept USING (itemid)
LEFT JOIN gcpt_lab_unit_to_concept ON gcpt_lab_unit_to_concept.unit_source_value ilike outputevents.unit_source_value
LEFT JOIN d_items USING (itemid)
LEFT JOIN patients USING (subject_id)
LEFT JOIN caregivers USING (cgid)
LEFT JOIN admissions USING (hadm_id))
INSERT INTO omop.measurement
(
	  measurement_id
	, person_id
	, measurement_concept_id
	, measurement_date
	, measurement_datetime
	, measurement_type_concept_id
	, operator_concept_id
	, value_as_number
	, value_as_concept_id
	, unit_concept_id
	, range_low
	, range_high
	, provider_id
	, visit_occurrence_id
	, visit_detail_id
	, measurement_source_value
	, measurement_source_concept_id
	, unit_source_value
	, value_source_value
)
SELECT
  row_to_insert.measurement_id
, row_to_insert.person_id
, row_to_insert.measurement_concept_id
, row_to_insert.measurement_date
, row_to_insert.measurement_datetime
, row_to_insert.measurement_type_concept_id
, row_to_insert.operator_concept_id
, row_to_insert.value_as_number
, row_to_insert.value_as_concept_id
, row_to_insert.unit_concept_id
, row_to_insert.range_low
, row_to_insert.range_high
, row_to_insert.provider_id
, row_to_insert.visit_occurrence_id
, visit_detail_assign.visit_detail_id
, row_to_insert.measurement_source_value
, row_to_insert.measurement_source_concept_id
, row_to_insert.unit_source_value
, row_to_insert.value_source_value
FROM row_to_insert
LEFT JOIN omop.visit_detail_assign
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND
(--only one visit_detail
(is_first IS TRUE AND is_last IS TRUE)
OR -- first
(is_first IS TRUE AND is_last IS FALSE AND row_to_insert.measurement_datetime <= visit_detail_assign.visit_end_datetime)
OR -- last
(is_last IS TRUE AND is_first IS FALSE AND row_to_insert.measurement_datetime > visit_detail_assign.visit_start_datetime)
OR -- middle
(is_last IS FALSE AND is_first IS FALSE AND row_to_insert.measurement_datetime > visit_detail_assign.visit_start_datetime AND row_to_insert.measurement_datetime <= visit_detail_assign.visit_end_datetime)
);


-- weight from inputevent_mv

with
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"caregivers" AS (SELECT mimic_id AS provider_id, cgid FROM caregivers),
"row_to_insert" as
(
select
          nextval('mimic_id_seq') as measurement_id
        , person_id
        , 3025315 as measurement_concept_id  --loinc weight
        , starttime::date as measurement_date
        , starttime as measurement_datetime
        , 44818701 as measurement_type_concept_id -- from physical examination
	, 4172703 as operator_concept_id
        , patientweight as value_as_number
        , null::integer as value_as_concept_id
        , 9529 as unit_concept_id --kilogram
	, null::numeric as range_low
	, null::numeric as range_high
        , caregivers.provider_id
        , visit_occurrence_id
        , null::text as measurement_source_value
        , null::integer as measurement_source_concept_id
        , null::text as unit_source_value
        , null::text as value_source_value
	FROM inputevents_mv
        LEFT JOIN patients USING (subject_id)
        LEFT JOIN caregivers USING (cgid)
        LEFT JOIN admissions USING (hadm_id)
	WHERE patientweight is not null
)
INSERT INTO omop.measurement
(
	  measurement_id
	, person_id
	, measurement_concept_id
	, measurement_date
	, measurement_datetime
	, measurement_type_concept_id
	, operator_concept_id
	, value_as_number
	, value_as_concept_id
	, unit_concept_id
	, range_low
	, range_high
	, provider_id
	, visit_occurrence_id
	, visit_detail_id
	, measurement_source_value
	, measurement_source_concept_id
	, unit_source_value
	, value_source_value
)
SELECT
  row_to_insert.measurement_id
, row_to_insert.person_id
, row_to_insert.measurement_concept_id
, row_to_insert.measurement_date
, row_to_insert.measurement_datetime
, row_to_insert.measurement_type_concept_id
, row_to_insert.operator_concept_id
, row_to_insert.value_as_number
, row_to_insert.value_as_concept_id
, row_to_insert.unit_concept_id
, row_to_insert.range_low
, row_to_insert.range_high
, row_to_insert.provider_id
, row_to_insert.visit_occurrence_id
, visit_detail_assign.visit_detail_id
, row_to_insert.measurement_source_value
, row_to_insert.measurement_source_concept_id
, row_to_insert.unit_source_value
, row_to_insert.value_source_value
FROM row_to_insert
LEFT JOIN omop.visit_detail_assign
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND
(--only one visit_detail
(is_first IS TRUE AND is_last IS TRUE)
OR -- first
(is_first IS TRUE AND is_last IS FALSE AND row_to_insert.measurement_datetime <= visit_detail_assign.visit_end_datetime)
OR -- last
(is_last IS TRUE AND is_first IS FALSE AND row_to_insert.measurement_datetime > visit_detail_assign.visit_start_datetime)
OR -- middle
(is_last IS FALSE AND is_first IS FALSE AND row_to_insert.measurement_datetime > visit_detail_assign.visit_start_datetime AND row_to_insert.measurement_datetime <= visit_detail_assign.visit_end_datetime)
)
;
