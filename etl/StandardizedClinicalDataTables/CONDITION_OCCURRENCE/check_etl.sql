
-- -----------------------------------------------------------------------------
-- File created - January-13-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 5 );

-- 1. condition_occurrence nb patients corresponding with icd9_code
SELECT results_eq
(
'
SELECT count(distinct person_id), count(distinct visit_occurrence_id)
FROM omop.condition_occurrence
WHERE condition_type_concept_id != 42894222;
'
,
'
SELECT count(distinct subject_id), count(distinct hadm_id) FROM diagnoses_icd where icd9_code is not null;
' 
,'nb icd'
);

-- 2. condition_occurrence nb patients corresponding with admissions
SELECT results_eq
(
'
WITH tmp as 
(SELECT distinct on (visit_occurrence_id) * from omop.condition_occurrence where condition_type_concept_id = 42894222)
SELECT condition_source_value::text, count(1) 
FROM tmp  
group by condition_source_value order by count(condition_source_value) desc;
'
,
'
SELECT diagnosis::text, count(1) from admissions group by diagnosis order by count(1) desc;
' 
,'diagnosis in admission same '
);


-- 3. repartition of diagnosis
SELECT results_eq
(
'
with tmp as 
(SELECT distinct on (visit_occurrence_id) * from omop.condition_occurrence where condition_type_concept_id = 42894222)
SELECT condition_source_value::text, count(1) 
FROM tmp 
group by condition_source_value order by count(condition_source_value) desc;
'
,
'
SELECT diagnosis::text, count(1) from admissions group by 1 order by 2 desc
' 
,
'distrib diagnosis the same'
);

SELECT results_eq
(
'
select 0::integer;
'
,
'
SELECT count(1)::integer
FROM omop.condition_occurrence
where condition_source_concept_id = 0;
'
,
'there is source concept in measurement not described'
);

SELECT results_eq
(
'
select 0::integer;
'
,
'
select count(1)::integer from (
SELECT count(1)::integer
FROM omop.condition_occurrence
group by condition_occurrence_id
having count(1) > 1) as t;
'
,
'primary key checker'
);
SELECT pass( 'Condition pass, w00t!' );

SELECT * FROM finish();
ROLLBACK;
