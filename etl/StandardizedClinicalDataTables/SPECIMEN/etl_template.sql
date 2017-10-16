 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.SPECIMEN ()
 SELECT NA.specimen_id, NA.person_id, NA.specimen_concept_id, NA.specimen_type_concept_id, NA.specimen_date, NA.specimen_datetime, NA.quantity, NA.unit_concept_id, NA.anatomic_site_concept_id, NA.disease_status_concept_id, NA.specimen_source_id, NA.specimen_source_value, NA.unit_source_value, NA.anatomic_site_source_value, NA.disease_status_source_value 
FROM NA 