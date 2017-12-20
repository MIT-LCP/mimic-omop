 WITH patients AS (SELECT mimic_id as person_id, dod as death_date, dod as death_datetime, CASE WHEN dod_hosp IS NULL THEN 261 ELSE 38003569 END as death_type_concept_id FROM mimic.patients WHERE dod IS NOT NULL) 
 INSERT INTO omop.DEATH (person_id, death_date, death_datetime, death_type_concept_id)
 SELECT patients.person_id, patients.death_date, patients.death_datetime, patients.death_type_concept_id 
FROM patients ;
