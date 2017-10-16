 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.CONCEPT_ANCESTOR ()
 SELECT NA.ancestor_concept_id, NA.descendant_concept_id, NA.min_levels_of_separation, NA.max_levels_of_separation 
FROM NA 