WITH admissions AS (SELECT subject_id, admission_location, discharge_location, mimic_id as visit_occurrence_id, 9201 as visit_concept_id, admittime::date as visit_start_date, admittime as visit_start_datetime, dischtime::date as visit_end_date, dischtime as visit_end_datetime, 44818518 as visit_type_concept_id, admission_type as visit_source_value, admission_location as admitting_source_value, discharge_location as discharge_to_source_value, LAG(mimic_id) OVER (PARTITION BY subject_id ORDER BY admittime ASC) as preceding_visit_occurrence_id  FROM mimic.admissions),
patients AS (SELECT subject_id, mimic_id as person_id FROM mimic.patients),
gcpt_admission_location_to_concept AS (SELECT concept_id as visit_source_concept_id, admission_location FROM mimic.gcpt_admission_location_to_concept),
gcpt_discharge_location_to_concept AS (SELECT concept_id as discharge_to_concept_id, discharge_location FROM mimic.gcpt_discharge_location_to_concept) 
 INSERT INTO omop.VISIT_OCCURRENCE (visit_occurrence_id, person_id, visit_concept_id, visit_start_date, visit_start_datetime, visit_end_date, visit_end_datetime, visit_type_concept_id, visit_source_value, visit_source_concept_id, admitting_source_value, discharge_to_concept_id, discharge_to_source_value, preceding_visit_occurrence_id)
 SELECT admissions.visit_occurrence_id
      , patients.person_id
      , admissions.visit_concept_id
      , admissions.visit_start_date
      , admissions.visit_start_datetime
      , admissions.visit_end_date
      , admissions.visit_end_datetime
      , admissions.visit_type_concept_id
      , admissions.visit_source_value
      , gcpt_admission_location_to_concept.visit_source_concept_id
      , admissions.admitting_source_value
      , gcpt_discharge_location_to_concept.discharge_to_concept_id
      , admissions.discharge_to_source_value
      , admissions.preceding_visit_occurrence_id
   FROM admissions
 LEFT JOIN gcpt_admission_location_to_concept USING (admission_location)
 LEFT JOIN gcpt_discharge_location_to_concept USING (discharge_location) 
 LEFT JOIN patients USING (subject_id)
