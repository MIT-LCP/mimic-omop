 WITH datetimeevents AS (SELECT mimic_id as observation_id, value::date as observation_date, value as observation_datetime, mimic_id as provider_id FROM mimic.datetimeevents),
patients AS (SELECT mimic_id as person_id FROM mimic.patients),
admissions AS (SELECT mimic_id as visit_occurrence_id FROM mimic.admissions),
d_items AS (SELECT label as observation_source_value FROM mimic.d_items) 
 INSERT INTO omop.OBSERVATION (observation_id, observation_date, observation_datetime, provider_id, person_id, visit_occurrence_id, observation_source_value)
 SELECT datetimeevents.observation_id, patients.person_id, datetimeevents.observation_date, datetimeevents.observation_datetime, datetimeevents.provider_id, admissions.visit_occurrence_id, d_items.observation_source_value 
FROM datetimeevents
 LEFT JOIN patients ON ()
 LEFT JOIN admissions ON ()
 LEFT JOIN d_items ON () 