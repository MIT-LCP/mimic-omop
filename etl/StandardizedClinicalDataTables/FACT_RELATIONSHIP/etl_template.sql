 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.FACT_RELATIONSHIP ()
 SELECT NA.domain_concept_id_, NA.fact_id_, NA.domain_concept_id_, NA.fact_id_, NA.relationship_concept_id 
FROM NA 