
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
FROM prescriptions
WHERE enddate is not null;
' 
);

-- 2.  principaux medicaments de prescripitoin
SELECT results_eq
(
'
SELECT trim(drug || ' ' || prod_strength), count(1)
from prescriptions 
where enddate is not null group by trim(drug || ' ' || prod_strength) 
ORDER by count(1) desc;
'
,
'
SELECT drug_source_value, count(1) 
from drug_exposure
where drug_type_concept_id = 38000177 
GROUP BY 1 ORDER BY count(1) desc;
' 
);

-- 3.  principaux medicaments de prescripitoin
SELECT results_eq
(
'
SELECT trim(drug || ' ' || prod_strength), min(dose_val_rx::integer), avg(dose_val_rx::integer), max(dose_val_rx::integer)
from prescriptions 
where enddate is not null group by trim(drug || ' ' || prod_strength) 
ORDER by count(1) desc;
'
,
'
SELECT drug_source_value, count(1), min(quantity), avg(quantity), max(quantity)
from drug_exposure
where drug_type_concept_id = 38000177 
GROUP BY 1 ORDER BY count(1) desc;
' 
);


SELECT * FROM finish();
ROLLBACK;
