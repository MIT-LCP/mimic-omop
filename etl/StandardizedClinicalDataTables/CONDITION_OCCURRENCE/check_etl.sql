
-- -----------------------------------------------------------------------------
-- File created - January-13-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 8 );

SELECT results_eq
(
'
SELECT COUNT(distinct person_id), COUNT(distinct visit_occurrence_id)
FROM omop.condition_occurrence
WHERE condition_type_concept_id != 42894222;
'
,
'
SELECT COUNT(distinct subject_id), COUNT(distinct hadm_id)
FROM diagnoses_icd
WHERE icd9_code IS NOT NULL;
'
,
'CONDITION OCCURRENCE -- check ICD diagnoses row count matches'
);

SELECT results_eq
(
'
WITH tmp as
(
  SELECT distinct on (visit_occurrence_id) *
  FROM omop.condition_occurrence
  WHERE condition_type_concept_id = 42894222
)
SELECT condition_source_value::text, COUNT(1)
FROM tmp
GROUP BY 1
ORDER BY 2, 1;
'
,
'
SELECT diagnosis::text, COUNT(1)
FROM admissions
GROUP BY 1
ORDER BY 2, 1;
'
,
'CONDITION OCCURRENCE -- diagnosis in admission same'
);

SELECT results_eq
(
'
with tmp as
(
  SELECT distinct on (visit_occurrence_id) *
  FROM omop.condition_occurrence
  WHERE condition_type_concept_id = 42894222
)
SELECT condition_source_value::text, COUNT(1)
FROM tmp
GROUP BY 1
ORDER BY 2, 1;
'
,
'
SELECT diagnosis::text, COUNT(1)
FROM admissions
GROUP BY 1
ORDER BY 2, 1
'
,
'CONDITION OCCURRENCE -- distrib diagnosis the same'
);

SELECT results_eq
(
'
SELECT COUNT(1)::INTEGER
FROM omop.condition_occurrence
WHERE condition_source_concept_id = 0;
'
,
'
SELECT 0::INTEGER;
'
,
'CONDITION OCCURRENCE -- there is source concept in measurement not described'
);

SELECT results_eq
(
'
SELECT COUNT(1)::INTEGER
FROM
(
  SELECT COUNT(1)::INTEGER
  FROM omop.condition_occurrence
  GROUP BY condition_occurrence_id
  having COUNT(1) > 1
) as t;
'
,
'
SELECT 0::INTEGER;
'
,
'CONDITION OCCURRENCE -- primary key checker'
);

SELECT results_eq
(
'
SELECT COUNT(1)::INTEGER
FROM omop.condition_occurrence
LEFT JOIN omop.concept ON condition_concept_id = concept_id
WHERE condition_concept_id != 0
AND standard_concept != ''S'';
'
,
'
SELECT 0::INTEGER;
'
,
'CONDITION OCCURRENCE -- standard concept checker'
);

SELECT results_eq
(
'
WITH tmp AS
(
  SELECT visit_detail_id, visit_occurrence_id
  , CASE
      WHEN condition_end_datetime < condition_start_datetime
      THEN 1
    ELSE 0 END AS abnormal
  FROM omop.condition_occurrence
)
SELECT sum(abnormal)::INTEGER FROM tmp;
'
,
'
SELECT 0::INTEGER;
'
,
'CONDITION OCCURRENCE -- start_datetime should be > end_datetime'
);

SELECT results_eq
(
'
WITH tmp AS
(
  SELECT visit_detail_id, visit_occurrence_id
  , CASE
      WHEN condition_end_date < condition_start_date
      THEN 1
    ELSE 0 END AS abnormal
  FROM omop.condition_occurrence
)
SELECT sum(abnormal)::INTEGER FROM tmp;
'
,
'
SELECT 0::INTEGER;
'
,
'CONDITION OCCURRENCE -- start_date should be > end_date'
);

SELECT * FROM finish();
ROLLBACK;
