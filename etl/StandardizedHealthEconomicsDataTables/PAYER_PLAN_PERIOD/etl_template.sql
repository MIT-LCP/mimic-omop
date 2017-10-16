 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.PAYER_PLAN_PERIOD ()
 SELECT NA.payer_plan_period_id, NA.person_id, NA.payer_plan_period_start_date, NA.payer_plan_period_end_date, NA.payer_source_value, NA.plan_source_value, NA.family_source_value 
FROM NA 