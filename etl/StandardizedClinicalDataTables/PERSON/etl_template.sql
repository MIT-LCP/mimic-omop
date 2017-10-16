 WITH patients AS (SELECT subject_id as person_id, extract(year FROM dob) as year_of_birth, extract(month FROM dob) as month_of_birth, extract(day FROM dob) as day_of_birth, dob as birth_datetime, gender as gender_source_value FROM mimic.patients),
admissions AS (SELECT ethnicity as ethnicity_source_value FROM mimic.admissions) 
 INSERT INTO omop.PERSON (person_id, year_of_birth, month_of_birth, day_of_birth, birth_datetime, gender_source_value, ethnicity_source_value)
 SELECT patients.person_id, patients.year_of_birth, patients.month_of_birth, patients.day_of_birth, patients.birth_datetime, patients.gender_source_value, admissions.ethnicity_source_value 
FROM patients
 LEFT JOIN admissions ON () 