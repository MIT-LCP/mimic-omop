 -- from datetimeevents
 WITH
"datetimeevents" AS (SELECT subject_id, hadm_id, itemid, cgid, mimic_id as observation_id, coalesce(value,charttime)::date as observation_date, value as observation_datetime FROM datetimeevents where error is null or error = 0),
"patients" AS (SELECT subject_id, mimic_id as person_id FROM patients),
"caregivers" AS (SELECT cgid, mimic_id as provider_id FROM caregivers),
"admissions" AS (SELECT subject_id, hadm_id, mimic_id as visit_occurrence_id, insurance, marital_status, language, diagnosis, religion, ethnicity, admittime FROM admissions),
"d_items" AS (SELECT itemid, label as value_as_string FROM d_items),
"row_to_insert" AS
 (SELECT
        datetimeevents.observation_id
      , patients.person_id
      , 4085802 as observation_concept_id -- Referred by nurse
      , datetimeevents.observation_date
      , (datetimeevents.observation_datetime) as observation_datetime
      , 38000280 as observation_type_concept_id -- Observation recorded from EHR
      , null::double precision as value_as_number
      , d_items.value_as_string as value_as_string
      , null::bigint as value_as_concept_id
      , null::bigint as qualifier_concept_id
      , null::bigint as unit_concept_id
      , caregivers.provider_id
      , admissions.visit_occurrence_id
      , null::bigint as  visit_detail_id
      , null::text as observation_source_value
      , null::bigint as observation_source_concept_id
      , null as unit_source_value
      , null as qualifier_source_value
   FROM datetimeevents
 LEFT JOIN patients USING (subject_id)
 LEFT JOIN admissions USING (hadm_id)
 LEFT JOIN caregivers USING (cgid)
 LEFT JOIN d_items USING (itemid)
)
INSERT INTO :OMOP_SCHEMA.OBSERVATION
(
    observation_id
  , person_id
  , observation_concept_id
  , observation_date
  , observation_datetime
  , observation_type_concept_id
  , value_as_number
  , value_as_string
  , value_as_concept_id
  , qualifier_concept_id
  , unit_concept_id
  , provider_id
  , visit_occurrence_id
  , visit_detail_id
  , observation_source_value
  , observation_source_concept_id
  , unit_source_value
  , qualifier_source_value
)
SELECT
  observation_id
, person_id
, observation_concept_id
, observation_date
, observation_datetime
, observation_type_concept_id
, value_as_number
, value_as_string
, value_as_concept_id
, qualifier_concept_id
, unit_concept_id
, provider_id
, row_to_insert.visit_occurrence_id
, visit_detail_assign.visit_detail_id
, observation_source_value
, observation_source_concept_id
, unit_source_value
, qualifier_source_value
FROM row_to_insert
LEFT JOIN :OMOP_SCHEMA.visit_detail_assign
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND
(--only one visit_detail
(is_first IS TRUE AND is_last IS TRUE)
OR -- first
(is_first IS TRUE AND is_last IS FALSE AND row_to_insert.observation_datetime <= visit_detail_assign.visit_end_datetime)
OR -- last
(is_last IS TRUE AND is_first IS FALSE AND row_to_insert.observation_datetime > visit_detail_assign.visit_start_datetime)
OR -- middle
(is_last IS FALSE AND is_first IS FALSE AND row_to_insert.observation_datetime > visit_detail_assign.visit_start_datetime AND row_to_insert.observation_datetime <= visit_detail_assign.visit_end_datetime)
)
;

-- from admissions
WITH
"patients" AS (SELECT subject_id, mimic_id as person_id FROM patients),
"caregivers" AS (SELECT cgid, mimic_id as provider_id FROM caregivers),
"admissions" AS (SELECT subject_id, hadm_id, mimic_id as visit_occurrence_id, insurance, marital_status, language, diagnosis, religion, ethnicity, admittime FROM admissions),
"gcpt_insurance_to_concept" AS (SELECT * FROM gcpt_insurance_to_concept),
"gcpt_ethnicity_to_concept" AS (SELECT * FROM gcpt_ethnicity_to_concept),
"gcpt_religion_to_concept" AS (SELECT * FROM gcpt_religion_to_concept),
"gcpt_marital_status_to_concept" AS (SELECT * FROM gcpt_marital_status_to_concept),
"row_to_insert" AS (
  SELECT
        nextval('mimic_id_seq') AS observation_id
      , patients.person_id
      , 46235654 as observation_concept_id -- Primary insurance
      , adm.ADMITTIME::date as observation_date
      , (adm.ADMITTIME) as observation_datetime
      , 38000280 as observation_type_concept_id -- Observation recorded from EHR
      , null::double precision as value_as_number
      , adm.INSURANCE as value_as_string
      , map.concept_id as value_as_concept_id
      , null::integer as qualifier_concept_id
      , null::integer as provider_id
      , null::integer as unit_concept_id
      , adm.visit_occurrence_id
      , null::integer as  visit_detail_id
      , null::text as observation_source_value
      , null::integer as observation_source_concept_id
      , null::text as unit_source_value
      , null::text as qualifier_source_value
  FROM admissions as adm
    LEFT JOIN gcpt_insurance_to_concept AS map USING (insurance)
    LEFT JOIN patients USING (subject_id)
  WHERE adm.insurance IS NOT NULL
UNION ALL
  SELECT
        nextval('mimic_id_seq') AS observation_id
      , patients.person_id
      , 40766231 as observation_concept_id -- Marital status
      , adm.admittime::date as observation_date
      , (adm.admittime) as observation_datetime
      , 38000280 as observation_type_concept_id -- Observation recorded from EHR
      , null as value_as_number
      , adm.marital_status as value_as_string
      , map.concept_id as value_as_concept_id
      , null as qualifier_concept_id
      , null as provider_id
      , null::integer as unit_concept_id
      , adm.visit_occurrence_id
      , null as visit_detail_id
      , null as observation_source_value
      , null as observation_source_concept_id
      , null as unit_source_value
      , null as qualifier_source_value
  FROM admissions as adm
    LEFT JOIN gcpt_marital_status_to_concept as map USING (marital_status)
    LEFT JOIN patients USING (subject_id)
  WHERE adm.marital_status IS NOT NULL
UNION ALL
  SELECT
        nextval('mimic_id_seq') AS observation_id
      , patients.person_id
      , 4052017 as observation_concept_id -- Religious affiliation
      , adm.admittime::date as observation_date
      , (adm.admittime) as observation_datetime
      , 38000280 as observation_type_concept_id -- Observation recorded from EHR
      , null as value_as_number
      , adm.religion as value_as_string
      , map.concept_id as value_as_concept_id
      , null as qualifier_concept_id
      , null as provider_id
      , null::integer as unit_concept_id
      , adm.visit_occurrence_id
      , null as visit_detail_id
      , null as observation_source_value
      , null as observation_source_concept_id
      , null as unit_source_value
      , null as qualifier_source_value
  FROM admissions as adm
    JOIN gcpt_religion_to_concept as map USING (religion)
    LEFT JOIN patients USING (subject_id)
  WHERE adm.religion IS NOT NULL
UNION ALL
  SELECT
        nextval('mimic_id_seq') AS observation_id
      , patients.person_id
      , 40758030 as observation_concept_id -- Language.preferred
      , adm.admittime::date as observation_date
      , (adm.admittime) as observation_datetime
      , 38000280 as observation_type_concept_id -- Observation recorded from EHR
      , null as value_as_number
      , adm.language as value_as_string
      , null as value_as_concept_id
      , null as qualifier_concept_id
      , null as provider_id
      , null::integer as unit_concept_id
      , adm.visit_occurrence_id
      , null as visit_detail_id
      , null as observation_source_value
      , null as observation_source_concept_id
      , null as unit_source_value
      , null as qualifier_source_value
  FROM admissions as adm
    LEFT JOIN patients USING (subject_id)
  WHERE
    adm.language IS NOT NULL
UNION ALL
  SELECT
        nextval('mimic_id_seq') AS observation_id
      , patients.person_id
      , 44803968 as observation_concept_id -- Ethnicity - National Public Health Classification
      , adm.admittime::date as observation_date
      , (adm.admittime) as observation_datetime
      , 38000280 as observation_type_concept_id -- Observation recorded from EHR
      , null as value_as_number
      , adm.ethnicity as value_as_string
      , map.race_concept_id as value_as_concept_id
      , null as qualifier_concept_id
      , null as provider_id
      , null::integer as unit_concept_id
      , adm.visit_occurrence_id
      , null as visit_detail_id
      , null as observation_source_value
      , null as observation_source_concept_id
      , null as unit_source_value
      , null as qualifier_source_value
  FROM admissions as adm
    JOIN gcpt_ethnicity_to_concept as map USING (ethnicity)
    LEFT JOIN patients USING (subject_id)
  WHERE adm.ethnicity IS NOT NULL)
 INSERT INTO :OMOP_SCHEMA.OBSERVATION
SELECT
          observation_id
        , person_id
        , observation_concept_id
        , observation_date
        , observation_datetime
        , observation_type_concept_id
        , value_as_number
        , value_as_string
        , value_as_concept_id
        , qualifier_concept_id
        , unit_concept_id
        , provider_id
        , row_to_insert.visit_occurrence_id
        , visit_detail_id
        , observation_source_value
        , observation_source_concept_id
        , unit_source_value
        , qualifier_source_value
FROM row_to_insert
;

-- drgcodes
WITH
"drgcodes" AS (
SELECT
  mimic_id as observation_id
, subject_id
, hadm_id
, description
FROM drgcodes
),
"gcpt_drgcode_to_concept" AS (SELECT description, non_standard_concept_id, standard_concept_id FROM gcpt_drgcode_to_concept),
"patients" AS (SELECT subject_id, mimic_id as person_id FROM patients),
"admissions" AS (SELECT subject_id, hadm_id, mimic_id as visit_occurrence_id, coalesce(edregtime, admittime) as observation_datetime FROM admissions),
"row_to_insert" AS (
SELECT
          observation_id
        , person_id
        , 4296248 as observation_concept_id -- Cost containment drgcode should be in cost table apparently.... http://forums.ohdsi.org/t/most-appropriate-omop-table-to-house-drg-information/1591/9
        , observation_datetime::date as observation_date
        , observation_datetime
        , 38000280 as observation_type_concept_id -- Observation recorded from EHR
        , null::numeric value_as_number
        , description as value_as_string
        , coalesce(standard_concept_id, non_standard_concept_id, 0) as value_as_concept_id
        , null::integer qualifier_concept_id
        , null::integer unit_concept_id
        , null::integer provider_id
        , visit_occurrence_id
        , null::integer visit_detail_id
        , null::text observation_source_value
        , null::integer observation_source_concept_id
        , null::text unit_source_value
        , null::text qualifier_source_value
	FROM drgcodes
	LEFT JOIN patients USING (subject_id)
	LEFT JOIN admissions USING (hadm_id)
	LEFT JOIN gcpt_drgcode_to_concept USING (description)
)
INSERT INTO :OMOP_SCHEMA.observation
SELECT
          observation_id
        , person_id
        , observation_concept_id
        , observation_date
        , observation_datetime
        , observation_type_concept_id
        , value_as_number
        , value_as_string
        , value_as_concept_id
        , qualifier_concept_id
        , unit_concept_id
        , provider_id
        , visit_occurrence_id
        , visit_detail_id
        , observation_source_value
        , observation_source_concept_id
        , unit_source_value
        , qualifier_source_value
FROM row_to_insert;


-- Chartevents.text
WITH
"chartevents_text" AS (
        SELECT
               chartevents.mimic_id as observation_id
             , subject_id
             , cgid
             , hadm_id
             , charttime as observation_datetime
             , value as value_as_string
             , valuenum as value_as_number
             , concept.concept_id as observation_source_concept_id
             , concept.concept_code as observation_source_value
          FROM chartevents
	  JOIN :OMOP_SCHEMA.concept ON  -- concept driven dispatcher
		(           concept_code  = itemid::Text
			AND domain_id     = 'Observation'
			AND vocabulary_id = 'MIMIC d_items'
		)
	WHERE error IS NULL OR error= 0
       ),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"caregivers" AS (SELECT mimic_id AS provider_id, cgid FROM caregivers),
"row_to_insert" AS (
SELECT
          observation_id
        , person_id
        , 0 as observation_concept_id
        , observation_datetime::date observation_date
        , observation_datetime
        , 581413 as observation_type_concept_id -- Observation from Measurement
        , value_as_number
        , value_as_string
        , null::integer value_as_concept_id
        , null::integer qualifier_concept_id
        , null::integer unit_concept_id
        , provider_id
        , visit_occurrence_id
        , null::integer visit_detail_id
        , observation_source_value
        , observation_source_concept_id
        , null::integer unit_source_value
        , null::text qualifier_source_value
        FROM chartevents_text
        LEFT JOIN patients USING (subject_id)
        LEFT JOIN caregivers USING (cgid)
        LEFT JOIN admissions USING (hadm_id))
INSERT INTO :OMOP_SCHEMA.observation
SELECT
          observation_id
        , person_id
        , observation_concept_id
        , observation_date
        , observation_datetime
        , observation_type_concept_id
        , value_as_number
        , value_as_string
        , value_as_concept_id
        , qualifier_concept_id
        , unit_concept_id
        , provider_id
        , row_to_insert.visit_occurrence_id
        , visit_detail_assign.visit_detail_id
        , observation_source_value
        , observation_source_concept_id
        , unit_source_value
        , qualifier_source_value
FROM row_to_insert
LEFT JOIN :OMOP_SCHEMA.visit_detail_assign
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND
(--only one visit_detail
(is_first IS TRUE AND is_last IS TRUE)
OR -- first
(is_first IS TRUE AND is_last IS FALSE AND row_to_insert.observation_datetime <= visit_detail_assign.visit_end_datetime)
OR -- last
(is_last IS TRUE AND is_first IS FALSE AND row_to_insert.observation_datetime > visit_detail_assign.visit_start_datetime)
OR -- middle
(is_last IS FALSE AND is_first IS FALSE AND row_to_insert.observation_datetime > visit_detail_assign.visit_start_datetime AND row_to_insert.observation_datetime <= visit_detail_assign.visit_end_datetime)
)
;
