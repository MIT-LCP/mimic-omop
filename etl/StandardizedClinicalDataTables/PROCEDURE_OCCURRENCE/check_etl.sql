
-- -----------------------------------------------------------------------------
-- File created - January-8-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;


SELECT plan (3);

-- procedureevents_mv --
-- 1. number patients checker
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
);

-- 2. label repartition
SELECT results_eq
(
'
SELECT label, count(1) 
from procedureevents_mv 
JOIN d_items using (itemid) 
where cancelreason = 0 
group by 1 order by 2 desc;
'
,
'
SELECT procedure_source_value, count(1)
from omop.procedure_occurrence
where procedure_type_concept_id = 38000275 
group by procedure_source_value order by count(1) desc;
' 
);

-- cptevents --
-- 3. number patient checker
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
);


-- 4. label repartition
SELECT results_eq
(
'
SELECT count(1) from cptevents group by costcenter, sectionheader, subsectionheader, description order by count(*) desc;
'
,
'
SELECT  count(1)
from omop.procedure_occurrence
where procedure_type_concept_id = 38003622
group by procedure_source_value order by count(1) desc;
' 
);

-- procedures_icd --
-- 4. number patient checker
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
);


-- 5. label repartition
SELECT results_eq
(
'
SELECT count(1) from cptevents group by costcenter, sectionheader, subsectionheader, description order by count(*) desc;
'
,
'
SELECT  count(1)
from omop.procedure_occurrence
where procedure_type_concept_id = 257
group by procedure_source_value order by count(1) desc;
' 
);

SELECT * FROM finish();
ROLLBACK;
