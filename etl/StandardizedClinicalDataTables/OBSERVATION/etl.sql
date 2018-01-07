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
      , to_datetime(datetimeevents.observation_datetime) as observation_datetime
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
      , to_datetime(adm.ADMITTIME) as observation_datetime
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
      , to_datetime(adm.admittime) as observation_datetime
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
      , to_datetime(adm.admittime) as observation_datetime
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
      , to_datetime(adm.admittime) as observation_datetime
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
      , to_datetime(adm.admittime) as observation_datetime
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
