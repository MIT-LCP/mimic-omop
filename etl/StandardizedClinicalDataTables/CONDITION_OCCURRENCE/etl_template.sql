 WITH diagnoses_icd AS (SELECT row_id as condition_occurrence_id, subject_id as person_id FROM mimic.diagnoses_icd),
admissions AS (SELECT admittime::date as condition_start_date, admittime as condition_start_datetime, dischtime::date as condition_end_date, dischtime as condition_end_datetime, hadm_id as visit_occurrence_id, icd9_code as condition_source_value FROM mimic.admissions) 
 INSERT INTO omop.CONDITION_OCCURRENCE (condition_occurrence_id, person_id, condition_start_date, condition_start_datetime, condition_end_date, condition_end_datetime, visit_occurrence_id, condition_source_value)
 SELECT diagnoses_icd.condition_occurrence_id, diagnoses_icd.person_id, admissions.condition_start_date, admissions.condition_start_datetime, admissions.condition_end_date, admissions.condition_end_datetime, admissions.visit_occurrence_id, admissions.condition_source_value 
FROM diagnoses_icd
 LEFT JOIN admissions ON () 