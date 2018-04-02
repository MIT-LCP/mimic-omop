
-- -----------------------------------------------------------------------------
-- File created - January-8-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan(5);

-- procedureevents_mv --
SELECT results_eq
(
'
SELECT count (*), count(distinct person_id), count(distinct visit_occurrence_id)
FROM omop.procedure_occurrence
WHERE procedure_type_concept_id = 38000275 ;
'
,
'
SELECT count(*), count(distinct subject_id), count(distinct hadm_id)
FROM procedureevents_mv
WHERE cancelreason = 0;
'
,'PROCEDURE_OCCURRENCE -- check all procedureevents_mv rows inserted'
);

SELECT results_eq
(
'
SELECT procedure_source_value::text as label, count(1)
from omop.procedure_occurrence
WHERE procedure_type_concept_id = 38000275
GROUP BY procedure_source_value ORDER BY 2,1 desc;
'
,
'
SELECT label::text, count(1)
from procedureevents_mv
JOIN d_items using (itemid)
WHERE cancelreason = 0
GROUP BY 1 ORDER BY 2,1 desc;
'
,'PROCEDURE_OCCURRENCE -- check label is consistent with source_value'
);

-- cptevents --
SELECT results_eq
(
'
SELECT count (*), count(distinct person_id), count(distinct visit_occurrence_id)
from omop.procedure_occurrence
WHERE procedure_type_concept_id = 257 ;
'
,
'
SELECT count(*), count(distinct subject_id), count(distinct hadm_id)
FROM cptevents;
'
,'PROCEDURE_OCCURRENCE -- check all CPT code rows inserted'
);


SELECT results_eq
(
'
SELECT count(1)
FROM omop.procedure_occurrence
WHERE procedure_type_concept_id = 257
GROUP BY procedure_source_value
ORDER BY count(1) DESC;
'
,
'
SELECT count(1)
FROM cptevents
GROUP BY subsectionheader
ORDER BY count(*) DESC;
'
,'PROCEDURE_OCCURRENCE -- check CPT subsections mapped correctly'
);

-- procedures_icd --
SELECT results_eq
(
'
SELECT count(*), count(distinct subject_id), count(distinct hadm_id)
FROM procedures_icd;
'
,
'
SELECT count (*), count(distinct person_id), count(distinct visit_occurrence_id)
FROM omop.procedure_occurrence
WHERE procedure_type_concept_id = 38003622 ;
'
,'PROCEDURE_OCCURRENCE -- check ICD procedure rows inserted'
);

SELECT * FROM finish();
ROLLBACK;
