
-- -----------------------------------------------------------------------------
-- File created - January-15-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 2 );

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
,'visit occurrence nb'
);

-- 2. check_radiology count
SELECT results_eq
(
'
SELECT count(1) from omop.note where note_type_concept_id = 44814641;
'
,
'
SELECT count(1) from noteevents where category = ''Radiology'';
' 
,'check radio nb'
);


SELECT * FROM finish();
ROLLBACK;
