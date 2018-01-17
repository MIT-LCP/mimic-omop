BEGIN;

SELECT plan(1);

-- 1.check if culture/sensibility links are well populated
SELECT results_eq
(
'
select count(*)::integer as result
from omop.measurement  m
join omop.fact_relationship  on fact_id_1 = m.measurement_id
left join omop.measurement n on fact_id_2 = n.measurement_id
where true
and domain_concept_id_1 =  21
and domain_concept_id_2 =  21
and relationship_concept_id =44818757
and n.measurement_id IS  null;
'
,
'
select 0::integer as result;
'
,'culture / sensitiviy not well polullated'
);

SELECT * from finish();
ROLLBACK;
