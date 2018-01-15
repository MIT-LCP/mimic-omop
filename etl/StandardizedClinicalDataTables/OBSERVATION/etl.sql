 WITH 
"datetimeevents" AS (SELECT subject_id, hadm_id, itemid, cgid, mimic_id as observation_id, coalesce(value,charttime)::date as observation_date, value as observation_datetime FROM datetimeevents),
"patients" AS (SELECT subject_id, mimic_id as person_id FROM patients),
"caregivers" AS (SELECT cgid, mimic_id as provider_id FROM caregivers),
"admissions" AS (SELECT subject_id, hadm_id, mimic_id as visit_occurrence_id, insurance, marital_status, language, diagnosis, religion, ethnicity, admittime FROM admissions),
"d_items" AS (SELECT itemid, label as value_as_string FROM d_items),
"gcpt_insurance_to_concept" AS (SELECT * FROM gcpt_insurance_to_concept),
"gcpt_ethnicity_to_concept" AS (SELECT * FROM gcpt_ethnicity_to_concept),
"gcpt_religion_to_concept" AS (SELECT * FROM gcpt_religion_to_concept),
"gcpt_marital_status_to_concept" AS (SELECT * FROM gcpt_marital_status_to_concept),
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
UNION ALL
-- SELECT
--     adm.HADM_ID * 10 as observation_id,
--     adm.SUBJECT_ID as person_id, 
--     adm.ADMITTIME::date as observation_date,
--     adm.ADMITTIME as observation_datetime,
--     46236615 as observation_concept_id, -- Admission priority
--     38000280 as observation_type_concept_id, -- Observation recorded from EHR
--     map.concept_id as value_as_concept_id, 
--     adm.ADMISSION_TYPE as value_as_string
--   FROM
--     admissions as adm
--     JOIN `chc-mimic3_omop.admission_type_to_concept` as map
--     ON adm.ADMISSION_TYPE = map.ADMISSION_TYPE
-- UNION ALL 
  SELECT
        nextval('mimic_id_seq') AS observation_id
      , patients.person_id
      , 46235654 as observation_concept_id -- Primary insurance
      , adm.ADMITTIME::date as observation_date
      , (adm.ADMITTIME) as observation_datetime
      , 38000280 as observation_type_concept_id -- Observation recorded from EHR
      , null as value_as_number
      , adm.INSURANCE as value_as_string
      , null as value_as_concept_id
      , null as qualifier_concept_id
      , map.concept_id as value_as_concept_id 
      , null as provider_id
      , adm.visit_occurrence_id
      , null as  visit_detail_id
      , null as observation_source_value
      , null as observation_source_concept_id
      , null as unit_source_value
      , null as qualifier_source_value
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
      , null as value_as_concept_id
      , null as qualifier_concept_id
      , map.concept_id as value_as_concept_id
      , null as provider_id
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
      , null as value_as_concept_id
      , null as qualifier_concept_id
      , map.concept_id as value_as_concept_id
      , null as provider_id
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
-- UNION ALL 
--   SELECT
--         adm.HADM_ID * 10 + 4 as observation_id
--       , patients.person_id
--       , 4143467 as observation_concept_id -- Chief complaint
--       , adm.admittime::date as observation_date
--       , adm.admittime as observation_datetime
--       , 38000280 as observation_type_concept_id -- Observation recorded from EHR
--       , null as value_as_number
--       , adm.diagnosis as value_as_string
--       , null as value_as_concept_id
--       , null as qualifier_concept_id
--       , null as value_as_concept_id
--       , null as provider_id
--       , adm.visit_occurrence_id
--       , null as visit_detail_id
--       , null as observation_source_value
--       , null as observation_source_concept_id
--       , null as unit_source_value
--       , null as qualifier_source_value
--   FROM admissions as adm
--     LEFT JOIN patients USING (subject_id)
--   WHERE
--     adm.diagnosis IS NOT NULL
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
      , null as  value_as_concept_id 
      , null as provider_id
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
      , null as value_as_concept_id
      , null as qualifier_concept_id
      , map.race_concept_id as value_as_concept_id
      , null as provider_id
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
 INSERT INTO omop.OBSERVATION 
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
LEFT JOIN omop.visit_detail_assign 
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND observation_concept_id = 4085802 --other datetime comes from admissions admittime and are not relevant
AND row_to_insert.observation_datetime IS NOT NULL
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
"gcpt_drgcode_to_concept" AS (SELECT description, concept_id AS value_as_concept_id FROM gcpt_drgcode_to_concept),
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
        , coalesce(value_as_concept_id, 0) as value_as_concept_id
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
INSERT INTO omop.observation
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
        chartevents.itemid
             , chartevents.mimic_id as observation_id
             , subject_id
             , cgid
             , hadm_id
             , charttime as observation_datetime
             , value as value_as_string
             , valuenum as value_as_number --paradoxally, the text is sometime joined by numeric values
             , d_items.mimic_id as observation_source_concept_id
             , d_items.label as observation_source_value
          FROM chartevents
          JOIN d_items
            ON (d_items.itemid = chartevents.itemid AND param_type = 'Text')
	WHERE label NOT IN  --these are discrete values -> go to measurement
	(
		  'Visual Disturbances'
		, 'Tremor (CIWA)'
		, 'Strength R Leg'
		, 'Strength R Arm'
		, 'Strength L Leg'
		, 'Strength L Arm'
		, 'Riker-SAS Scale'
		, 'Richmond-RAS Scale'
		, 'Pressure Ulcer Stage #2'
		, 'Pressure Ulcer Stage #1'
		, 'PAR-Respiration'
		, 'Paroxysmal Sweats'
		, 'PAR-Oxygen saturation'
		, 'PAR-Consciousness'
		, 'PAR-Circulation'
		, 'PAR-Activity'
		, 'Pain Level Response'
		, 'Pain Level'
		, 'Nausea and Vomiting (CIWA)'
		, 'Headache'
		, 'Goal Richmond-RAS Scale'
		, 'GCS - Verbal Response'
		, 'GCS - Motor Response'
		, 'GCS - Eye Opening'
		, 'Braden Sensory Perception'
		, 'Braden Nutrition'
		, 'Braden Moisture'
		, 'Braden Mobility'
	)
	AND error = 0
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
INSERT INTO omop.observation
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
LEFT JOIN omop.visit_detail_assign 
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND row_to_insert.observation_datetime IS NOT NULL
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

-- TODO weight from inputevent_mv
