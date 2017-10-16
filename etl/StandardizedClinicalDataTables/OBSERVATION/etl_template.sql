 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.OBSERVATION ()
 SELECT NA.observation_id, NA.person_id, NA.observation_concept_id, NA.observation_date, NA.observation_datetime, NA.observation_type_concept_id, NA.value_as_number, NA.value_as_string, NA.value_as_concept_id, NA.qualifier_concept_id, NA.unit_concept_id, NA.provider_id, NA.visit_occurrence_id, NA.visit_detail_id, NA.observation_source_value, NA.observation_source_concept_id, NA.unit_source_value, NA.qualifier_source_value 
FROM NA 