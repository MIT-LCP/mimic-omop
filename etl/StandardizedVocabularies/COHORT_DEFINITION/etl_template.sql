 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.COHORT_DEFINITION ()
 SELECT NA.cohort_definition_id, NA.cohort_definition_name, NA.cohort_definition_description, NA.definition_type_concept_id, NA.cohort_definition_syntax, NA.subject_concept_id, NA.cohort_initiation_date 
FROM NA 