 WITH caregivers AS (SELECT mimic_id as provider_id, label as provider_source_value, description as specialty_source_value FROM caregivers) 
 INSERT INTO omop.PROVIDER (provider_id, provider_source_value, specialty_source_value)
 SELECT caregivers.provider_id, caregivers.provider_source_value, caregivers.specialty_source_value 
FROM caregivers 
