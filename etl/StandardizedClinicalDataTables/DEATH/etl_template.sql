 WITH patients AS (SELECT subject_id, dod, dod FROM mimic.patients) 
 INSERT INTO omop.DEATH (person_id, death_date, death_datetime)
 SELECT patients.subject_id, patients.dod, patients.dod 
FROM patients 