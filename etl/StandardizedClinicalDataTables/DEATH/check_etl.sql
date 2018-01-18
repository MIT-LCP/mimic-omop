
-- -----------------------------------------------------------------------------
-- File created - January-9-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

SET search_path to mimiciii;

BEGIN;

SELECT plan ( 2  );

SELECT results_eq
(
 '
SELECT count(distinct subject_id) from admissions where hospital_expire_flag = 1;
'
,
'
SELECT count(distinct visit_occurrence_id)
FROM omop.visit_occurrence
WHERE discharge_to_concept_id = 4216643;
'
, 'dead number in hospital'
);

SELECT results_eq
(
 '
SELECT count(*) from admissions where hospital_expire_flag = 1;
'
,
'
SELECT count(distinct visit_occurrence_id)
FROM omop.visit_occurrence
WHERE discharge_to_concept_id = 4216643 or discharge_to_concept_id = 4022058 ; -- dead / organ_donor
'
, 'organ_donor'
);


SELECT * FROM finish();
ROLLBACK;
