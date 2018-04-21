DROP VIEW IF EXISTS omop.measurement_denorm;
CREATE OR REPLACE VIEW omop.measurement_denorm AS
 SELECT measurement.measurement_id,
    measurement.person_id,
    measurement.measurement_concept_id,
    cpt_meas.concept_name AS measurement_concept_name,
    cpt_meas.concept_code AS measurement_concept_code,
    cpt_meas.vocabulary_id AS measurement_concept_code_system,
    measurement.measurement_date,
    measurement.measurement_datetime,
    measurement.measurement_type_concept_id,
    cpt_type.concept_name AS measurement_type_concept_name,
    measurement.operator_concept_id,
    cpt_op.concept_name AS operator_concept_name,
    measurement.value_as_number,
    measurement.value_as_concept_id,
    measurement.unit_concept_id,
    cpt_unit.concept_name AS unit_concept_name,
    measurement.range_low,
    measurement.range_high,
    measurement.provider_id,
    measurement.visit_occurrence_id,
    measurement.visit_detail_id,
    measurement.measurement_source_value,
    measurement.measurement_source_concept_id,
    measurement.unit_source_value,
    measurement.value_source_value
   FROM omop.measurement
     LEFT JOIN omop.concept cpt_meas ON measurement.measurement_concept_id = cpt_meas.concept_id
     LEFT JOIN omop.concept cpt_type ON measurement.measurement_type_concept_id = cpt_type.concept_id
     LEFT JOIN omop.concept cpt_op ON measurement.operator_concept_id = cpt_op.concept_id
     LEFT JOIN omop.concept cpt_unit ON measurement.unit_concept_id = cpt_unit.concept_id;

DROP VIEW IF EXISTS omop.care_site_denorm;
CREATE VIEW omop.care_site_denorm AS 
SELECT
	  care_site_id                  
	, care_site_name                
	, place_of_service_concept_id   
	, cpt.concept_name AS place_of_service_concept_name
	, cpt.concept_code AS place_of_service_concept_code
	, cpt.vocabulary_id AS place_of_service_concept_code_system
	, location_id                   
	, care_site_source_value        
	, place_of_service_source_value 
FROM omop.care_site
LEFT JOIN omop.concept cpt ON place_of_service_concept_id = cpt.concept_id;

DROP VIEW IF EXISTS omop.condition_occurrence_denorm;
CREATE VIEW omop.condition_occurrence_denorm AS 
SELECT
  condition_occurrence_id       
, person_id                     
, condition_concept_id          
, cpt1.concept_name AS condition_concept_name
, cpt1.concept_code AS condition_concept_code
, cpt1.vocabulary_id AS condition_concept_code_system
, condition_start_date          
, condition_start_datetime      
, condition_end_date            
, condition_end_datetime        
, condition_type_concept_id     
, cpt2.concept_name AS condition_type_concept_name
, stop_reason                   
, provider_id                   
, visit_occurrence_id           
, visit_detail_id               
, condition_source_value        
, condition_source_concept_id   
, cpt3.concept_name AS condition_source_concept_name
, condition_status_source_value 
, condition_status_concept_id   
, cpt4.concept_name AS condition_status_concept_name
FROM omop.condition_occurrence
LEFT JOIN omop.concept cpt1 ON condition_concept_id = cpt1.concept_id
LEFT JOIN omop.concept cpt2 ON condition_type_concept_id = cpt2.concept_id
LEFT JOIN omop.concept cpt3 ON condition_source_concept_id = cpt3.concept_id
LEFT JOIN omop.concept cpt4 ON condition_status_concept_id = cpt4.concept_id;

