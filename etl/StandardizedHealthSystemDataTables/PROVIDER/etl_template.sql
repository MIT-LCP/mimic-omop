 WITH caregivers AS (SELECT cgid as provider_id, description as specialty_source_value FROM mimic.caregivers) 
 INSERT INTO omop.PROVIDER (provider_id, specialty_source_value)
 SELECT caregivers.provider_id, caregivers.specialty_source_value 
FROM caregivers 