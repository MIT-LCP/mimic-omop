
-- -----------------------------------------------------------------------------
-- File created - January-9-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 6 );

-- 1. comparaison of transfers
SELECT results_eq
(
'
SELECT hadm_id, count(1) as total
from omop.visit_detail v
JOIN admissions a ON v.visit_occurrence_id = a.mimic_id 
group by 1 order by 2 desc;
'

,
'
WITH tmp as
(
        SELECT hadm_id, count(1) counter
        from transfers
        where eventtype != 'discharge'
        group by 1 order by 2 desc

),
add_emergency as
(
        SELECT hadm_id
          , case when edregtime is not null then counter + 1 else counter end as counter
        from tmp
        JOIN admissions using (hadm_id)

),
minus_bed_changement as
(
        SELECT hadm_id, count(*) nb_minus
        FROM transfers
        WHERE prev_careunit = curr_careunit
        group by hadm_id

)
SELECT hadm_id,
   case when nb_minus is null then counter else counter - nb_minus end as total
FROM add_emergency
LEFT JOIN minus_bed_changement USING (hadm_id)
order by 2 desc;

'
);

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
