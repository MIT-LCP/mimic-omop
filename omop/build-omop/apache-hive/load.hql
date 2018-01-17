USE mimicomop;
set hive.exec.dynamic.partition=true;
SET hive.enforce.bucketing=true;
SET hive.enforce.sorting=true;

--
-- concept
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_concept;
CREATE EXTERNAL TABLE avro_concept ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/concept/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/concept.avsc');

DROP TABLE IF EXISTS concept;
CREATE TABLE concept ( concept_id        INT  , concept_name      STRING     , domain_id         STRING     , vocabulary_id     STRING     , concept_class_id  STRING     , standard_concept  STRING     , concept_code      STRING     , valid_start_date  DATE     , valid_end_date    DATE     , invalid_reason    STRING     ) 
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='concept_id,domain_id,vocabulary_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE concept
SELECT
 concept_id          
, concept_name           
, domain_id              
, vocabulary_id          
, concept_class_id       
, standard_concept       
, concept_code           
, valid_start_date     
, valid_end_date       
, invalid_reason         
FROM mimicomop.avro_concept
ORDER BY concept_id,place_of_service_concept_id;

--UPDATE STATISTICS
ANALYZE TABLE concept COMPUTE STATISTICS;
ANALYZE TABLE concept COMPUTE STATISTICS FOR COLUMNS;
--
-- care_site
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_care_site;
CREATE EXTERNAL TABLE avro_care_site ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/care_site/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/care_site.avsc');

DROP TABLE IF EXISTS care_site;
CREATE TABLE care_site ( care_site_id INT , care_site_name STRING , place_of_service_concept_id INT , location_id INT , care_site_source_value STRING , place_of_service_source_value STRING) 
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='care_site_id,place_of_service_concept_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE care_site
SELECT
  care_site_id				
, care_site_name				
, place_of_service_concept_id		
, location_id				
, care_site_source_value			
, place_of_service_source_value		
FROM mimicomop.avro_care_site
ORDER BY care_site_id,place_of_service_concept_id;

--UPDATE STATISTICS
ANALYZE TABLE care_site COMPUTE STATISTICS;
ANALYZE TABLE care_site COMPUTE STATISTICS FOR COLUMNS;


--
-- cohort_definition
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_cohort_definition;
CREATE EXTERNAL TABLE avro_cohort_definition ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/cohort_definition/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/cohort_definition.avsc');

DROP TABLE IF EXISTS cohort_definition;
CREATE TABLE cohort_definition ( cohort_definition_id INT, cohort_definition_name STRING, cohort_definition_description STRING, definition_type_concept_id INT, cohort_definition_syntax STRING, subject_concept_id INT, cohort_initiation_date DATE)
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='cohort_definition_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE cohort_definition
SELECT
  cohort_definition_id		
, cohort_definition_name	
, cohort_definition_description	
, definition_type_concept_id	
, cohort_definition_syntax	
, subject_concept_id		
, from_unixtime(CAST(cohort_initiation_date	/1000 as BIGINT), 'yyyy-MM-dd') AS cohort_initiation_date	
FROM mimicomop.avro_cohort_definition
ORDER BY cohort_definition_id;

--UPDATE STATISTICS
ANALYZE TABLE cohort_definition COMPUTE STATISTICS;
ANALYZE TABLE cohort_definition COMPUTE STATISTICS FOR COLUMNS;

--
-- cohort_attribute
--

-- MOUNT AVRO INTO HIVE

DROP TABLE IF EXISTS avro_cohort_attribute;
CREATE EXTERNAL TABLE avro_cohort_attribute ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/cohort_attribute/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/cohort_attribute.avsc');

DROP TABLE IF EXISTS cohort_attribute;
CREATE TABLE cohort_attribute ( cohort_definition_id INT , cohort_start_date DATE , cohort_end_date DATE , subject_id INT , attribute_definition_id INT , value_as_number DECIMAL , value_as_concept_id INT) 
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='subject_id,value_as_number',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE cohort_attribute
SELECT
  cohort_definition_id
, from_unixtime(CAST(cohort_start_date /1000 as BIGINT), 'yyyy-MM-dd') AS cohort_start_date 
, from_unixtime(CAST(cohort_end_date /1000 as BIGINT), 'yyyy-MM-dd') AS cohort_end_date 
, subject_id 
, attribute_definition_id 
, value_as_number 
, value_as_concept_id 
FROM mimicomop.avro_cohort_attribute
ORDER BY subject_id,value_as_number;

--UPDATE STATISTICS
ANALYZE TABLE cohort_attribute COMPUTE STATISTICS;
ANALYZE TABLE cohort_attribute COMPUTE STATISTICS FOR COLUMNS;

--
-- attribute_definition
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_attribute_definition;
CREATE EXTERNAL TABLE avro_attribute_definition ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/attribute_definition/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/attribute_definition.avsc');

DROP TABLE IF EXISTS attribute_definition;
CREATE TABLE attribute_definition ( attribute_definition_id INT, attribute_name STRING, attribute_description STRING, attribute_type_concept_id INT, attribute_syntax STRING)
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE attribute_definition
SELECT
   attribute_definition_id		
,  attribute_name			
,  attribute_description			
,  attribute_type_concept_id		
,  attribute_syntax			
FROM mimicomop.avro_attribute_definition
ORDER BY attribute_definition_id;

--UPDATE STATISTICS
ANALYZE TABLE attribute_definition COMPUTE STATISTICS;
ANALYZE TABLE attribute_definition COMPUTE STATISTICS FOR COLUMNS;


--
-- person
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_person;
CREATE EXTERNAL TABLE avro_person ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/person/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/person.avsc');

DROP TABLE IF EXISTS person;
CREATE TABLE person ( person_id INT, gender_concept_id INT, year_of_birth INT, month_of_birth INT, day_of_birth INT, birth_datetime TIMESTAMP, race_concept_id INT, ethnicity_concept_id INT, location_id INT, provider_id INT, care_site_id INT, person_source_value STRING, gender_source_value STRING, gender_source_concept_id INT, race_source_value STRING, race_source_concept_id INT, ethnicity_source_value STRING, ethnicity_source_concept_id INT)
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='person_id,birth_datetime',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE person  
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
FROM mimicomop.avro_person
ORDER BY person_id, birth_datetime;

--UPDATE STATISTICS
ANALYZE TABLE person COMPUTE STATISTICS;
ANALYZE TABLE person COMPUTE STATISTICS FOR COLUMNS;

--
-- death
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_death;
CREATE EXTERNAL TABLE avro_death ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/death/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/death.avsc');

DROP TABLE IF EXISTS death;
CREATE TABLE death ( person_id INT, death_date DATE, death_datetime TIMESTAMP, death_type_concept_id INT, cause_concept_id INT, cause_source_value STRING, cause_source_concept_id INT) 
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='person_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE death
SELECT
  person_id					
, from_unixtime(CAST(death_date					/1000 as BIGINT), 'yyyy-MM-dd') AS death_date					
, from_unixtime(CAST(death_datetime/1000 as BIGINT), 'yyyy-MM-dd HH:mm:dd') AS death_datetime				
, death_type_concept_id
, cause_concept_id				
, cause_source_value				
, cause_source_concept_id		
FROM mimicomop.avro_death
ORDER BY person_id;

--UPDATE STATISTICS
ANALYZE TABLE death COMPUTE STATISTICS;
ANALYZE TABLE death COMPUTE STATISTICS FOR COLUMNS;

--
-- visit_occurrence
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_visit_occurrence;
CREATE EXTERNAL TABLE avro_visit_occurrence ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/visit_occurrence/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/visit_occurrence.avsc');

DROP TABLE IF EXISTS visit_occurrence;
CREATE TABLE visit_occurrence ( visit_occurrence_id INT, person_id INT, visit_concept_id INT, visit_start_date DATE, visit_start_datetime TIMESTAMP, visit_end_date DATE, visit_end_datetime TIMESTAMP, provider_id INT, care_site_id INT, visit_source_value STRING, visit_source_concept_id INT, admitting_source_concept_id INT, admitting_source_value STRING, discharge_to_concept_id INT, discharge_to_source_value STRING, preceding_visit_occurrence_id INT, visit_type_concept_id INT) 
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='visit_occurrence_id,person_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE visit_occurrence
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
FROM mimicomop.avro_visit_occurrence
ORDER BY visit_occurrence_id, person_id;

--UPDATE STATISTICS
ANALYZE TABLE visit_occurrence COMPUTE STATISTICS;
ANALYZE TABLE visit_occurrence COMPUTE STATISTICS FOR COLUMNS;


--
-- visit_detail
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_visit_detail;
CREATE EXTERNAL TABLE avro_visit_detail ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/visit_detail/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/visit_detail.avsc');

DROP TABLE IF EXISTS visit_detail;
CREATE TABLE visit_detail ( visit_detail_id INT , person_id INT , visit_detail_concept_id INT , visit_start_date DATE , visit_start_datetime TIMESTAMP , visit_end_date DATE , visit_end_datetime TIMESTAMP , visit_type_concept_id INT , provider_id INT, care_site_id INT, visit_source_value STRING, visit_source_concept_id INT , admitting_source_concept_id INT , admitting_source_value STRING , discharge_to_concept_id INT , discharge_to_source_value STRING , preceding_visit_detail_id INT , visit_detail_parent_id INT , visit_occurrence_id INT ) 
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='visit_occurrence_id,visit_detail_parent_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE visit_detail
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
FROM mimicomop.avro_visit_detail
ORDER BY visit_occurrence_id, visit_detail_parent_id;

--UPDATE STATISTICS
ANALYZE TABLE visit_detail COMPUTE STATISTICS;
ANALYZE TABLE visit_detail COMPUTE STATISTICS FOR COLUMNS;

--
-- procedure_occurrence
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_procedure_occurrence;
CREATE EXTERNAL TABLE avro_procedure_occurrence ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/procedure_occurrence/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/procedure_occurrence.avsc');

DROP TABLE IF EXISTS procedure_occurrence;
CREATE TABLE procedure_occurrence ( procedure_occurrence_id INT , person_id INT , procedure_concept_id INT , procedure_date DATE , procedure_datetime TIMESTAMP , modifier_concept_id INT , quantity INT , provider_id INT , visit_occurrence_id INT , visit_detail_id INT , procedure_source_value STRING , procedure_source_concept_id INT , qualifier_source_value STRING) 
PARTITIONED by (procedure_type_concept_id INT)
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='person_id,visit_occurrence_id,visit_detail_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE procedure_occurrence 
PARTITION (procedure_type_concept_id)
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
FROM mimicomop.avro_procedure_occurrence
ORDER BY person_id,visit_occurrence_id,visit_detail_id;

--UPDATE STATISTICS
ANALYZE TABLE procedure_occurrence PARTITION (procedure_type_concept_id) COMPUTE STATISTICS;
ANALYZE TABLE procedure_occurrence PARTITION (procedure_type_concept_id) COMPUTE STATISTICS FOR COLUMNS;

--
-- provider
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_provider;
CREATE EXTERNAL TABLE avro_provider ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/provider/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/provider.avsc');

DROP TABLE IF EXISTS provider;
CREATE TABLE provider ( provider_id INT , provider_name STRING , NPI STRING , DEA STRING , specialty_concept_id INT , care_site_id INT , year_of_birth INT , gender_concept_id INT , provider_source_value STRING , specialty_source_value STRING , specialty_source_concept_id INT , gender_source_value STRING , gender_source_concept_id INT) 
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='provider_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE provider 
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
FROM mimicomop.avro_provider
ORDER BY provider_id;

--UPDATE STATISTICS
ANALYZE TABLE provider COMPUTE STATISTICS;
ANALYZE TABLE provider COMPUTE STATISTICS FOR COLUMNS;


--
-- condition_occurrence
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_condition_occurrence;
CREATE EXTERNAL TABLE avro_condition_occurrence ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/condition_occurrence/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/condition_occurrence.avsc');

DROP TABLE IF EXISTS condition_occurrence;
CREATE TABLE condition_occurrence ( condition_occurrence_id INT , person_id INT , condition_concept_id INT , condition_start_date DATE , condition_start_datetime TIMESTAMP , condition_end_date DATE , condition_end_datetime TIMESTAMP , stop_reason STRING , provider_id INT , visit_occurrence_id INT , visit_detail_id INT , condition_source_value STRING , condition_source_concept_id INT , condition_status_source_value STRING , condition_status_concept_id INT ) 
PARTITIONED by (condition_type_concept_id INT)
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='person_id,visit_occurrence_id,visit_detail_id,condition_concept_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE condition_occurrence 
PARTITION (condition_type_concept_id)
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
FROM mimicomop.avro_condition_occurrence
ORDER BY person_id,visit_occurrence_id,visit_detail_id,condition_concept_id;

--UPDATE STATISTICS
ANALYZE TABLE condition_occurrence PARTITION (condition_type_concept_id) COMPUTE STATISTICS;
ANALYZE TABLE condition_occurrence PARTITION (condition_type_concept_id) COMPUTE STATISTICS FOR COLUMNS;


--
-- observation
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_observation;
CREATE EXTERNAL TABLE avro_observation ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/observation/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/observation.avsc');

DROP TABLE IF EXISTS observation;
CREATE TABLE observation ( observation_id INT , person_id INT , observation_concept_id INT , observation_date DATE , observation_datetime TIMESTAMP ,  value_as_number DECIMAL , value_as_string STRING , value_as_concept_id INT , qualifier_concept_id INT , unit_concept_id INT , provider_id INT , visit_occurrence_id INT , visit_detail_id INT , observation_source_value STRING , observation_source_concept_id INT , unit_source_value STRING , qualifier_source_value STRING) 
 PARTITIONED by (observation_type_concept_id INT)
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='person_id,visit_occurrence_id,visit_detail_id,observation_concept_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE observation 
PARTITION (observation_type_concept_id)
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
FROM mimicomop.avro_observation
ORDER BY person_id,visit_occurrence_id,visit_detail_id,observation_concept_id;

--UPDATE STATISTICS
ANALYZE TABLE observation PARTITION (observation_type_concept_id) COMPUTE STATISTICS;
ANALYZE TABLE observation PARTITION (observation_type_concept_id) COMPUTE STATISTICS FOR COLUMNS;


--
-- drug_exposure
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_drug_exposure;
CREATE EXTERNAL TABLE avro_drug_exposure ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/drug_exposure/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/drug_exposure.avsc');

DROP TABLE IF EXISTS drug_exposure;
CREATE TABLE drug_exposure ( drug_exposure_id INT , person_id INT , drug_concept_id INT , drug_exposure_start_date DATE , drug_exposure_start_datetime TIMESTAMP , drug_exposure_end_date DATE , drug_exposure_end_datetime TIMESTAMP , verbatim_end_date DATE ,  stop_reason STRING , refills INT , quantity DECIMAL , days_supply INT , sig STRING , route_concept_id INT , lot_number STRING , provider_id INT , visit_occurrence_id INT , visit_detail_id INT , drug_source_value STRING , drug_source_concept_id INT , route_source_value STRING , dose_unit_source_value STRING) 
 PARTITIONED by (drug_type_concept_id INT)
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='person_id,visit_occurrence_id,visit_detail_id,drug_concept_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE drug_exposure 
PARTITION (drug_type_concept_id)
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
FROM mimicomop.avro_drug_exposure
ORDER BY person_id,visit_occurrence_id,visit_detail_id,drug_concept_id;

--UPDATE STATISTICS
ANALYZE TABLE drug_exposure PARTITION (drug_type_concept_id) COMPUTE STATISTICS;
ANALYZE TABLE drug_exposure PARTITION (drug_type_concept_id) COMPUTE STATISTICS FOR COLUMNS;

--
-- measurement
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_measurement;
CREATE EXTERNAL TABLE avro_measurement ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/measurement/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/measurement.avsc');

DROP TABLE IF EXISTS measurement;
CREATE TABLE measurement ( measurement_id INT , person_id INT , measurement_concept_id INT , measurement_date DATE , measurement_datetime TIMESTAMP , operator_concept_id INT , value_as_number DECIMAL , value_as_concept_id INT , unit_concept_id INT , range_low DECIMAL , range_high DECIMAL , provider_id INT , visit_occurrence_id INT , visit_detail_id INT , measurement_source_value STRING , measurement_source_concept_id INT , unit_source_value STRING , value_source_value STRING) 
 PARTITIONED by (measurement_type_concept_id INT)
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='person_id,visit_occurrence_id,visit_detail_id,measurement_concept_id,value_as_number',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE measurement 
PARTITION (measurement_type_concept_id)
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
FROM mimicomop.avro_measurement
ORDER BY person_id,visit_occurrence_id,visit_detail_id,measurement_concept_id,value_as_number;

--UPDATE STATISTICS
ANALYZE TABLE measurement PARTITION (measurement_type_concept_id) COMPUTE STATISTICS;
ANALYZE TABLE measurement PARTITION (measurement_type_concept_id) COMPUTE STATISTICS FOR COLUMNS;

--
-- note
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_note;
CREATE EXTERNAL TABLE avro_note ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/note/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/note.avsc');

DROP TABLE IF EXISTS note;
CREATE TABLE note ( note_id INT , person_id INT , note_date DATE , note_datetime TIMESTAMP , note_type_concept_id INT , note_class_concept_id INT , note_title STRING , note_text STRING , encoding_concept_id INT , language_concept_id INT , provider_id INT , visit_occurrence_id INT , note_source_value STRING , visit_detail_id INT ) 
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='person_id,visit_occurrence_id,note_type_concept_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE note 
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
FROM mimicomop.avro_note
ORDER BY person_id,visit_occurrence_id,note_type_concept_id;

--UPDATE STATISTICS
ANALYZE TABLE note COMPUTE STATISTICS;
ANALYZE TABLE note COMPUTE STATISTICS FOR COLUMNS;

--
-- note_nlp
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_note_nlp;
CREATE EXTERNAL TABLE avro_note_nlp ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/note_nlp/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/note_nlp.avsc');

DROP TABLE IF EXISTS note_nlp;
CREATE TABLE note_nlp ( note_nlp_id INT , note_id INT , section_concept_id INT , snippet STRING , lexical_variant STRING , note_nlp_concept_id INT , note_nlp_source_concept_id INT , nlp_system STRING , nlp_date DATE , nlp_datetime TIMESTAMP , term_exists STRING , term_temporal STRING , term_modifiers STRING , offset_begin INT , offset_end INT , section_source_value STRING , section_source_concept_id INT ) 
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='note_id,section_source_concept_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE note_nlp 
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
FROM mimicomop.avro_note_nlp
ORDER BY note_id,section_source_concept_id;

--UPDATE STATISTICS
ANALYZE TABLE note_nlp COMPUTE STATISTICS;
ANALYZE TABLE note_nlp COMPUTE STATISTICS FOR COLUMNS;

--
-- fact_relationship
--

-- MOUNT AVRO INTO HIVE
DROP TABLE IF EXISTS avro_fact_relationship;
CREATE EXTERNAL TABLE avro_fact_relationship ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION '/user/edsdev/mimic-omop-avro/fact_relationship/' TBLPROPERTIES ('avro.schema.url'='/user/edsdev/mimic-omop-avro/fact_relationship.avsc');

DROP TABLE IF EXISTS fact_relationship;
CREATE TABLE fact_relationship ( domain_concept_id_1 INT , fact_id_1 INT , domain_concept_id_2 INT , fact_id_2 INT)
 PARTITIONED BY (relationship_concept_id INT) 
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='fact_id_1,fact_id_2,domain_concept_id_1,domain_concept_id_2',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE fact_relationship 
PARTITION (relationship_concept_id)
SELECT
  domain_concept_id_1			
, fact_id_1					
, domain_concept_id_2			
, fact_id_2					
, relationship_concept_id
FROM mimicomop.avro_fact_relationship
ORDER BY fact_id_1,fact_id_2,domain_concept_id_1,domain_concept_id_2;

--UPDATE STATISTICS
ANALYZE TABLE fact_relationship PARTITION (relationship_concept_id) COMPUTE STATISTICS;
ANALYZE TABLE fact_relationship PARTITION (relationship_concept_id) COMPUTE STATISTICS FOR COLUMNS;
