-- Subsets patients, and load each mimiciii table with it


SET search_path TO mimic;

-- get a 1000 patient subset

CREATE TEMP TABLE pat AS
SELECT subject_id 
FROM mimiciii.patients 
ORDER BY random() 
LIMIT 100;

-- that query built the above queries
-- SELECT 'INSERT INTO mimic.' || table_name || ' SELECT * FROM mimiciii.' || table_name || ' WHERE subject_id IN (SELECT subject_id FROM pat); '
--   FROM information_schema.tables
--  WHERE table_schema = 'mimiciii'
-- AND table_name !~ '\d$'
--    AND table_name IN (
--                 SELECT table_name
--                   FROM information_schema.columns
--  WHERE column_name  = 'subject_id'
--        );


 INSERT INTO mimic.admissions SELECT * FROM mimiciii.admissions WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.callout SELECT * FROM mimiciii.callout WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.chartevents SELECT * FROM mimiciii.chartevents WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.cptevents SELECT * FROM mimiciii.cptevents WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.datetimeevents SELECT * FROM mimiciii.datetimeevents WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.diagnoses_icd SELECT * FROM mimiciii.diagnoses_icd WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.drgcodes SELECT * FROM mimiciii.drgcodes WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.icustays SELECT * FROM mimiciii.icustays WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.inputevents_cv SELECT * FROM mimiciii.inputevents_cv WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.inputevents_mv SELECT * FROM mimiciii.inputevents_mv WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.labevents SELECT * FROM mimiciii.labevents WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.microbiologyevents SELECT * FROM mimiciii.microbiologyevents WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.noteevents SELECT * FROM mimiciii.noteevents WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.outputevents SELECT * FROM mimiciii.outputevents WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.patients SELECT * FROM mimiciii.patients WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.prescriptions SELECT * FROM mimiciii.prescriptions WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.procedureevents_mv SELECT * FROM mimiciii.procedureevents_mv WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.procedures_icd SELECT * FROM mimiciii.procedures_icd WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.services SELECT * FROM mimiciii.services WHERE subject_id IN (SELECT subject_id FROM pat); 
 INSERT INTO mimic.transfers SELECT * FROM mimiciii.transfers WHERE subject_id IN (SELECT subject_id FROM pat);

-- SELECT 'INSERT INTO mimic.' || table_name || ' SELECT * FROM mimiciii.' || table_name || '; '
--   FROM information_schema.tables
--  WHERE table_schema = 'mimiciii'
--    AND table_name NOT IN (
--                 SELECT table_name
--                   FROM information_schema.columns
--  WHERE column_name  = 'subject_id'
--        );
-- 
 INSERT INTO mimic.caregivers SELECT * FROM mimiciii.caregivers; 
 INSERT INTO mimic.d_cpt SELECT * FROM mimiciii.d_cpt; 
 INSERT INTO mimic.d_icd_diagnoses SELECT * FROM mimiciii.d_icd_diagnoses; 
 INSERT INTO mimic.d_icd_procedures SELECT * FROM mimiciii.d_icd_procedures; 
 INSERT INTO mimic.d_items SELECT * FROM mimiciii.d_items; 
 INSERT INTO mimic.d_labitems SELECT * FROM mimiciii.d_labitems;
