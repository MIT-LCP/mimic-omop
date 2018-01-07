WITH
"google_drug_table" AS (SELECT drug_exposure_id as row_id, drug_concept_id::text as concept_code, route_concept_id, route_source_value, effective_drug_dose, dose_unit_concept_id, dose_unit_source_value FROM gcpt_gdata_drug_exposure JOIN prescriptions ON (drug_exposure_id = row_id)),
"omop_rxnorm" AS (SELECT concept_id as drug_concept_id, concept_code FROM  omop.concept WHERE domain_id = 'Drug' AND vocabulary_id = 'RxNorm'),
"drug_exposure" AS (SELECT trim(drug || ' ' || prod_strength) as drug_source_value, subject_id, hadm_id, row_id, mimic_id as drug_exposure_id, startdate as drug_exposure_start_datetime, enddate as drug_exposure_end_datetime FROM prescriptions),
"patients" AS (SELECT subject_id, mimic_id as person_id from patients),
"admissions" AS (SELECT hadm_id, mimic_id as visit_occurrence_id FROM admissions),
"omop_local_drug" AS (SELECT concept_name as drug_source_value, concept_id as drug_source_concept_id FROM omop.concept WHERE domain_id = 'Drug' AND vocabulary_id = 'MIMIC Generated'),
"row_to_insert" AS (
	SELECT 
  drug_exposure_id
, person_id
, coalesce(drug_concept_id, 0) as drug_concept_id
, drug_exposure_start_datetime::date as drug_exposure_start_date
, to_datetime(drug_exposure_start_datetime) AS drug_exposure_start_datetime
, drug_exposure_end_datetime::date as drug_exposure_end_date
, to_datetime(drug_exposure_end_datetime) AS drug_exposure_end_datetime
, null::date as verbatim_end_date
, 38000177 as drug_type_concept_id
, null::text as stop_reason
, null::integer as refills
, null::numeric as quantity
, null::integer as days_supply
, null::text as sig
, route_concept_id
, null::text as lot_number
, null::integer as provider_id
, visit_occurrence_id
, null::integer as visit_detail_id
, drug_source_value
, drug_source_concept_id
, route_source_value
, dose_unit_source_value
FROM drug_exposure
LEFT JOIN omop_local_drug USING (drug_source_value)
LEFT JOIN google_drug_table USING (row_id)
LEFT JOIN omop_rxnorm USING (concept_code)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
WHERE drug_exposure_end_datetime IS NOT NULL)
INSERT INTO omop.drug_exposure
SELECT
  row_to_insert.drug_exposure_id
, row_to_insert.person_id
, row_to_insert.drug_concept_id
, row_to_insert.drug_exposure_start_date
, row_to_insert.drug_exposure_start_datetime
, row_to_insert.drug_exposure_end_date
, row_to_insert.drug_exposure_end_datetime
, row_to_insert.verbatim_end_date
, row_to_insert.drug_type_concept_id
, row_to_insert.stop_reason
, row_to_insert.refills
, row_to_insert.quantity
, row_to_insert.days_supply
, row_to_insert.sig
, row_to_insert.route_concept_id
, row_to_insert.lot_number
, row_to_insert.provider_id
, row_to_insert.visit_occurrence_id
, row_to_insert.visit_detail_id
, row_to_insert.drug_source_value
, row_to_insert.drug_source_concept_id
, row_to_insert.route_source_value
, row_to_insert.dose_unit_source_value
FROM row_to_insert;

-- FROM inputevent
-- WITH
-- "inputevent_cv" AS (
-- 	SELECT
-- 	subject_id
-- 	hadm_id
-- 	storetime as drug_exposure_start_datetime
-- FROM inputevents_cv
-- JOIN gcpt_inputevents_drug_to_concept USING (itemid))
