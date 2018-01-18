USE mimicomop;
set hive.exec.dynamic.partition=true;
SET hive.enforce.bucketing=true;
SET hive.enforce.sorting=true;

--
-- concept_ancestor
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_concept_ancestor;
CREATE EXTERNAL TABLE avro_concept_ancestor ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/concept_ancestor/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/concept_ancestor.avsc');

DROP TABLE IF EXISTS concept_ancestor;

--PUSH AVRO DATA INTO ORC
CREATE TABLE concept_ancestor STORED AS ORC AS
SELECT
  ancestor_concept_id       
, descendant_concept_id    
, min_levels_of_separation 
, max_levels_of_separation 

FROM mimicomop.avro_concept_ancestor;
--
-- vocabulary
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_vocabulary;
CREATE EXTERNAL TABLE avro_vocabulary ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/vocabulary/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/vocabulary.avsc');

DROP TABLE IF EXISTS vocabulary;

--PUSH AVRO DATA INTO ORC
CREATE TABLE vocabulary STORED AS ORC AS
SELECT
  vocabulary_id         
, vocabulary_name       
, vocabulary_reference  
, vocabulary_version    
, vocabulary_concept_id 
FROM mimicomop.avro_vocabulary;

--
-- domain
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_domain;
CREATE EXTERNAL TABLE avro_domain ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/domain/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/domain.avsc');

DROP TABLE IF EXISTS domain;

--PUSH AVRO DATA INTO ORC
CREATE TABLE domain STORED AS ORC AS
SELECT
  domain_id         
, domain_name       
, domain_concept_id 
FROM mimicomop.avro_domain;
--
-- relationship
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_relationship;
CREATE EXTERNAL TABLE avro_relationship ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/relationship/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/relationship.avsc');

DROP TABLE IF EXISTS relationship;

--PUSH AVRO DATA INTO ORC
CREATE TABLE relationship STORED AS ORC AS
SELECT
  relationship_id         
, relationship_name       
, is_hierarchical         
, defines_ancestry        
, reverse_relationship_id 
, relationship_concept_id 
FROM mimicomop.avro_relationship;


--
-- drug_strengh
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_drug_strengh;
CREATE EXTERNAL TABLE avro_drug_strengh ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/drug_strengh/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/drug_strengh.avsc');

DROP TABLE IF EXISTS drug_strengh;

--PUSH AVRO DATA INTO ORC
CREATE TABLE drug_strengh STORED AS ORC AS
SELECT
  drug_concept_id            
, ingredient_concept_id      
, amount_value               
, amount_unit_concept_id     
, numerator_value            
, numerator_unit_concept_id  
, denominator_value          
, denominator_unit_concept_id
, box_size                   
, from_unixtime(CAST(valid_start_date           /1000 as BIGINT), 'yyyy-MM-dd') AS valid_start_date           
, from_unixtime(CAST(valid_end_date             /1000 as BIGINT), 'yyyy-MM-dd') AS valid_end_date             
, invalid_reason            
FROM mimicomop.avro_drug_strengh;

--
-- concept_synonym
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_concept_synonym;
CREATE EXTERNAL TABLE avro_concept_synonym ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/concept_synonym/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/concept_synonym.avsc');

DROP TABLE IF EXISTS concept_synonym;

--PUSH AVRO DATA INTO ORC
CREATE TABLE concept_synonym STORED AS ORC AS
SELECT
  concept_id           
, concept_synonym_name 
, language_concept_id  
FROM mimicomop.avro_concept_synonym;

--
-- concept_relationship
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_concept_relationship;
CREATE EXTERNAL TABLE avro_concept_relationship ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/concept_relationship/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/concept_relationship.avsc');

DROP TABLE IF EXISTS concept_relationship;

--PUSH AVRO DATA INTO ORC
CREATE TABLE concept_relationship STORED AS ORC AS
SELECT
  concept_id_1     
, concept_id_2     
, relationship_id  
, from_unixtime(CAST(valid_start_date /1000 as BIGINT), 'yyyy-MM-dd') AS valid_start_date 
, valid_end_date   
, invalid_reason   
FROM mimicomop.avro_concept_relationship;

--
-- concept_class
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_concept_class;
CREATE EXTERNAL TABLE avro_concept_class ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/concept_class/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/concept_class.avsc');

DROP TABLE IF EXISTS concept_class;

--PUSH AVRO DATA INTO ORC
CREATE TABLE concept_class STORED AS ORC AS
SELECT
  concept_class_id         
, concept_class_name       
, concept_class_concept_id 
FROM mimicomop.avro_concept_class;

--
-- concept
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_concept;
CREATE EXTERNAL TABLE avro_concept ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/concept/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/concept.avsc');

DROP TABLE IF EXISTS concept;

--PUSH AVRO DATA INTO ORC
CREATE TABLE concept STORED AS ORC AS
SELECT
  concept_id          
, concept_name           
, domain_id              
, vocabulary_id          
, concept_class_id       
, standard_concept       
, concept_code           
, from_unixtime(CAST(valid_start_date     /1000 as BIGINT), 'yyyy-MM-dd') AS valid_start_date     
, from_unixtime(CAST(valid_end_date       /1000 as BIGINT), 'yyyy-MM-dd') AS valid_end_date       
, invalid_reason         
FROM mimicomop.avro_concept;

--
-- care_site
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_care_site;
CREATE EXTERNAL TABLE avro_care_site ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/care_site/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/care_site.avsc');

DROP TABLE IF EXISTS care_site;

--PUSH AVRO DATA INTO ORC
CREATE TABLE care_site STORED AS ORC AS
SELECT
  care_site_id				
, care_site_name				
, place_of_service_concept_id		
, location_id				
, care_site_source_value			
, place_of_service_source_value		
FROM mimicomop.avro_care_site;


--
-- cohort_definition
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_cohort_definition;
CREATE EXTERNAL TABLE avro_cohort_definition ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/cohort_definition/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/cohort_definition.avsc');

DROP TABLE IF EXISTS corhort_definition;

--PUSH AVRO DATA INTO ORC
CREATE TABLE cohort_definition STORED AS ORC AS
SELECT
  cohort_definition_id		
, cohort_definition_name	
, cohort_definition_description	
, definition_type_concept_id	
, cohort_definition_syntax	
, subject_concept_id		
, from_unixtime(CAST(cohort_initiation_date	/1000 as BIGINT), 'yyyy-MM-dd') AS cohort_initiation_date	
FROM mimicomop.avro_cohort_definition;

--
-- cohort_attribute
--

-- MOUNT AVRO INTO HIVE

DROP TABLE IF EXISTS avro_cohort_attribute;
CREATE EXTERNAL TABLE avro_cohort_attribute ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/cohort_attribute/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/cohort_attribute.avsc');

DROP TABLE IF EXISTS cohort_attribute;

--PUSH AVRO DATA INTO ORC
CREATE TABLE cohort_attribute STORED AS ORC AS
SELECT
  cohort_definition_id
, from_unixtime(CAST(cohort_start_date /1000 as BIGINT), 'yyyy-MM-dd') AS cohort_start_date 
, from_unixtime(CAST(cohort_end_date /1000 as BIGINT), 'yyyy-MM-dd') AS cohort_end_date 
, subject_id 
, attribute_definition_id 
, value_as_number 
, value_as_concept_id 
FROM mimicomop.avro_cohort_attribute;


--
-- attribute_definition
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_attribute_definition;
CREATE EXTERNAL TABLE avro_attribute_definition ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/attribute_definition/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/attribute_definition.avsc');

DROP TABLE IF EXISTS attribute_definition;

--PUSH AVRO DATA INTO ORC
CREATE TABLE attribute_definition STORED AS ORC AS 
SELECT
   attribute_definition_id		
,  attribute_name			
,  attribute_description			
,  attribute_type_concept_id		
,  attribute_syntax			
FROM mimicomop.avro_attribute_definition;


--
-- person
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_person;
CREATE EXTERNAL TABLE avro_person ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/person/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/person.avsc');

DROP TABLE IF EXISTS person;

--PUSH AVRO DATA INTO ORC
CREATE TABLE person  STORED AS ORC AS
SELECT
  person_id
, gender_concept_id
, year_of_birth
, month_of_birth
, day_of_birth
, from_unixtime(CAST(birth_datetime/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS birth_datetime
, race_concept_id
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
FROM mimicomop.avro_person;


--
-- death
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_death;
CREATE EXTERNAL TABLE avro_death ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/death/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/death.avsc');

DROP TABLE IF EXISTS death;

--PUSH AVRO DATA INTO ORC
CREATE TABLE death STORED AS ORC AS
SELECT
  person_id					
, from_unixtime(CAST(death_date					/1000 as BIGINT), 'yyyy-MM-dd') AS death_date					
, from_unixtime(CAST(death_datetime/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS death_datetime				
, death_type_concept_id
, cause_concept_id				
, cause_source_value				
, cause_source_concept_id		
FROM mimicomop.avro_death ;


--
-- visit_occurrence
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_visit_occurrence;
CREATE EXTERNAL TABLE avro_visit_occurrence ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/visit_occurrence/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/visit_occurrence.avsc');

DROP TABLE IF EXISTS visit_occurrence;

--PUSH AVRO DATA INTO ORC
CREATE TABLE visit_occurrence STORED AS ORC AS
SELECT
  visit_occurrence_id			
, person_id					
, visit_concept_id				
, from_unixtime(CAST(visit_start_date		/1000 as BIGINT), 'yyyy-MM-dd') AS visit_start_date				
, from_unixtime(CAST(visit_start_datetime	/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS visit_start_datetime			
, from_unixtime(CAST(visit_end_date		/1000 as BIGINT), 'yyyy-MM-dd') AS visit_end_date				
, from_unixtime(CAST(visit_end_datetime		/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS visit_end_datetime				
, provider_id				
, care_site_id				
, visit_source_value				
, visit_source_concept_id			
, admitting_source_concept_id		
, admitting_source_value			
, discharge_to_concept_id			
, discharge_to_source_value			
, preceding_visit_occurrence_id		
, visit_type_concept_id			
FROM mimicomop.avro_visit_occurrence ;



--
-- visit_detail
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_visit_detail;
CREATE EXTERNAL TABLE avro_visit_detail ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/visit_detail/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/visit_detail.avsc');

DROP TABLE IF EXISTS visit_detail;

--PUSH AVRO DATA INTO ORC
CREATE TABLE visit_detail STORED AS ORC AS 
SELECT
  visit_detail_id				
, person_id					
, visit_detail_concept_id			
, from_unixtime(CAST(visit_start_date				/1000 as BIGINT), 'yyyy-MM-dd') AS visit_start_date				
, from_unixtime(CAST(visit_start_datetime			/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS visit_start_datetime			
, from_unixtime(CAST(visit_end_date				/1000 as BIGINT), 'yyyy-MM-dd') AS visit_end_date				
, from_unixtime(CAST(visit_end_datetime				/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS visit_end_datetime				
, visit_type_concept_id			
, provider_id				
, care_site_id				
, visit_source_value				
, visit_source_concept_id			
, admitting_source_concept_id		
, admitting_source_value			
, discharge_to_concept_id			
, discharge_to_source_value			
, preceding_visit_detail_id			
, visit_detail_parent_id			
, visit_occurrence_id			
FROM mimicomop.avro_visit_detail;


--
-- procedure_occurrence
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_procedure_occurrence;
CREATE EXTERNAL TABLE avro_procedure_occurrence ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/procedure_occurrence/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/procedure_occurrence.avsc');

DROP TABLE IF EXISTS procedure_occurrence;

--PUSH AVRO DATA INTO ORC
CREATE TABLE procedure_occurrence STORED AS ORC AS
SELECT
  procedure_occurrence_id		
, person_id				
, procedure_concept_id		
, from_unixtime(CAST(procedure_date			/1000 as BIGINT), 'yyyy-MM-dd') AS procedure_date			
, from_unixtime(CAST(procedure_datetime			/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS procedure_datetime			
, modifier_concept_id		
, quantity				
, provider_id			
, visit_occurrence_id		
, visit_detail_id			
, procedure_source_value		
, procedure_source_concept_id	
, qualifier_source_value		
, procedure_type_concept_id		
FROM mimicomop.avro_procedure_occurrence;


--
-- provider
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_provider;
CREATE EXTERNAL TABLE avro_provider ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/provider/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/provider.avsc');

DROP TABLE IF EXISTS provider;

--PUSH AVRO DATA INTO ORC
CREATE TABLE provider  STORED AS ORC AS
SELECT
  provider_id  
, provider_name  
, NPI  
, DEA  
, specialty_concept_id  
, care_site_id  
, year_of_birth  
, gender_concept_id  
, provider_source_value  
, specialty_source_value  
, specialty_source_concept_id  
, gender_source_value  
, gender_source_concept_id 
FROM mimicomop.avro_provider;



--
-- condition_occurrence
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_condition_occurrence;
CREATE EXTERNAL TABLE avro_condition_occurrence ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/condition_occurrence/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/condition_occurrence.avsc');

DROP TABLE IF EXISTS condition_occurrence;

--PUSH AVRO DATA INTO ORC
CREATE TABLE condition_occurrence  STORED AS ORC AS
SELECT
  condition_occurrence_id		
, person_id				
, condition_concept_id		
, from_unixtime(CAST(condition_start_date		/1000 as BIGINT), 'yyyy-MM-dd') AS condition_start_date		
, from_unixtime(CAST(condition_start_datetime		/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS condition_start_datetime		
, from_unixtime(CAST(condition_end_date		/1000 as BIGINT), 'yyyy-MM-dd') AS condition_end_date		
, from_unixtime(CAST(condition_end_datetime		/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS condition_end_datetime		
, stop_reason			
, provider_id			
, visit_occurrence_id		
, visit_detail_id			
, condition_source_value		
, condition_source_concept_id	
, condition_status_source_value	
, condition_status_concept_id	
, condition_type_concept_id
FROM mimicomop.avro_condition_occurrence;


--
-- observation
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_observation;
CREATE EXTERNAL TABLE avro_observation ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/observation/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/observation.avsc');

DROP TABLE IF EXISTS observation;

--PUSH AVRO DATA INTO ORC
CREATE TABLE observation  STORED AS ORC AS 
SELECT
  observation_id			
, person_id				
, observation_concept_id		
, from_unixtime(CAST(observation_date			/1000 as BIGINT), 'yyyy-MM-dd') AS observation_date			
, from_unixtime(CAST(observation_datetime			/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS observation_datetime			
, value_as_number			 
, value_as_string			
, value_as_concept_id			
, qualifier_concept_id			
, unit_concept_id			
, provider_id				
, visit_occurrence_id			
, visit_detail_id			
, observation_source_value		
, observation_source_concept_id		
, unit_source_value			
, qualifier_source_value			
, observation_type_concept_id		
FROM mimicomop.avro_observation;



--
-- drug_exposure
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_drug_exposure;
CREATE EXTERNAL TABLE avro_drug_exposure ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/drug_exposure/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/drug_exposure.avsc');

DROP TABLE IF EXISTS drug_exposure;

--PUSH AVRO DATA INTO ORC
CREATE TABLE TABLE drug_exposure  STORED AS ORC AS
SELECT
  drug_exposure_id			
, person_id				
, drug_concept_id			
, from_unixtime(CAST(drug_exposure_start_date		/1000 as BIGINT), 'yyyy-MM-dd') AS drug_exposure_start_date		
, from_unixtime(CAST(drug_exposure_start_datetime	/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS drug_exposure_start_datetime	
, from_unixtime(CAST(drug_exposure_end_date		/1000 as BIGINT), 'yyyy-MM-dd') AS drug_exposure_end_date		
, from_unixtime(CAST(drug_exposure_end_datetime		/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS drug_exposure_end_datetime		
, from_unixtime(CAST(verbatim_end_date			/1000 as BIGINT), 'yyyy-MM-dd') AS verbatim_end_date			
, stop_reason			
, refills				
, quantity				
, days_supply			
, sig				
, route_concept_id			
, lot_number				
, provider_id			
, visit_occurrence_id		
, visit_detail_id			
, drug_source_value			
, drug_source_concept_id		
, route_source_value			
, dose_unit_source_value		
, drug_type_concept_id		
FROM mimicomop.avro_drug_exposure;


--
-- measurement
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_measurement;
CREATE EXTERNAL TABLE avro_measurement ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/measurement/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/measurement.avsc');

DROP TABLE IF EXISTS measurement;

--PUSH AVRO DATA INTO ORC
CREATE TABLE measurement  STORED AS ORC AS
SELECT
  measurement_id			
, person_id				
, measurement_concept_id		
, from_unixtime(CAST(measurement_date			/1000 as BIGINT), 'yyyy-MM-dd') AS measurement_date			
, from_unixtime(CAST(measurement_datetime		/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS measurement_datetime		
, operator_concept_id			
, value_as_number		
, value_as_concept_id			
, unit_concept_id				
, range_low					 
, range_high					 
, provider_id				
, visit_occurrence_id			
, visit_detail_id		        	
, measurement_source_value			 
, measurement_source_concept_id		
, unit_source_value				
, value_source_value				
, measurement_type_concept_id
FROM mimicomop.avro_measurement;


--
-- note
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_note;
CREATE EXTERNAL TABLE avro_note ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/note/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/note.avsc');

DROP TABLE IF EXISTS note;

--PUSH AVRO DATA INTO ORC
CREATE TABLE note  STORED AS ORC AS
SELECT
  note_id					 
, person_id					
, from_unixtime(CAST(note_date					/1000 as BIGINT), 'yyyy-MM-dd') AS note_date					
, from_unixtime(CAST(note_datetime				/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS note_datetime				
, note_type_concept_id			
, note_class_concept_id			
, note_title					
, note_text					
, encoding_concept_id			
, language_concept_id			
, provider_id				
, visit_occurrence_id			
, note_source_value				
, visit_detail_id				
FROM mimicomop.avro_note;


--
-- note_nlp
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_note_nlp;
CREATE EXTERNAL TABLE avro_note_nlp ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/note_nlp/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/note_nlp.avsc');

DROP TABLE IF EXISTS note_nlp;

--PUSH AVRO DATA INTO ORC
CREATE TABLE note_nlp  STORED AS ORC AS
SELECT
  note_nlp_id                           
, note_id                              
, section_concept_id                   
, snippet                              
, lexical_variant                      
, note_nlp_concept_id                  
, note_nlp_source_concept_id           
, nlp_system                           
, from_unixtime(CAST(nlp_date                             /1000 as BIGINT), 'yyyy-MM-dd') AS nlp_date                             
, from_unixtime(CAST(nlp_datetime                         /1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS nlp_datetime                         
, term_exists                                 
, term_temporal                               
, term_modifiers                              
, offset_begin                                
, offset_end                                  
, section_source_value                        
, section_source_concept_id                   
FROM mimicomop.avro_note_nlp;


--
-- fact_relationship
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_fact_relationship;
CREATE EXTERNAL TABLE avro_fact_relationship ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/fact_relationship/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/fact_relationship.avsc');

DROP TABLE IF EXISTS fact_relationship;

--PUSH AVRO DATA INTO ORC
CREATE TABLE fact_relationship  STORED AS ORC AS 
SELECT
  domain_concept_id_1			
, fact_id_1					
, domain_concept_id_2			
, fact_id_2					
, relationship_concept_id
FROM mimicomop.avro_fact_relationship;
