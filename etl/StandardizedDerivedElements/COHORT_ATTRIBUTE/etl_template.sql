 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.COHORT_ATTRIBUTE ()
 SELECT NA.cohort_definition_id, NA.subject_id, NA.cohort_start_date, NA.cohort_end_date, NA.attribute_definition_id, NA.value_as_number, NA.value_as_concept_id 
FROM NA 