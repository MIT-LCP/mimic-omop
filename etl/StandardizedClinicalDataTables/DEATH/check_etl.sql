
-- -----------------------------------------------------------------------------
-- File created - January-9-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;

SELECT plan ( 1 );

SELECT results_eq
(
'
SELECT count(dod) FROM patients;
'
,
'
SELECT count(death_date) FROM omop.death
'
, 'number of unique patients who die in the database'
);

SELECT * FROM finish();
ROLLBACK;
