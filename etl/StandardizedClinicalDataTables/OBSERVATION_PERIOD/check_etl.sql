
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
SELECT count(1) from omop.visit_occurrence;
'
,
'
select count(1) from omop.observation_period;
' 
,'-- 1. observation_period checker'
);

SELECT pass( 'observation_period pass, w00t!' );

SELECT * FROM finish();
ROLLBACK;
