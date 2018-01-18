
-- -----------------------------------------------------------------------------
-- File created - January-8-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;


SELECT plan (4);

-- procedureevents_mv --
SELECT results_eq
(
'
SELECT count (*), count(distinct person_id), count(distinct visit_occurrence_id)
from omop.procedure_occurrence
where procedure_type_concept_id = 38000275 ;
'
,
'
SELECT count(*), count(distinct subject_id), count(distinct hadm_id) from procedureevents_mv where cancelreason = 0;
' 
,'-- 1. number patients checker'
);

SELECT results_eq
(
'
SELECT label::text, count(1) 
from procedureevents_mv 
JOIN d_items using (itemid) 
where cancelreason = 0 
group by 1 order by 2,1 desc;
'
,
'
SELECT procedure_source_value::text as label, count(1)
from omop.procedure_occurrence
where procedure_type_concept_id = 38000275 
group by procedure_source_value order by 2,1 desc;
' 
,'-- 2. label repartition'
);

-- cptevents --
SELECT results_eq
(
'
SELECT count(*), count(distinct subject_id), count(distinct hadm_id) from cptevents;
'
,
'
SELECT count (*), count(distinct person_id), count(distinct visit_occurrence_id)
from omop.procedure_occurrence
where procedure_type_concept_id = 257 ;
' 
,'-- 3. number patient checker'
);


SELECT results_eq
(
'
SELECT count(1) from cptevents group by  subsectionheader order by count(*) desc;
'
,
'
SELECT  count(1)
from omop.procedure_occurrence
where procedure_type_concept_id = 257
group by procedure_source_value order by count(1) desc;
' 
,'-- 4. label repartition'
);

-- procedures_icd --
SELECT results_eq
(
'
SELECT count(*), count(distinct subject_id), count(distinct hadm_id) from procedures_icd;
'
,
'
SELECT count (*), count(distinct person_id), count(distinct visit_occurrence_id)
from omop.procedure_occurrence
where procedure_type_concept_id =38003622 ;
' 
,'-- 4. number patient checker'
);


SELECT results_eq
(
'
SELECT count(1) from cptevents group by  subsectionheader order by count(*) desc;
'
,
'
SELECT  count(1)
from omop.procedure_occurrence
where procedure_type_concept_id = 257
group by procedure_source_value order by count(1) desc;
' 
,'-- 5. label repartition'
);

SELECT results_eq
(
'
select 0::integer;
'
,
'
SELECT count(1)::integer
FROM omop.drug_exposure
LEFT JOIN omop.concept ON drug_concept_id = concept_id
WHERE 
drug_concept_id != 0
AND standard_concept != ''S'';
'
,
'Standard concept checker'
);

SELECT pass( 'drug_exposure pass, w00t!' );

SELECT * FROM finish();
ROLLBACK;
