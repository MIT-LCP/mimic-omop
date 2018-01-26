
-- -----------------------------------------------------------------------------
-- File created - January-13-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 7 );

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
,
'Condition_occurrence table -- nb icd'
);

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
,
'Condition_occurrence table -- diagnosis in admission same '
);

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
'Condition_occurrence table -- distrib diagnosis the same'
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
'Condition_occurrence table -- there is source concept in measurement not described'
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
'Condition_occurrence table -- primary key checker'
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
LEFT JOIN omop.concept ON condition_concept_id = concept_id
WHERE 
condition_concept_id != 0
AND standard_concept != ''S'';
'
,
'Condition_occurrence table -- standard concept checker'
);

SELECT results_eq
(
'
select 0::integer;
'
,
'
WITH tmp AS
(
        SELECT visit_detail_id, visit_occurrence_id, CASE WHEN condition_end_datetime < condition_start_datetime THEN 1 ELSE 0 END AS abnormal
        FROM omop.condition_occurrence

)
SELECT max(abnormal) FROM tmp;
'
,
'Condition_occurrence table -- start_datetime > end_datetime'
);

SELECT results_eq
(
'
select 0::integer;
'
,
'
WITH tmp AS
(
        SELECT visit_detail_id, visit_occurrence_id, CASE WHEN condition_end_date < condition_start_date THEN 1 ELSE 0 END AS abnormal
        FROM omop.condition_occurrence

)
SELECT max(abnormal) FROM tmp;
'
,
'Condition_occurrence table -- start_date > end_date'
);

SELECT * FROM finish();
ROLLBACK;
