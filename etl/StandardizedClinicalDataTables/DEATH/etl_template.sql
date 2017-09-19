 WITH patients AS (SELECT subject_id, dod, dod FROM mimic.patients),
encounter AS (SELECT col1, col2, col3 FROM mimic.encounter),
observation AS (SELECT col1 FROM mimic.observation) 
 INSERT INTO omop.DEATH (person_id, death_date, death_datetime, death_type_concept_id, cause_concept_id, cause_source_value, cause_source_concept_id)
 SELECT patients.subject_id, patients.dod, patients.dod, encounter.col1, encounter.col2, encounter.col3, observation.col1 
FROM patients
 LEFT JOIN encounter USING ()
 LEFT JOIN observation USING () 