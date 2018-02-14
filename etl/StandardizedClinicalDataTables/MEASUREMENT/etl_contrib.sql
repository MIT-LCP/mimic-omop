-- Derived values from labeevent

with
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"gcpt_lab_unit_to_concept" AS (SELECT unit as unit_source_value, concept_id as unit_concept_id FROM gcpt_lab_unit_to_concept),
"gcpt_derived_to_concept" as (select measurement_source_value, itemid, mimic_id as measurement_source_concept_id, concept_id as measurement_concept_id from gcpt_derived_to_concept),
"row_to_insert" as (
	SELECT
	  nextval('mimic_id_seq') as measurement_id
	, person_id
	, coalesce(measurement_concept_id, 0) as measurement_concept_id -- mapped
	, charttime::date as measurement_date
	, charttime::timestamp as measurement_datetime
	, 45754907 as measurement_type_concept_id --derived value
	, 4172703 as operator_concept_id -- =
	, valuenum as value_as_number
	, CASE WHEN flag = 'abnormal' THEN  45878745 --abnormal 
	  ELSE NULL END as value_as_concept_id      -- this shouldn't actually be here, no way to put this information into range too
	, unit_concept_id
	, null::numeric as range_low
	, null::numeric as range_high
	, null::integer as provider_id
	, visit_occurrence_id
	, gcpt_derived_to_concept.measurement_source_value
	, gcpt_derived_to_concept.measurement_source_concept_id
	, valueuom as unit_source_value
	, null::text as value_source_value
	FROM mimiciii.gcpt_derived_values
	JOIN patients using(subject_id)
	left join admissions using(hadm_id)
	left join gcpt_lab_unit_to_concept on valueuom = unit_source_value
	left join gcpt_derived_to_concept using(itemid)
)
INSERT INTO omop.measurement
SELECT
  row_to_insert.measurement_id
, row_to_insert.person_id
, row_to_insert.measurement_concept_id
, row_to_insert.measurement_date
, row_to_insert.measurement_datetime
, row_to_insert.measurement_type_concept_id
, row_to_insert.operator_concept_id
, row_to_insert.value_as_number
, row_to_insert.value_as_concept_id
, row_to_insert.unit_concept_id
, row_to_insert.range_low
, row_to_insert.range_high
, row_to_insert.provider_id
, row_to_insert.visit_occurrence_id
, visit_detail_assign.visit_detail_id
, row_to_insert.measurement_source_value
, row_to_insert.measurement_source_concept_id
, row_to_insert.unit_source_value
, row_to_insert.value_source_value
FROM row_to_insert
LEFT JOIN omop.visit_detail_assign 
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND
(--only one visit_detail
(is_first IS TRUE AND is_last IS TRUE)
OR -- first
(is_first IS TRUE AND is_last IS FALSE AND row_to_insert.measurement_datetime <= visit_detail_assign.visit_end_datetime)
OR -- last
(is_last IS TRUE AND is_first IS FALSE AND row_to_insert.measurement_datetime > visit_detail_assign.visit_start_datetime)
OR -- middle
(is_last IS FALSE AND is_first IS FALSE AND row_to_insert.measurement_datetime > visit_detail_assign.visit_start_datetime AND row_to_insert.measurement_datetime <= visit_detail_assign.visit_end_datetime)
);

-- Derived values from noteevents

with
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"gcpt_derived_to_concept" as (select measurement_source_value, itemid, mimic_id as measurement_source_concept_id, concept_id as measurement_concept_id from gcpt_derived_to_concept),
"row_to_insert" as (
	SELECT
	  nextval('mimic_id_seq') as measurement_id
	, person_id
	, coalesce(measurement_concept_id, 0) as measurement_concept_id -- mapped
	, charttime::date as measurement_date
	, charttime::timestamp as measurement_datetime
	, 45754907 as measurement_type_concept_id --derived value
	, CASE WHEN exact_value IS NOT NULL THEN 4172703 --=
               WHEN inf_egal_value  IS NOT NULL THEN  4171756   --<
               WHEN sup_egal_value IS NOT NULL THEN 4172704   END  -->
          as operator_concept_id 
	, coalesce(exact_value, inf_egal_value, sup_egal_value) as value_as_number
	, null::integer as value_as_concept_id
	, 8554 as unit_concept_id -- percent
	, null::numeric as range_low
	, null::numeric as range_high
	, null::integer as provider_id
	, visit_occurrence_id
	, gcpt_derived_to_concept.measurement_source_value
	, gcpt_derived_to_concept.measurement_source_concept_id
	, '%' as unit_source_value
	, null::text as value_source_value
	FROM gcpt_derived_fevg
	JOIN patients using(subject_id)
	left join admissions using(hadm_id)
	left join gcpt_derived_to_concept on 'LVEF from noteevents' = measurement_source_value
        WHERE coalesce(exact_value, inf_egal_value, sup_egal_value) IS NOT NULL
)
INSERT INTO omop.measurement
SELECT
  row_to_insert.measurement_id
, row_to_insert.person_id
, row_to_insert.measurement_concept_id
, row_to_insert.measurement_date
, row_to_insert.measurement_datetime
, row_to_insert.measurement_type_concept_id
, row_to_insert.operator_concept_id
, row_to_insert.value_as_number
, row_to_insert.value_as_concept_id
, row_to_insert.unit_concept_id
, row_to_insert.range_low
, row_to_insert.range_high
, row_to_insert.provider_id
, row_to_insert.visit_occurrence_id
, null as visit_detail_id
, row_to_insert.measurement_source_value
, row_to_insert.measurement_source_concept_id
, row_to_insert.unit_source_value
, row_to_insert.value_source_value
FROM row_to_insert;
