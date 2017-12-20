WITH patients AS (SELECT subject_id, mimic_id as person_id, CASE WHEN gender ='F' THEN 8532 WHEN GENDER = 'M' THEN 8507 ELSE NULL END as gender_concept_id, extract(year FROM dob) as year_of_birth, extract(month FROM dob) as month_of_birth, extract(day FROM dob) as day_of_birth, dob as birth_datetime, gender as gender_source_value FROM mimic.patients),
gcpt_ethnicity_to_concept AS (SELECT ethnicity, race_concept_id as race_concept_id, ethnicity_concept_id as ethnicity_concept_id FROM mimic.gcpt_ethnicity_to_concept),
admissions AS (SELECT DISTINCT ON (subject_id) subject_id, ethnicity as ethnicity_source_value FROM mimic.admissions ORDER BY subject_id, admittime DESC) 
 INSERT INTO omop.PERSON (person_id, gender_concept_id, year_of_birth, month_of_birth, day_of_birth, birth_datetime, gender_source_value, race_concept_id, ethnicity_concept_id, ethnicity_source_value)
 SELECT patients.person_id
      , patients.gender_concept_id
      , patients.year_of_birth
      , patients.month_of_birth
      , patients.day_of_birth
      , patients.birth_datetime
      , patients.gender_source_value
      , gcpt_ethnicity_to_concept.race_concept_id
      , gcpt_ethnicity_to_concept.ethnicity_concept_id
      , admissions.ethnicity_source_value
   FROM patients
   LEFT 
   JOIN admissions
  USING (subject_id)
   LEFT 
   JOIN gcpt_ethnicity_to_concept
     ON (admissions.ethnicity_source_value = gcpt_ethnicity_to_concept.ethnicity);
