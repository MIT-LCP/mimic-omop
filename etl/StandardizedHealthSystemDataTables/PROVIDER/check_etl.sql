
-- -----------------------------------------------------------------------------
-- File created - January-15-2018
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
SELECT count(*) from omop.provider;
'
,
'
SELECT count(*) from caregivers;
' 
,'-- 1. count providers'
);


SELECT * FROM finish();
ROLLBACK;
