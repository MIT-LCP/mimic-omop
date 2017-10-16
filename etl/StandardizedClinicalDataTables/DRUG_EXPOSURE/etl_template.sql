 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.DRUG_EXPOSURE ()
 SELECT NA.drug_exposure_id, NA.person_id, NA.drug_concept_id, NA.drug_exposure_start_date, NA.drug_exposure_start_datetime, NA.drug_exposure_end_date, NA.drug_exposure_end_datetime, NA.verbatim_end_date, NA.drug_type_concept_id, NA.stop_reason, NA.refills, NA.quantity, NA.days_supply, NA.sig, NA.route_concept_id, NA.lot_number, NA.provider_id, NA.visit_occurrence_id, NA.drug_source_value, NA.drug_source_concept_id, NA.route_source_value, NA.dose_unit_source_value, NA.visit_detail_id 
FROM NA 