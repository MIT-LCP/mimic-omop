 WITH procedures_icd AS (SELECT row_id as procedure_occurrence_id, subject_id as person_id, hadm_id as visit_occurrence_id, icd9_code as procedure_source_value FROM mimic.procedures_icd),
admissions AS (SELECT admittime::date as procedure_date, admittime::date as procedure_datetime FROM mimic.admissions) 
 INSERT INTO omop.PROCEDURE_OCCURRENCE (procedure_occurrence_id, person_id, visit_occurrence_id, procedure_source_value, procedure_date, procedure_datetime)
 SELECT procedures_icd.procedure_occurrence_id, procedures_icd.person_id, admissions.procedure_date, admissions.procedure_datetime, procedures_icd.visit_occurrence_id, procedures_icd.procedure_source_value 
FROM procedures_icd
 LEFT JOIN admissions ON () 