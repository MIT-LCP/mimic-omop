 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.SOURCE_TO_CONCEPT_MAP ()
 SELECT NA.source_code, NA.source_concept_id, NA.source_vocabulary_id, NA.source_code_description, NA.target_concept_id, NA.target_vocabulary_id, NA.valid_start_date, NA.valid_end_date, NA.invalid_reason 
FROM NA 