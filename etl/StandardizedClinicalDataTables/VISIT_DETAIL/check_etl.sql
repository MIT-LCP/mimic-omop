
-- -----------------------------------------------------------------------------
-- File created - January-9-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

-- 1. Should run 0 lines
WITH tmp as
(
        SELECT hadm_id, count(1) counter
        from transfers
        where eventtype is distinct from 'discharge'
        group by 1 order by 2 desc
),
minus_bed_changement as
(
        SELECT hadm_id, count(*) nb_minus
        FROM transfers
        WHERE prev_wardid = curr_wardid
        group by hadm_id
),
mimic as
(
SELECT hadm_id,
   case when nb_minus is null then counter else counter - nb_minus end as total
FROM tmp
LEFT JOIN minus_bed_changement USING (hadm_id)
order by 2 desc
),
omop as
(

SELECT hadm_id, count(1) as total
from omop.visit_detail v
JOIN admissions a ON v.visit_occurrence_id = a.mimic_id
WHERE v.visit_type_concept_id = 44818518
group by 1 order by 2 desc
)
SELECT * from omop
EXCEPT
SELECT * from mimic
;

BEGIN;

SELECT plan(2);
-- 2.links checker (1)
SELECT results_eq
(
'
SELECT count(visit_source_concept_id) FROM omop.visit_detail group by visit_source_concept_id order by 1 desc;
'
,
'
SELECT count(visit_source_value) FROM omop.visit_detail group by visit_source_value order by 1 desc;
'
);

-- 3.links checker (2)
SELECT results_eq
(
'
SELECT count(admitting_source_concept_id) FROM omop.visit_detail group by admitting_source_concept_id order by 1 desc;
'
,
'
SELECT count(admitting_source_value) FROM omop.visit_detail group by admitting_source_value order by 1 desc;
'
);

SELECT * FROM finish();
ROLLBACK;
