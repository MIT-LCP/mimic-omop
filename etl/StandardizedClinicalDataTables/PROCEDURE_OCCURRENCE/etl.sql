WITH 
"proc_icd" as (SELECT mimic_id as procedure_occurrence_id, subject_id, hadm_id, icd9_code as procedure_source_value, CASE WHEN length(cast(ICD9_CODE as text)) = 2 THEN cast(ICD9_CODE as text) ELSE concat(substr(cast(ICD9_CODE as text), 1, 2), '.', substr(cast(ICD9_CODE as text), 3)) END AS concept_code FROM procedures_icd),
"concept_proc_icd9" as ( SELECT concept_id as procedure_concept_id, concept_code FROM omop.concept WHERE vocabulary_id = 'ICD9Proc'),
"patients" AS (SELECT subject_id, mimic_id as person_id FROM patients),
"admissions" AS (SELECT hadm_id, admittime, dischtime as procedure_datetime, mimic_id as visit_occurrence_id FROM admissions),
"proc_event" as (SELECT procedureevents_mv.mimic_id as procedure_occurrence_id, subject_id, hadm_id, itemid, starttime as procedure_datetime, label as procedure_source_value FROM procedureevents_mv LEFT JOIN d_items USING (itemid)),
"gcpt_procedure_to_concept" as (SELECT item_id as itemid, concept_id as procedure_concept_id from gcpt_procedure_to_concept),
"concept_cpt4" AS (SELECT concept_id as procedure_concept_id, concept_code from omop.concept where vocabulary_id = 'CPT4'),
"cpt_event" AS ( SELECT mimic_id as procedure_occurrence_id , subject_id , hadm_id , chartdate as procedure_datetime , trim('[' || coalesce(costcenter,'') || '][' || coalesce(sectionheader,'') || '] ' || subsectionheader || ' ' || coalesce(description, '')) as procedure_source_value FROM cptevents),
"gcpt_cpt4_to_concept" as (SELECT * FROM gcpt_cpt4_to_concept)
INSERT INTO omop.procedure_occurrence (
  procedure_occurrence_id
, person_id
, visit_occurrence_id
, procedure_date
, procedure_datetime
, procedure_type_concept_id
, procedure_concept_id
, procedure_source_value
)
SELECT
  procedure_occurrence_id
, patients.person_id
, admissions.visit_occurrence_id
, coalesce(cpt_event.procedure_datetime, admissions.admittime)::date as procedure_date
, coalesce(cpt_event.procedure_datetime, admissions.admittime) as procedure_datetime
, 257 as procedure_type_concept_id
, coalesce(gcpt_cpt4_to_concept.procedure_concept_id,0) as procedure_concept_id
, procedure_source_value
FROM cpt_event
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN gcpt_cpt4_to_concept USING (procedure_source_value)
UNION ALL
SELECT
  procedure_occurrence_id
, patients.person_id
, admissions.visit_occurrence_id
, proc_event.procedure_datetime::date as procedure_date
, proc_event.procedure_datetime
, 38000275 as procedure_type_concept_id
, coalesce(gcpt_procedure_to_concept.procedure_concept_id,0) as procedure_concept_id
, procedure_source_value
FROM proc_event
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN gcpt_procedure_to_concept USING (itemid)
UNION ALL
SELECT
  procedure_occurrence_id
, patients.person_id
, admissions.visit_occurrence_id
, admissions.procedure_datetime::date as procedure_date
, admissions.procedure_datetime
, 38003622 as procedure_type_concept_id
, coalesce(concept_proc_icd9.procedure_concept_id,0) as procedure_concept_ide
, proc_icd.procedure_source_value
FROM proc_icd
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN concept_proc_icd9 USING (concept_code);
