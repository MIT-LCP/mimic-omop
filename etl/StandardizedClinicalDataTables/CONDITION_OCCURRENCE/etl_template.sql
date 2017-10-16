 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.CONDITION_OCCURRENCE ()
 SELECT NA.condition_occurrence_id, NA.person_id, NA.condition_concept_id, NA.condition_start_date, NA.condition_start_datetime, NA.condition_end_date, NA.condition_end_datetime, NA.condition_type_concept_id, NA.stop_reason, NA.provider_id, NA.visit_occurrence_id, NA.visit_detail_id, NA.condition_source_value, NA.condition_source_concept_id, NA.condition_status_source_value, NA.condition_status_concept_id 
FROM NA 