-- Subsets patients, and load each mimiciii table with it


SET search_path TO mimic;

-- get a 1000 patient subset

CREATE TEMP TABLE pat AS
SELECT subject_id
  FROM patients TABLESAMPLE SYSTEM ((1000 * 100) / 5100000.0);

-- that query built the above queries
-- SELECT 'INSERT INTO mimic.' || table_name || ' SELECT * FROM mimiciii.' || table_name || ' NATURAL JOIN pat; '
--   FROM information_schema.tables
--  WHERE table_schema = 'mimiciii'
-- AND table_name !~ '\d$'
--    AND table_name IN (
--                 SELECT table_name
--                   FROM information_schema.columns
--  WHERE column_name  = 'subject_id'
--        );


 INSERT INTO mimic.admissions SELECT * FROM mimiciii.admissions NATURAL JOIN pat; 
 INSERT INTO mimic.callout SELECT * FROM mimiciii.callout NATURAL JOIN pat; 
 INSERT INTO mimic.chartevents SELECT * FROM mimiciii.chartevents NATURAL JOIN pat; 
 INSERT INTO mimic.cptevents SELECT * FROM mimiciii.cptevents NATURAL JOIN pat; 
 INSERT INTO mimic.datetimeevents SELECT * FROM mimiciii.datetimeevents NATURAL JOIN pat; 
 INSERT INTO mimic.diagnoses_icd SELECT * FROM mimiciii.diagnoses_icd NATURAL JOIN pat; 
 INSERT INTO mimic.drgcodes SELECT * FROM mimiciii.drgcodes NATURAL JOIN pat; 
 INSERT INTO mimic.icustays SELECT * FROM mimiciii.icustays NATURAL JOIN pat; 
 INSERT INTO mimic.inputevents_cv SELECT * FROM mimiciii.inputevents_cv NATURAL JOIN pat; 
 INSERT INTO mimic.inputevents_mv SELECT * FROM mimiciii.inputevents_mv NATURAL JOIN pat; 
 INSERT INTO mimic.labevents SELECT * FROM mimiciii.labevents NATURAL JOIN pat; 
 INSERT INTO mimic.microbiologyevents SELECT * FROM mimiciii.microbiologyevents NATURAL JOIN pat; 
 INSERT INTO mimic.noteevents SELECT * FROM mimiciii.noteevents NATURAL JOIN pat; 
 INSERT INTO mimic.outputevents SELECT * FROM mimiciii.outputevents NATURAL JOIN pat; 
 INSERT INTO mimic.patients SELECT * FROM mimiciii.patients NATURAL JOIN pat; 
 INSERT INTO mimic.prescriptions SELECT * FROM mimiciii.prescriptions NATURAL JOIN pat; 
 INSERT INTO mimic.procedureevents_mv SELECT * FROM mimiciii.procedureevents_mv NATURAL JOIN pat; 
 INSERT INTO mimic.procedures_icd SELECT * FROM mimiciii.procedures_icd NATURAL JOIN pat; 
 INSERT INTO mimic.services SELECT * FROM mimiciii.services NATURAL JOIN pat; 
 INSERT INTO mimic.transfers SELECT * FROM mimiciii.transfers NATURAL JOIN pat;

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
