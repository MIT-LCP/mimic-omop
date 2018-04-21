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
    cpt_unit.concept_code AS unit_concept_code,
    cpt_unit.vocabulary_id AS unit_concept_code_system,
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
, cpt2.concept_code AS condition_type_concept_code
, cpt2.vocabulary_id AS condition_type_concept_code_system
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

--PERSON
DROP VIEW IF EXISTS omop.person_denorm;
CREATE VIEW omop.person_denorm AS 
SELECT
  person_id
, gender_concept_id
, cpt1.concept_name as gender_concept_name
, cpt1.concept_code as gender_concept_code
, cpt1.vocabulary_id as gender_concept_code_system
, year_of_birth
, month_of_birth
, day_of_birth
, birth_datetime
, race_concept_id
, cpt2.concept_name as race_concept_name
, cpt2.concept_code as race_concept_code
, cpt2.vocabulary_id as race_concept_code_system
, ethnicity_concept_id
, location_id
, provider_id
, care_site_id
, person_source_value
, gender_source_value
, gender_source_concept_id
, race_source_value
, race_source_concept_id
, ethnicity_source_value
, ethnicity_source_concept_id
FROM omop.person
LEFT JOIN omop.concept as cpt1 ON cpt1.concept_id = gender_concept_id
LEFT JOIN omop.concept as cpt2 ON cpt2.concept_id = race_concept_id ;

DROP VIEW IF EXISTS omop.visit_occurrence_denorm;
CREATE VIEW omop.visit_occurrence_denorm AS 
SELECT
  visit_occurrence_id
, person_id
, visit_concept_id
, cpt1.concept_name as visit_concept_name
, cpt1.concept_code as visit_concept_code
, cpt1.vocabulary_id as visit_concept_code_system
, visit_start_date
, visit_start_datetime
, visit_end_date
, visit_end_datetime
, visit_type_concept_id
, cpt2.concept_name as visit_type_concept_name
, cpt2.concept_code as visit_type_concept_code
, cpt2.vocabulary_id as visit_type_concept_code_system
, provider_id
, care_site_id
, care_site_name as care_site_code
, place_of_service_source_value as care_site_name
, visit_source_value
, visit_source_concept_id
, admitting_concept_id
, cpt3.concept_name as admitting_concept_name
, cpt3.concept_code as admitting_concept_code
, cpt3.vocabulary_id as admitting_concept_code_system
, admitting_source_value
, admitting_source_concept_id
, discharge_to_concept_id
, cpt4.concept_name as discharge_concept_name
, cpt4.concept_code as discharge_concept_code
, cpt4.vocabulary_id as discharge_concept_code_system
, discharge_to_source_value
, discharge_to_source_concept_id
, preceding_visit_occurrence_id
FROM omop.visit_occurrence
LEFT JOIN omop.concept as cpt1 ON cpt1.concept_id = visit_concept_id
LEFT JOIN omop.concept as cpt2 ON cpt2.concept_id = visit_type_concept_id
LEFT JOIN omop.concept as cpt3 ON cpt3.concept_id = admitting_concept_id
LEFT JOIN omop.concept as cpt4 ON cpt4.concept_id = discharge_to_concept_id
LEFT JOIN omop.care_site as cs USING (care_site_id);

-- VISIT DETAIL
DROP VIEW IF EXISTS omop.visit_detail_denorm;
CREATE VIEW omop.visit_detail_denorm AS 
SELECT
  visit_detail_id                
, person_id                      
, visit_detail_concept_id        
, cpt1.concept_name as visit_detail_concept_name
, cpt1.concept_code as visit_detail_concept_code
, cpt1.vocabulary_id as visit_detail_concept_code_system
, visit_start_date               
, visit_start_datetime           
, visit_end_date                 
, visit_end_datetime             
, visit_type_concept_id          
, cpt2.concept_name as visit_type_concept_name
, cpt2.concept_code as visit_type_concept_code
, cpt2.vocabulary_id as visit_type_concept_code_system
, provider_id                    
, care_site_id                   
, care_site_name as care_site_code
, place_of_service_source_value as care_site_name
, visit_source_value             
, visit_source_concept_id        
, admitting_concept_id           
, cpt3.concept_name as admitting_concept_name
, cpt3.concept_code as admitting_concept_code
, cpt3.vocabulary_id as admitting_concept_code_system
, admitting_source_value         
, admitting_source_concept_id    
, discharge_to_concept_id        
, cpt4.concept_name as discharge_concept_name
, cpt4.concept_code as discharge_concept_code
, cpt4.vocabulary_id as discharge_concept_code_system
, discharge_to_source_value      
, discharge_to_source_concept_id 
, preceding_visit_detail_id      
, visit_detail_parent_id         
, visit_occurrence_id            
FROM omop.visit_detail
LEFT JOIN omop.concept as cpt1 ON cpt1.concept_id = visit_detail_concept_id
LEFT JOIN omop.concept as cpt2 ON cpt2.concept_id = visit_type_concept_id
LEFT JOIN omop.concept as cpt3 ON cpt3.concept_id = admitting_concept_id
LEFT JOIN omop.concept as cpt4 ON cpt4.concept_id = discharge_to_concept_id
LEFT JOIN omop.care_site as cs USING (care_site_id)



