
-- -----------------------------------------------------------------------------
-- File created - January-9-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------


BEGIN;

SELECT plan( 7 );

SELECT results_eq
(
'
WITH tmp as
(
        SELECT hadm_id, count(1) counter
        from transfers
        where eventtype is distinct from ''discharge''
        group by 1 order by 2 desc
),
minus_bed_changement as
(
        SELECT hadm_id, count(*) nb_minus
        FROM transfers
        WHERE prev_wardid = curr_wardid
        group by hadm_id
)
SELECT hadm_id,
   case when nb_minus is null then counter else counter - nb_minus end as total
FROM tmp
LEFT JOIN minus_bed_changement USING (hadm_id)
order by 2 desc;'
,
'
SELECT hadm_id, count(1) as total
from omop.visit_detail v
JOIN admissions a ON v.visit_occurrence_id = a.mimic_id
WHERE v.visit_type_concept_id = 4079617
group by 1 order by 2 desc
;'
,
'Visit_detail table -- not same number transfers'
);



SELECT results_eq
(
'
SELECT count(visit_source_concept_id) FROM omop.visit_detail group by visit_source_concept_id order by 1 desc;
'
,
'
SELECT count(visit_source_value) FROM omop.visit_detail group by visit_source_value order by 1 desc;
'
,
'Visit_detail table -- not same visit source/concept_id'
);



SELECT results_eq
(
'
SELECT count(admitting_source_concept_id) FROM omop.visit_detail group by admitting_source_concept_id order by 1 desc;
'
,
'
SELECT count(admitting_source_value) FROM omop.visit_detail group by admitting_source_value order by 1 desc;
'
,
'Visit_detail table -- not same admitting source/concept_id'
);



SELECT results_eq
(
'
SELECT COUNT(distinct subject_id), COUNT(distinct hadm_id)
FROM icustays;

'
,
'
SELECT COUNT(distinct person_id), COUNT(distinct visit_occurrence_id)
FROM omop.visit_detail
WHERE visit_detail_concept_id = 581382                             -- concept.concept_name = 'Inpatient Intensive Care Facility'
AND visit_type_concept_id = 2000000006;
'
,
'Visit_detail table -- not same patients number in visit_detail/icustays'
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
        SELECT visit_detail_id, visit_occurrence_id, CASE WHEN visit_end_datetime < visit_start_datetime THEN 1 ELSE 0 END AS abnormal
        FROM omop.visit_detail
)
SELECT max(abnormal) FROM tmp;
'
,
'Visit_detail table -- start_datetime > end_datetime'
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
        SELECT visit_detail_id, visit_occurrence_id, CASE WHEN visit_end_date < visit_start_date THEN 1 ELSE 0 END AS abnormal
        FROM omop.visit_detail
)
SELECT max(abnormal) FROM tmp;
'
,
'Visit_detail table -- start_date > end_date'
);

select results_eq
(
	'select count(*) as res from omop.visit_detail where care_site_id IS NULL;'
	,'select 0::integer as res;'
	, 'all join to care site'
)

SELECT * FROM finish();
ROLLBACK;
