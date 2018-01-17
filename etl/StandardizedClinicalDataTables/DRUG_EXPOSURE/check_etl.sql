
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
SELECT count(distinct person_id), count(distinct visit_occurrence_id)
FROM omop.drug_exposure
where drug_type_concept_id = 38000177;
'
,
'
SELECT count(distinct subject_id), count(distinct hadm_id) 
FROM prescriptions;
' 
,'nb patient with prescription'
);

-- 2.  principaux medicaments de prescripitoin
SELECT results_eq
(
'
SELECT drug::text, count(1)
from prescriptions 
group by drug 
ORDER by 2,1 desc;
'
,
'
SELECT drug_source_value::text, count(1) 
from omop.drug_exposure
where drug_type_concept_id = 38000177 
GROUP BY 1 ORDER BY 2,1 desc;
' 
,'same drugs for prescrip'
);

-- 3.  principaux medicaments de prescripitoin
SELECT results_eq
(
'
SELECT count(1)
FROM omop.drug_exposure 
where drug_source_concept_id = 0
'
,
'
SELECT 0::integer;
' 
,'is concept source id full filled'
);


SELECT * FROM finish();
ROLLBACK;
