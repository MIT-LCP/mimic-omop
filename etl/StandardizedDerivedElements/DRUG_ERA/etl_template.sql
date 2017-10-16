 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.DRUG_ERA ()
 SELECT NA.drug_era_id, NA.person_id, NA.drug_concept_id, NA.drug_era_start_date, NA.drug_era_end_date, NA.drug_exposure_count, NA.gap_days 
FROM NA 