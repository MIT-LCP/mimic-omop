 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.CONDITION_ERA ()
 SELECT NA.condition_era_id, NA.person_id, NA.condition_concept_id, NA.condition_era_start_date, NA.condition_era_end_date, NA.condition_occurrence_count 
FROM NA 