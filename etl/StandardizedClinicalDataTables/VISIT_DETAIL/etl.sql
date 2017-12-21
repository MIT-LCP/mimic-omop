 WITH transfers AS (SELECT subject_id, hadm_id, curr_careunit, mimic_id as visit_detail_id, 9201 as visit_detail_concept_id, intime::date as visit_start_date, intime as visit_start_datetime, outtime::date as visit_end_date, outtime as visit_end_datetime, 44818518 as visit_type_concept_id, eventtype as discharge_to_source_value, LAG(mimic_id) OVER (PARTITION BY hadm_id ORDER BY intime ASC) as preceding_visit_detail_id FROM mimic.transfers WHERE curr_careunit IS NOT NULL),
patients AS (SELECT subject_id, mimic_id as person_id FROM mimic.patients),
gcpt_care_site AS (SELECT care_site_name, mimic_id as care_site_id FROM mimic.gcpt_care_site),
gcpt_admission_location_to_concept AS (SELECT admission_location, concept_id as visit_source_concept_id FROM mimic.gcpt_admission_location_to_concept),
gcpt_discharge_location_to_concept AS (SELECT discharge_location, concept_id as discharge_to_concept_id FROM mimic.gcpt_discharge_location_to_concept),
admissions AS (SELECT hadm_id, admission_location, discharge_location, mimic_id as visit_occurrence_id FROM mimic.admissions) 
 INSERT INTO omop.VISIT_DETAIL (
person_id,
visit_detail_id,
visit_detail_concept_id,
visit_start_date,
visit_start_datetime,
visit_end_date,
visit_end_datetime,
visit_type_concept_id,
care_site_id,
visit_source_concept_id,
discharge_to_concept_id,
discharge_to_source_value,
preceding_visit_detail_id,
visit_occurrence_id)
 SELECT 
        patients.person_id
      , transfers.visit_detail_id
      , transfers.visit_detail_concept_id
      , transfers.visit_start_date
      , transfers.visit_start_datetime
      , transfers.visit_end_date
      , transfers.visit_end_datetime
      , transfers.visit_type_concept_id
      , gcpt_care_site.care_site_id
      , gcpt_admission_location_to_concept.visit_source_concept_id
      , gcpt_discharge_location_to_concept.discharge_to_concept_id
      , transfers.discharge_to_source_value
      , transfers.preceding_visit_detail_id
      , admissions.visit_occurrence_id
   FROM transfers
 LEFT JOIN patients USING (subject_id)
 LEFT JOIN admissions USING (hadm_id) 
 LEFT JOIN gcpt_care_site ON (care_site_name = curr_careunit)
 LEFT JOIN gcpt_admission_location_to_concept USING (admission_location)
 LEFT JOIN gcpt_discharge_location_to_concept USING (discharge_location)
