WITH
"google_drug_table" AS (SELECT drug_exposure_id as row_id, drug_concept_id::text as concept_code, drug_source_value, route_concept_id, route_source_value, effective_drug_dose, dose_unit_concept_id, dose_unit_source_value FROM gcpt_gdata_drug_exposure JOIN prescriptions ON (drug_exposure_id = row_id)),
"omop_rxnorm" AS (SELECT concept_id as drug_concept_id, concept_code FROM  omop.concept WHERE domain_id = 'Drug' AND vocabulary_id = 'RxNorm'),
"drug_exposure" AS (SELECT subject_id, hadm_id, row_id, mimic_id as drug_exposure_id, startdate as drug_exposure_start_datetime, enddate as drug_exposure_end_datetime FROM prescriptions),
"patients" AS (SELECT subject_id, mimic_id as person_id from patients),
"admissions" AS (SELECT hadm_id, mimic_id as visit_occurrence_id FROM admissions)
INSERT INTO omop.drug_exposure
SELECT 
  drug_exposure_id
, person_id
, coalesce(drug_concept_id, 0) as drug_concept_id
, drug_exposure_start_datetime::date as drug_exposure_start_date
, drug_exposure_start_datetime
, drug_exposure_end_datetime::date as drug_exposure_end_date
, drug_exposure_end_datetime
, null as verbatim_end_date
, 38000177 as drug_type_concept_id
, null as stop_reason
, null as refills
, null as quantity
, null as days_supply
, null as sig
, route_concept_id
, null as lot_number
, null as provider_id
, visit_occurrence_id
, null as visit_detail_id
, drug_source_value
, null as drug_source_concept_id
, route_source_value
, dose_unit_source_value
FROM drug_exposure
LEFT JOIN google_drug_table USING (row_id)
LEFT JOIN omop_rxnorm USING (concept_code)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
WHERE drug_exposure_end_datetime IS NOT NULL;
