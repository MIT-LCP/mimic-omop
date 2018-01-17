
-- -----------------------------------------------------------------------------
-- File created - January-9-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 6 );

-- 1. number admission checker
SELECT results_eq
(
'
SELECT count(*) FROM admissions;
'

,
'
SELECT count(*) FROM omop.visit_occurrence;
' 
);


-- 2. repartition visit_source_value
SELECT results_eq
(
'
SELECT cast(admission_type as TEXT) as visit_source_value, count(1) FROM admissions group by 1 ORDER BY 2 DESC;
'
,
'
SELECT cast (visit_source_value as TEXT), count(1) FROM omop.visit_occurrence group by 1 ORDER BY 2 DESC;
'
);

-- 3. repartition admitting_source_value
SELECT results_eq
(
'
SELECT cast(admission_location as TEXT) as admitting_source_value, count(1) FROM admissions group by 1 ORDER BY 2 DESC;
'
,
'
SELECT cast(admitting_source_value as TEXT), count(1) FROM omop.visit_occurrence group by 1 ORDER BY 2 DESC;
'
);

-- 4. repartition discharge_to_source_value
SELECT results_eq
(
'
SELECT cast(discharge_location as TEXT) as discharge_to_source_value, count(1) FROM admissions group by 1 ORDER BY 2 DESC;
'
,
'
SELECT cast(discharge_to_source_value as TEXT), count(1) FROM omop.visit_occurrence group by 1 ORDER BY 2 DESC;
'
);


-- 5.links checker (1)
SELECT results_eq
(
'
SELECT count(visit_source_concept_id) FROM omop.visit_occurrence group by visit_source_concept_id order by 1 desc;
'
,
'
SELECT count(visit_source_value) FROM omop.visit_occurrence group by visit_source_value order by 1 desc;
'
);

-- 6.links checker (2)
SELECT results_eq
(
'
SELECT count(admitting_source_concept_id) FROM omop.visit_occurrence group by admitting_source_concept_id order by 1 desc;
'
,
'
SELECT count(admitting_source_value) FROM omop.visit_occurrence group by admitting_source_value order by 1 desc;
'
);

SELECT * FROM finish();
ROLLBACK;
