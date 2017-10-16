 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.DEVICE_EXPOSURE ()
 SELECT NA.device_exposure_id, NA.person_id, NA.device_concept_id, NA.device_exposure_start_date, NA.device_exposure_start_datetime, NA.device_exposure_end_date, NA.device_exposure_end_datetime, NA.device_type_concept_id, NA.unique_device_id, NA.quantity, NA.provider_id, NA.visit_occurrence_id, NA.device_source_value, NA.device_source_concept_id, NA.visit_detail_id 
FROM NA 