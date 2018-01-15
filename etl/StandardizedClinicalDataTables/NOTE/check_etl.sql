
-- -----------------------------------------------------------------------------
-- File created - January-15-2018
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
SELECT count(distinct person_id), count(distinct visit_occurrence_id) FROM omop.note ;
'
,
'
SELECT count(distinct subject_id), count(distinct hadm_id) FROM noteevents;
' 
);

-- 2. check_radiology count
SELECT results_eq
(
'
SELECT count(1) from omop.note where note_type_concept_id = 44814641;
'
,
'
SELECT count(1) from mimiciii.noteevents where category = 'Radiology';
' 
);


SELECT * FROM finish();
ROLLBACK;
