 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.CARE_SITE ()
 SELECT NA.care_site_id, NA.care_site_name, NA.place_of_service_concept_id, NA.location_id, NA.care_site_source_value, NA.place_of_service_source_value 
FROM NA 