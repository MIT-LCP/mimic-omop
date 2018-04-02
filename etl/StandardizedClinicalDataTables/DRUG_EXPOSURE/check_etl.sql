
-- -----------------------------------------------------------------------------
-- File created - January-15-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 4 );

-- 1. visit_occurrence_nb
SELECT results_eq
(
'
SELECT COUNT(distinct person_id), COUNT(distinct visit_occurrence_id)
FROM omop.drug_exposure
WHERE drug_type_concept_id = 38000177;
'
,
'
SELECT COUNT(distinct subject_id), COUNT(distinct hadm_id)
FROM prescriptions;
'
,'DRUG_EXPOSURE -- check number of patients with prescription matches'
);

-- 2.  principaux medicaments de prescripitoin
SELECT results_eq
(
'
SELECT drug_source_value::text, COUNT(1)
FROM omop.drug_exposure
where drug_type_concept_id = 38000177
GROUP BY 1
ORDER BY 2,1 DESC;
'
,
'
SELECT drug::text, COUNT(1)
FROM prescriptions
GROUP BY 1
ORDER by 2,1 DESC;
'
,'DRUG_EXPOSURE -- check drug_source_value matches source'
);

-- 3.  principaux medicaments de prescripitoin
SELECT results_eq
(
'
SELECT COUNT(1)::integer
FROM omop.drug_exposure
WHERE drug_source_concept_id = 0;
'
,
'
SELECT 0::integer;
'
,'DRUG_EXPOSURE -- is concept source id full filled'
);

SELECT results_eq
(
'
SELECT COUNT(1)::integer
FROM omop.drug_exposure
LEFT JOIN omop.concept
  ON drug_concept_id = concept_id
WHERE drug_concept_id != 0
AND standard_concept != ''S'';
'
,
'
SELECT 0::INTEGER;
'
,
'DRUG_EXPOSURE -- Standard concept checker'
);

SELECT * FROM finish();
ROLLBACK;
