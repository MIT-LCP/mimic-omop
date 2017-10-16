 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.DRUG_STRENGTH ()
 SELECT NA.drug_concept_id, NA.ingredient_concept_id, NA.amount_value, NA.amount_unit_concept_id, NA.numerator_value, NA.numerator_unit_concept_id, NA.denominator_value, NA.denominator_unit_concept_id, NA.box_size, NA.valid_start_date, NA.valid_end_date, NA.invalid_reason 
FROM NA 