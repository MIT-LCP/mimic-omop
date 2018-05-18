WITH
"death_adm" AS (
	SELECT patients.mimic_id as person_id, least(deathtime, dischtime) as death_datetime, 38003569 as death_type_concept_id
	FROM (SELECT distinct on (subject_id) first_value(deathtime) OVER(PARTITION BY subject_id ORDER BY admittime ASC) as deathtime, subject_id, dischtime FROM admissions WHERE deathtime IS NOT NULL) a --donor organs
	LEFT JOIN patients USING (subject_id)
	WHERE deathtime IS NOT NULL),
"death_ssn" AS (
	SELECT mimic_id as person_id, dod_ssn as death_datetime, 261 as death_type_concept_id
	FROM patients LEFT JOIN death_adm ON (mimic_id = person_id)
	WHERE dod_ssn IS NOT NULL AND death_adm.person_id IS NULL)
 INSERT INTO :OMOP_SCHEMA.DEATH
 (
	 person_id, death_date, death_datetime, death_type_concept_id
 )
 SELECT person_id, death_datetime::date, (death_datetime), death_type_concept_id
 FROM  death_adm
UNION ALL
 SELECT person_id, death_datetime::date, (death_datetime), death_type_concept_id
 FROM  death_ssn;
