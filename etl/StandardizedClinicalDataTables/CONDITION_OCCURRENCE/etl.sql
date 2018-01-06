WITH
"gcpt_seq_num_to_concept" as (SELECT seq_num, concept_id as condition_type_concept_id FROM gcpt_seq_num_to_concept),
"icd9_concept" as ( SELECT concept_id, concept_code FROM omop.concept WHERE vocabulary_id = 'ICD9CM'),
"diag" as ( SELECT mimic_id as condition_occurrence_id , subject_id , hadm_id , CASE WHEN ICD9_CODE LIKE 'E%' AND LENGTH(ICD9_CODE) > 4 THEN substring(ICD9_CODE, 1, 4) || '.' || substring(ICD9_CODE, 5) WHEN ICD9_CODE LIKE 'E%' AND length(ICD9_CODE) = 4 THEN ICD9_CODE WHEN ICD9_CODE NOT LIKE 'E%' AND length(ICD9_CODE) > 3 THEN substring(ICD9_CODE, 1, 3) || '.' || substring(ICD9_CODE, 4) WHEN ICD9_CODE NOT LIKE 'E%' AND length(ICD9_CODE) = 3 THEN ICD9_CODE ELSE NULL END as concept_code , seq_num , icd9_code as condition_source_value FROM diagnoses_icd WHERE icd9_code IS NOT NULL) , 
"snomed_map" as ( SELECT rel.concept_id_1 , min(rel.concept_id_2) AS condition_concept_id FROM omop.concept_relationship as rel JOIN omop.concept as c1 ON (concept_id_1       = c1.concept_id) JOIN omop.concept as c2 ON (concept_id_2       = c2.concept_id) WHERE rel.relationship_id = 'Maps to' AND c1.vocabulary_id    = 'ICD9CM' AND c2.vocabulary_id    = 'SNOMED' AND c2.concept_class_id = 'Clinical Finding' GROUP BY rel.concept_id_1) , 
"admissions" as (SELECT subject_id as hadm_subject_id, hadm_id, mimic_id as visit_occurrence_id, diagnosis, coalesce(edregtime, admittime) as condition_start_datetime, dischtime as condition_end_datetime FROM admissions),
"patients" as (SELECT subject_id, mimic_id as person_id FROM patients),
"adm_diag_cpt" AS (SELECT * FROM gcpt_admissions_diagnosis_to_concept)
INSERT INTO omop.condition_occurrence (
  condition_occurrence_id       
, person_id                     
, condition_concept_id      
, condition_start_date
, to_datetime(condition_start_datetime)      
, condition_end_date 
, to_datetime(condition_end_datetime)
, condition_type_concept_id     
, stop_reason                   
, provider_id                   
, visit_occurrence_id           
, visit_detail_id               
, condition_source_value        
, condition_source_concept_id   
, condition_status_source_value 
, condition_status_concept_id   
)
 SELECT 
  condition_occurrence_id       
, person_id                     
, coalesce(condition_concept_id, 0) as condition_concept_id      
, condition_start_datetime::date as condition_start_date
, to_datetime(condition_start_datetime)
, condition_end_datetime::date as condition_end_date 
, to_datetime(condition_end_datetime)
, condition_type_concept_id     
, null as stop_reason                   
, null::bigint as provider_id                   
, visit_occurrence_id           
, null::bigint as visit_detail_id               
, condition_source_value        
, icd9_concept.concept_id as condition_source_concept_id   
, null as condition_status_source_value 
, null::bigint as condition_status_concept_id   
 FROM diag
LEFT JOIN icd9_concept USING (concept_code)
LEFT JOIN snomed_map ON (snomed_map.concept_id_1 = icd9_concept.concept_id)
LEFT JOIN gcpt_seq_num_to_concept USING (seq_num)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN patients USING (subject_id) 
UNION ALL
SELECT
  nextval('mimic_id_seq') AS condition_occurrence_id       
, patients.person_id AS person_id                     
, coalesce(adm_diag_cpt.concept_id, 0) AS condition_concept_id      
, admissions.condition_start_datetime::date AS condition_start_date
, to_datetime(admissions.condition_start_datetime) AS  condition_start_datetime      
, admissions.condition_end_datetime::date AS condition_end_date 
, to_datetime(admissions.condition_end_datetime) AS condition_end_datetime        
, 42894222 AS condition_type_concept_id   --EHR Chief Complaint
, null AS stop_reason                   
, null AS provider_id                   
, admissions.visit_occurrence_id AS visit_occurrence_id           
, null AS visit_detail_id               
, admissions.diagnosis AS condition_source_value        
, null AS condition_source_concept_id   
, null AS condition_status_source_value 
, null AS condition_status_concept_id   
FROM admissions
LEFT JOIN patients ON (subject_id = hadm_subject_id)
LEFT JOIN adm_diag_cpt USING (diagnosis)
;
