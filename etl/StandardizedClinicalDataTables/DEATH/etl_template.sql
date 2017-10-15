 WITH patients AS (SELECT subject_id as person_id, dod as death_date, dod as death_datetime FROM mimic.patients) 
 INSERT INTO omop.DEATH (person_id, death_date, death_datetime)
 SELECT patients.person_id, patients.death_date, patients.death_datetime 
FROM patients 