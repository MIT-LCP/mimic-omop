WITH
"proc_icd" as (SELECT mimic_id as procedure_occurrence_id, subject_id, hadm_id, icd9_code as procedure_source_value, CASE WHEN length(cast(ICD9_CODE as text)) = 2 THEN cast(ICD9_CODE as text) ELSE concat(substr(cast(ICD9_CODE as text), 1, 2), '.', substr(cast(ICD9_CODE as text), 3)) END AS concept_code FROM procedures_icd),
"local_proc_icd" AS (SELECT concept_id as procedure_source_concept_id, concept_code as procedure_source_value FROM :OMOP_SCHEMA.concept WHERE domain_id = 'd_icd_procedures' AND vocabulary_id = 'MIMIC Local Codes'),
"concept_proc_icd9" as ( SELECT concept_id as procedure_concept_id, concept_code FROM :OMOP_SCHEMA.concept WHERE vocabulary_id = 'ICD9Proc'),
"patients" AS (SELECT subject_id, mimic_id as person_id FROM patients),
"caregivers" AS (SELECT mimic_id AS provider_id, cgid FROM caregivers),
"admissions" AS (SELECT hadm_id, admittime, dischtime as procedure_datetime, mimic_id as visit_occurrence_id FROM admissions),
"proc_event" as (
   SELECT d_items.mimic_id AS procedure_source_concept_id
        , procedureevents_mv.mimic_id as procedure_occurrence_id
        , subject_id
        , cgid
        , hadm_id
        , itemid
        , starttime as procedure_datetime
        , label as procedure_source_value
        , value as quantity -- then it stores the duration... this is a warkaround and may be inproved
     FROM procedureevents_mv
     LEFT JOIN d_items USING (itemid)
     where cancelreason = 0 -- not cancelled
),
"gcpt_procedure_to_concept" as (SELECT item_id as itemid, concept_id as procedure_concept_id from gcpt_procedure_to_concept),
"cpt_event" AS ( SELECT mimic_id as procedure_occurrence_id , subject_id , hadm_id , chartdate as procedure_datetime, cpt_cd, subsectionheader as procedure_source_value FROM cptevents),
"omop_cpt4" as (SELECT concept_id as procedure_source_concept_id, concept_code as cpt_cd FROM :OMOP_SCHEMA.concept where vocabulary_id = 'CPT4'),
"standard_cpt4" as (
	select distinct on (c1.concept_id) first_value(c2.concept_id) over(partition by c1.concept_id order by relationship_id ASC) as procedure_concept_id, c1.concept_code as cpt_cd --keep snomed in predilection
	from :OMOP_SCHEMA.concept c1
	join :OMOP_SCHEMA.concept_relationship cr on concept_id_1 = c1.concept_id and relationship_id IN ('CPT4 - SNOMED eq','Maps to')
	left join :OMOP_SCHEMA.concept c2 on concept_id_2 = c2.concept_id
	WHERE
	    c1.vocabulary_id ='CPT4'
	and c2.standard_concept = 'S'
),
"row_to_insert" AS (
SELECT
  procedure_occurrence_id
, patients.person_id
, coalesce(standard_cpt4.procedure_concept_id,0) as procedure_concept_id
, coalesce(cpt_event.procedure_datetime, admissions.admittime)::date as procedure_date
, coalesce(cpt_event.procedure_datetime, admissions.admittime) as procedure_datetime
, 257 as procedure_type_concept_id -- Hospitalization Cost Record
, null::integer as modifier_concept_id
, null::integer as quantity
, null::integer as provider_id
, admissions.visit_occurrence_id
, null::integer as visit_detail_id -- the chartdate is never a time, when exist
, cpt_event.procedure_source_value
, omop_cpt4.procedure_source_concept_id as procedure_source_concept_id
, null::text as modifier_source_value
FROM cpt_event
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN omop_cpt4 USING (cpt_cd)
LEFT JOIN standard_cpt4 USING (cpt_cd)
UNION ALL
SELECT
  procedure_occurrence_id
, patients.person_id
, coalesce(gcpt_procedure_to_concept.procedure_concept_id,0) as procedure_concept_id
, proc_event.procedure_datetime::date as procedure_date
, (proc_event.procedure_datetime) as procedure_datetime
, 38000275 as procedure_type_concept_id -- EHR order list entry
, null as modifier_concept_id
, quantity as quantity --duration of the procedure in minutes
, caregivers.provider_id as provider_id
, admissions.visit_occurrence_id
, visit_detail_assign.visit_detail_id as visit_detail_id
, procedure_source_value
, procedure_source_concept_id -- from d_items mimic_id
, null as modifier_source_value
FROM proc_event
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN caregivers USING (cgid)
LEFT JOIN gcpt_procedure_to_concept USING (itemid)
LEFT JOIN :OMOP_SCHEMA.visit_detail_assign ON admissions.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND
(--only one visit_detail
(is_first IS TRUE AND is_last IS TRUE)
OR -- first
(is_first IS TRUE AND is_last IS FALSE AND proc_event.procedure_datetime <= visit_detail_assign.visit_end_datetime)
OR -- last
(is_last IS TRUE AND is_first IS FALSE AND proc_event.procedure_datetime > visit_detail_assign.visit_start_datetime)
OR -- middle
(is_last IS FALSE AND is_first IS FALSE AND proc_event.procedure_datetime > visit_detail_assign.visit_start_datetime AND proc_event.procedure_datetime <= visit_detail_assign.visit_end_datetime)
)
UNION ALL
SELECT
  procedure_occurrence_id
, patients.person_id
, coalesce(concept_proc_icd9.procedure_concept_id,0) as procedure_concept_id
, admissions.procedure_datetime::date as procedure_date
, (admissions.procedure_datetime) AS procedure_datetime
, 38003622 as procedure_type_concept_id
, null as modifier_concept_id
, null as quantity
, null as provider_id
, admissions.visit_occurrence_id
, null as visit_detail_id
, proc_icd.procedure_source_value
, coalesce(procedure_source_concept_id,0) as procedure_source_concept_id
, null as modifier_source_value
FROM proc_icd
LEFT JOIN local_proc_icd USING (procedure_source_value)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN concept_proc_icd9 USING (concept_code)
)
INSERT INTO :OMOP_SCHEMA.procedure_occurrence
(
    procedure_occurrence_id
  , person_id
  , procedure_concept_id
  , procedure_date
  , procedure_datetime
  , procedure_type_concept_id
  , modifier_concept_id
  , quantity
  , provider_id
  , visit_occurrence_id
  , visit_detail_id
  , procedure_source_value
  , procedure_source_concept_id
  , modifier_source_value
)
SELECT
  procedure_occurrence_id
, person_id
, procedure_concept_id
, procedure_date
, procedure_datetime
, procedure_type_concept_id
, modifier_concept_id
, quantity
, provider_id
, visit_occurrence_id
, visit_detail_id
, procedure_source_value
, procedure_source_concept_id
, modifier_source_value
FROM row_to_insert;


 -- from datetimeevents
 WITH
"datetimeevents" AS (SELECT subject_id, hadm_id, itemid, cgid, mimic_id as observation_id, coalesce(value,charttime)::date as observation_date, value as observation_datetime FROM datetimeevents where error is null or error = 0),
"gcpt_datetimeevents_to_concept" AS (SELECT label as value_as_string, observation_concept_id, itemid, observation_source_concept_id from gcpt_datetimeevents_to_concept),
"patients" AS (SELECT subject_id, mimic_id as person_id FROM patients),
"caregivers" AS (SELECT cgid, mimic_id as provider_id FROM caregivers),
"admissions" AS (SELECT subject_id, hadm_id, mimic_id as visit_occurrence_id, insurance, marital_status, language, diagnosis, religion, ethnicity, admittime FROM admissions),
"row_to_insert" AS
 (SELECT
        datetimeevents.observation_id
      , patients.person_id
      , gcpt.observation_concept_id
      , datetimeevents.observation_date
      , (datetimeevents.observation_datetime) as observation_datetime
      , 38000280 as observation_type_concept_id -- Observation recorded from EHR
      , null::double precision as value_as_number
      , gcpt.value_as_string as value_as_string
      , null::bigint as value_as_concept_id
      , null::bigint as qualifier_concept_id
      , null::bigint as unit_concept_id
      , caregivers.provider_id
      , admissions.visit_occurrence_id
      , null::bigint as  visit_detail_id
      , null::text as observation_source_value
      , gcpt.observation_source_concept_id
      , null as unit_source_value
      , null as qualifier_source_value
   FROM datetimeevents
 LEFT JOIN patients USING (subject_id)
 LEFT JOIN admissions USING (hadm_id)
 LEFT JOIN caregivers USING (cgid)
 LEFT JOIN gcpt_datetimeevents_to_concept gcpt USING (itemid)
 WHERE gcpt.observation_concept_id != 0
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
