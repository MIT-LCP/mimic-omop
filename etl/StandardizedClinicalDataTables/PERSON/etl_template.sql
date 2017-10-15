 WITH patients AS (SELECT subject_id, extract(year FROM dob), extract(month FROM dob), extract(day FROM dob), dob, gender FROM mimic.patients),
admissions AS (SELECT ethnicity FROM mimic.admissions) 
 INSERT INTO omop.PERSON (person_id, year_of_birth, month_of_birth, day_of_birth, birth_datetime, gender_source_value, ethnicity_source_value)
 SELECT patients.subject_id, patients.extract(year FROM dob), patients.extract(month FROM dob), patients.extract(day FROM dob), patients.dob, patients.gender, admissions.ethnicity 
FROM patients
 LEFT JOIN admissions USING () 