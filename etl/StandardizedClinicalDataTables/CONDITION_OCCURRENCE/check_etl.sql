
-- -----------------------------------------------------------------------------
-- File created - January-13-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 1 );

-- 1. visit_occurrence_nb
SELECT results_eq
(
'
SELECT count(distinct person_id), count(distinct visit_occurrence_id) FROM omop.condition_occurrence ;
'
,
'
SELECT count(distinct subject_id), count(distinct hadm_id) FROM diagnoses_icd;
' 
);


SELECT * FROM finish();
ROLLBACK;
