 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.CONCEPT ()
 SELECT NA.concept_id, NA.concept_name, NA.domain_id, NA.vocabulary_id, NA.concept_class_id, NA.standard_concept, NA.concept_code, NA.valid_start_date, NA.valid_end_date, NA.invalid_reason 
FROM NA 