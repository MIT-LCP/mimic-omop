-- LABS FROM labevents
WITH
"labs_value_purif" as (SELECT *, regexp_replace(regexp_replace(trim(value), 'LE[SE]S THAN ','<'),'GREATER TH[AE]N ','>') as value_purif from mimic.labevents),
"labevents" AS (SELECT mimic_id as measurement_id, subject_id, charttime as measurement_datetime, hadm_id , itemid, valueuom as unit_source_value, value as value_source_value,
        CASE WHEN value_purif ~ '^[+-]*[0-9.,]+$' THEN  '=' ELSE substring(value_purif,'^(<=|>=|<|>)') END as operator_name,
                CASE WHEN value_purif ~ '^(>=|<=|>|<){0,1}[+-]*([.,]{1}[0-9]+|[0-9]+[,.]{0,1}[0-9]*)$'
                        THEN regexp_replace(regexp_replace(value_purif,'[^0-9+-.]*([+-]*[0-9.,]+)', E'\\1','g'),'([0-9]+)([,]+)([0-9]*)',E'\\1.\\3','g')::double precision
                ELSE null::double precision END as value_as_number
                        FROM labs_value_purif),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"d_labitems" AS (SELECT itemid, loinc_code as label, mimic_id FROM d_labitems),
"gcpt_lab_label_to_concept" AS (SELECT label, concept_id as measurement_concept_id FROM gcpt_lab_label_to_concept),
"omop_loinc" AS (SELECT concept_id AS measurement_concept_id, concept_code as label FROM omop.concept WHERE vocabulary_id = 'LOINC' AND domain_id = 'Measurement'),
"omop_operator" AS (SELECT concept_name as operator_name, concept_id as operator_concept_id FROM omop.concept WHERE  domain_id ilike 'Meas Value Operator'),
"gcpt_lab_unit_to_concept" AS (SELECT unit as unit_source_value, concept_id as unit_concept_id FROM gcpt_lab_unit_to_concept),
"row_to_insert" AS (
SELECT
  labevents.measurement_id                 
, patients.person_id                     
, coalesce(omop_loinc.measurement_concept_id, gcpt_lab_label_to_concept.measurement_concept_id, 0) as measurement_concept_id     
, labevents.measurement_datetime::date AS measurement_date              
, to_datetime(labevents.measurement_datetime) AS measurement_datetime          
, 44818702 AS measurement_type_concept_id -- Lab result
, operator_concept_id AS operator_concept_id -- = operator
, labevents.value_as_number AS value_as_number               
, null::bigint AS value_as_concept_id           
, gcpt_lab_unit_to_concept.unit_concept_id               
, null::double precision AS range_low                     
, null::double precision AS range_high                    
, null::bigint AS provider_id                   
, admissions.visit_occurrence_id AS visit_occurrence_id           
, null::bigint As visit_detail_id               
, d_labitems.label AS measurement_source_value      
, d_labitems.mimic_id AS measurement_source_concept_id 
, gcpt_lab_unit_to_concept.unit_source_value             
, labevents.value_source_value            
, null::bigint AS quality_concept_id            
FROM labevents
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN d_labitems USING (itemid)
LEFT JOIN omop_loinc USING (label)
LEFT JOIN omop_operator USING (operator_name)
LEFT JOIN gcpt_lab_label_to_concept USING (label)
LEFT JOIN gcpt_lab_unit_to_concept USING (unit_source_value))
INSERT INTO omop.measurement
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
, row_to_insert.quality_concept_id
FROM row_to_insert;

-- LABS from chartevents
WITH
"chartevents_lab" AS ( SELECT chartevents.itemid, chartevents.mimic_id as measurement_id , subject_id , hadm_id ,charttime as measurement_datetime,  value as value_source_value , substring(value,'^(<=|>=|<|>)') as operator_name , CASE WHEN trim(value) ~ '^(>=|<=|>|<){0,1}[+-]*([.,]{1}[0-9]+|[0-9]+[,.]{0,1}[0-9]*)$' THEN regexp_replace(regexp_replace(trim(value),'[^0-9+-.]*([+-]*[0-9.,]+)', E'\\1','g'),'([0-9]+)([,]+)([0-9]*)',E'\\1.\\3','g')::double precision ELSE null::double precision END as value_as_number , valueuom AS unit_source_value FROM chartevents JOIN d_items ON (d_items.itemid=chartevents.itemid AND category = 'Labs')),
"d_items" AS (SELECT itemid, label, mimic_id FROM d_items),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"omop_operator" AS (SELECT concept_name as operator_name, concept_id as operator_concept_id FROM omop.concept WHERE  domain_id ilike 'Meas Value Operator'),
"omop_loinc" AS (SELECT distinct on (concept_name) concept_id AS measurement_concept_id, concept_name as label FROM omop.concept WHERE vocabulary_id = 'LOINC' AND domain_id = 'Measurement' AND standard_concept = 'S'),
"gcpt_lab_label_to_concept" AS (SELECT label, concept_id as measurement_concept_id FROM gcpt_lab_label_to_concept),
"gcpt_lab_unit_to_concept" AS (SELECT unit as unit_source_value, concept_id as unit_concept_id FROM gcpt_lab_unit_to_concept),
"row_to_insert" AS (SELECT 
  chartevents_lab.measurement_id                 
, patients.person_id                     
, coalesce(omop_loinc.measurement_concept_id, gcpt_lab_label_to_concept.measurement_concept_id, 0) as measurement_concept_id     
, chartevents_lab.measurement_datetime::date AS measurement_date              
, to_datetime(chartevents_lab.measurement_datetime) AS measurement_datetime          
, 44818702 AS measurement_type_concept_id -- Lab result
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
, null::bigint AS quality_concept_id            
  FROM chartevents_lab
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN d_items USING (itemid)
LEFT JOIN omop_loinc USING (label)
LEFT JOIN omop_operator USING (operator_name)
LEFT JOIN gcpt_lab_label_to_concept USING (label)
LEFT JOIN gcpt_lab_unit_to_concept USING (unit_source_value))
INSERT INTO omop.measurement
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
, row_to_insert.quality_concept_id
FROM row_to_insert;

-- Microbiology
-- TODO: Map the culture & drug sensitivity
WITH 
"culture" AS (SELECT DISTINCT ON (subject_id, chartdate, spec_itemid, org_name) spec_itemid, mimic_id as measurement_id, chartdate as measurement_date , charttime as measurement_time , subject_id , hadm_id, org_name, spec_type_desc as measurement_source_value FROM microbiologyevents ),
"resistance" AS (SELECT spec_itemid, nextval('mimic_id_seq') as measurement_id, chartdate as measurement_date , charttime as measurement_time , subject_id , hadm_id , CASE WHEN dilution_comparison = '=>' THEN '>=' ELSE dilution_comparison END as operator_name ,CASE WHEN trim(dilution_text) ~ '^(<=|=>|>|<){0,1}[+-]*([.,]{1}[0-9]+|[0-9]+[,.]{0,1}[0-9]*)$' THEN regexp_replace(regexp_replace(trim(dilution_text),'[^0-9+-.]*([+-]*[0-9.,]+)', E'\\1','g'),'([0-9]+)([,]+)([0-9]*)',E'\\1.\\3','g')::double precision ELSE null::double precision END as value_as_number , ab_name as measurement_source_value , interpretation , dilution_text as value_source_value, org_name FROM microbiologyevents WHERE dilution_text IS NOT NULL) , 
"fact_relationship" AS (SELECT culture.measurement_id as fact_id_1, resistance.measurement_id AS fact_id_2 FROM resistance LEFT JOIN culture USING (subject_id, measurement_date, spec_itemid, org_name)),
"insert_fact_relationship" AS (
    INSERT INTO omop.fact_relationship
    SELECT 
      21 AS domain_concept_id_1 -- Measurement
    , fact_id_1
    , 21 AS domain_concept_id_2 -- Measurement
    , fact_id_2 
    , 44818757 as relationship_concept_id -- Has interpretation (SNOMED)
    FROM fact_relationship 
    RETURNING *),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"omop_operator" AS (SELECT concept_name as operator_name, concept_id as operator_concept_id FROM omop.concept WHERE  domain_id ilike 'Meas Value Operator'),
"gcpt_resistance_to_concept" AS (SELECT * FROM gcpt_resistance_to_concept),
"gcpt_org_name_to_concept" AS (SELECT org_name, concept_id AS value_as_concept_id FROM gcpt_org_name_to_concept JOIN omop.concept ON (concept_code = snomed::text AND vocabulary_id = 'SNOMED')),
"row_to_insert" AS (SELECT
  culture.measurement_id AS measurement_id
, patients.person_id
, 4098207  as measurement_concept_id      -- --30088009 -- Blood Culture but not done yet
, measurement_date AS measurement_date
, to_datetime(measurement_time) AS measurement_datetime
, 44818702 AS measurement_type_concept_id -- Lab result
, null AS operator_concept_id
, null value_as_number
, CASE WHEN org_name IS NULL THEN 9189 ELSE coalesce(gcpt_org_name_to_concept.value_as_concept_id, 0) END AS value_as_concept_id           -- staphiloccocus OR negative in case nothing
, null::bigint AS unit_concept_id
, null::double precision AS range_low
, null::double precision AS range_high
, null::bigint AS provider_id
, admissions.visit_occurrence_id AS visit_occurrence_id
, null::bigint As visit_detail_id
, culture.measurement_source_value AS measurement_source_value -- BLOOD ...
, null::bigint AS measurement_source_concept_id
, null::text AS unit_source_value
, culture.org_name AS value_source_value -- Staph...
, null::bigint AS quality_concept_id
FROM culture
LEFT JOIN gcpt_org_name_to_concept USING (org_name)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
UNION ALL
SELECT
  measurement_id AS measurement_id                 
, patients.person_id                     
, 4170475  as measurement_concept_id      -- Culture Sensitivity
, measurement_date AS measurement_date              
, to_datetime(measurement_time) AS measurement_datetime          
, 44818702 AS measurement_type_concept_id -- Lab result
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
, null::bigint AS measurement_source_concept_id 
, null::text AS unit_source_value             
, value_source_value AS  value_source_value            
, null::bigint AS quality_concept_id            
FROM resistance
LEFT JOIN gcpt_resistance_to_concept USING (interpretation)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN omop_operator USING (operator_name))
INSERT INTO omop.measurement
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
, row_to_insert.quality_concept_id
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
      d.mimic_id as measurement_source_concept_id,
      c.valueuom as unit_source_value, 
      CASE
        WHEN m.label_type = 'systolic_bp' AND value ~ '/' THEN regexp_replace(value,'(\\d+)/','\\1','b')::double precision 
        WHEN m.label_type = 'diastolic_bp' AND value ~ '/' THEN regexp_replace(value,'/(\\d+)','\\1','b')::double precision 
        WHEN m.label_type = 'map_bp' AND value ~ '/' THEN map_bp_calc(value)
        WHEN m.label_type = 'fio2' AND c.valuenum between 0 AND 1 THEN c.valuenum * 100
	WHEN m.label_type = 'temperature' AND c.VALUENUM > 85 THEN (c.VALUENUM - 32)*5/9
	WHEN m.label_type = 'pain_level' THEN CASE 
		WHEN d.LABEL ~* 'level' THEN CASE
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
                WHEN d.LABEL ~ '^Riker' THEN CASE 
                      WHEN c.VALUENUM IS NULL THEN CASE 
                           WHEN c.VALUE ~ 'Calm' THEN 0
                           WHEN c.VALUE ~ 'Unarous' OR c.VALUE ~ '(Sedated)' THEN -1
                           WHEN c.VALUE ~ 'Agitated' THEN 1
                           ELSE NULL 
                           END
                      WHEN c.VALUENUM < 4 THEN -1
                      WHEN c.VALUENUM = 4 THEN 0
                      WHEN c.VALUENUM > 4 THEN 1
                      ELSE NULL 
                      END
               WHEN c.VALUENUM < 0 THEN -1
               WHEN c.VALUENUM = 0 THEN 0
          WHEN c.VALUENUM > 0 THEN 1
          ELSE NULL 
        END
	WHEN m.label_type = 'height_weight'  THEN CASE
		WHEN d.LABEL ~ 'W' THEN CASE
	           WHEN d.LABEL ~* 'lb' THEN 0.453592 * c.VALUENUM
		   ELSE NULL
		   END
		ELSE 0.0254 * c.VALUENUM
		END
	ELSE NULL
	END AS valuenum_fromvalue,
      c.value as value_source_value, 
      m.value_lb as value_lb,
      m.value_ub as value_ub,
      m.label_type
    FROM chartevents as c
    JOIN d_items as d ON (d.itemid=c.itemid AND category != 'Labs' AND param_type != 'Text')  -- remove the labs, because done before ; Text are put into observation
    JOIN gcpt_chart_label_to_concept as m 
      ON (label = d_label)
    LEFT JOIN (SELECT mimic_name, concept_id, 'heart_rhythm'::text AS label_type FROM gcpt_heart_rhythm_to_concept) as v 
      ON m.label_type = v.label_type AND c.value = v.mimic_name
  ),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"caregivers" AS (SELECT mimic_id AS provider_id, cgid FROM caregivers),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"row_to_insert" AS (SELECT
  measurement_id AS measurement_id                 
, patients.person_id                     
, measurement_concept_id as measurement_concept_id      
, measurement_datetime::date AS measurement_date              
, to_datetime(measurement_datetime) AS measurement_datetime          
, 44818701 as measurement_type_concept_id 
, 4172703 AS operator_concept_id 
, coalesce(valuenum_fromvalue, value_as_number) AS value_as_number               
, value_as_concept_id AS value_as_concept_id           
, unit_concept_id AS unit_concept_id               
, value_lb AS range_low                     
, value_ub AS range_high                    
, caregivers.provider_id AS provider_id                   
, admissions.visit_occurrence_id AS visit_occurrence_id           
, null::bigint As visit_detail_id               
, null::text AS measurement_source_value      
, measurement_source_concept_id AS measurement_source_concept_id 
, unit_source_value AS unit_source_value             
, value_source_value AS  value_source_value            
, null::bigint AS quality_concept_id            
FROM chartevents
LEFT JOIN patients USING (subject_id)
LEFT JOIN caregivers USING (cgid)
LEFT JOIN admissions USING (hadm_id))
INSERT INTO omop.measurement
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
, row_to_insert.quality_concept_id
FROM row_to_insert
LEFT JOIN omop.visit_detail_assign 
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND row_to_insert.measurement_datetime IS NOT NULL
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
),
"gcpt_output_label_to_concept" AS (SELECT item_id as itemid, concept_id as measurement_concept_id FROM gcpt_output_label_to_concept),
"gcpt_lab_unit_to_concept" AS (SELECT unit as unit_source_value, concept_id as unit_concept_id FROM gcpt_lab_unit_to_concept),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"caregivers" AS (SELECT mimic_id AS provider_id, cgid FROM caregivers),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"row_to_insert" AS (SELECT
  measurement_id AS measurement_id                 
, patients.person_id                     
, measurement_concept_id as measurement_concept_id      
, measurement_datetime::date AS measurement_date              
, to_datetime(measurement_datetime) AS measurement_datetime          
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
, null::text AS measurement_source_value      
, d_items.mimic_id AS measurement_source_concept_id 
, outputevents.unit_source_value AS unit_source_value             
, null::text AS value_source_value            
, null::bigint AS quality_concept_id            
FROM outputevents
LEFT JOIN gcpt_output_label_to_concept USING (itemid)
LEFT JOIN gcpt_lab_unit_to_concept ON gcpt_lab_unit_to_concept.unit_source_value ilike outputevents.unit_source_value
LEFT JOIN d_items USING (itemid)
LEFT JOIN patients USING (subject_id)
LEFT JOIN caregivers USING (cgid)
LEFT JOIN admissions USING (hadm_id))
INSERT INTO omop.measurement
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
, row_to_insert.quality_concept_id
FROM row_to_insert
LEFT JOIN omop.visit_detail_assign 
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND row_to_insert.measurement_datetime IS NOT NULL
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

