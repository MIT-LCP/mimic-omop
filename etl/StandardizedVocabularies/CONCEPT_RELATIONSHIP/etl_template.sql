 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.CONCEPT_RELATIONSHIP ()
 SELECT NA.concept_id_, NA.concept_id_, NA.relationship_id, NA.valid_start_date, NA.valid_end_date, NA.invalid_reason 
FROM NA 