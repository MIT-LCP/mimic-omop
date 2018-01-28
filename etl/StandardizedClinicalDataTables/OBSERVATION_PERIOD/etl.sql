-- load observation_period from previously loaded visit_occurrence table
-- SHALL be run after visit_occurrence etl

WITH 
"insert_observation_period" as 
(
SELECT
  nextval('mimic_id_seq') as observation_period_id
, person_id
, visit_start_date as observation_period_start_date
, visit_start_datetime as observation_period_start_datetime
, visit_end_date as observation_period_end_date
, visit_end_datetime as observation_period_end_datetime
, 44814724  as period_type_concept_id  --  Period covering healthcare encounters
FROM omop.visit_occurrence
)
INSERT INTO omop.observation_period
SELECT
  observation_period_id             
, person_id                         
, observation_period_start_date     
, observation_period_start_datetime 
, observation_period_end_date       
, observation_period_end_datetime   
, period_type_concept_id
FROM insert_observation_period
