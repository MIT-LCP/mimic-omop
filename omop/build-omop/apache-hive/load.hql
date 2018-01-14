USE mimicomop;
set hive.exec.dynamic.partition=true;
SET hive.enforce.bucketing=true;
SET hive.enforce.sorting=true;

--
-- PERSON
--

-- MOUNT AVRO INTO HIVE
CREATE EXTERNAL TABLE avro_person ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION 'hdfs://$HDFS_HOST/user/edsdev/mimic-omop-avro/person/' TBLPROPERTIES ('avro.schema.url'='hdfs://$HDFS_HOST/user/edsdev/mimic-omop-avro/person.avsc');

DROP TABLE person;
CREATE TABLE person ( person_id INT, year_of_birth INT, month_of_birth INT, day_of_birth INT, birth_datetime TIMESTAMP, race_concept_id INT, ethnicity_concept_id INT, location_id INT, provider_id INT, care_site_id INT, person_source_value STRING, gender_source_value STRING, gender_source_concept_id INT, race_source_value STRING, race_source_concept_id INT, ethnicity_source_value STRING, ethnicity_source_concept_id INT)
 PARTITIONED by (gender_concept_id INT)
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
PARTITION (gender_concept_id)
SELECT
  person_id
, year_of_birth
, month_of_birth
, day_of_birth
, birth_datetime
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
, gender_concept_id
FROM mimicomop.avro_person
ORDER BY person_id, birth_datetime;

--UPDATE STATISTICS
ANALYZE TABLE person COMPUTE STATISTICS;
ANALYZE TABLE person COMPUTE STATISTICS FOR COLUMNS;



--
-- DEATH
--


-- MOUNT AVRO INTO HIVE
CREATE EXTERNAL TABLE avro_death ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION 'hdfs://$HDFS_HOST/user/edsdev/mimic-omop-avro/death/' TBLPROPERTIES ('avro.schema.url'='hdfs://$HDFS_HOST/user/edsdev/mimic-omop-avro/death.avsc');

CREATE TABLE death ( person_id INT, death_date DATE, death_datetime TIMESTAMP, cause_concept_id INT, cause_source_value STRING, cause_source_concept_id INT) 
 PARTITIONED by (death_type_concept_id INT)
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='person_id',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;

--PUSH AVRO DATA INTO ORC
INSERT OVERWRITE TABLE person  
PARTITION (death_type_concept_id)
SELECT
  person_id					
, death_date					
, death_datetime				
, cause_concept_id				
, cause_source_value				
, cause_source_concept_id		
, death_type_concept_id			
FROM mimicomop.avro_death
ORDER BY person_id;

--UPDATE STATISTICS
ANALYZE TABLE death COMPUTE STATISTICS;
ANALYZE TABLE death COMPUTE STATISTICS FOR COLUMNS;

--
-- VISIT_OCCURRENCE
--

-- MOUNT AVRO INTO HIVE
CREATE EXTERNAL TABLE avro_visit_occurrence ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe' STORED as INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat' OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat' LOCATION 'hdfs://$HDFS_HOST/user/edsdev/mimic-omop-avro/visit_occurrence/' TBLPROPERTIES ('avro.schema.url'='hdfs://$HDFS_HOST/user/edsdev/mimic-omop-avro/visit_occurrence.avsc');

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
, visit_start_date				
, visit_start_datetime			
, visit_end_date				
, visit_end_datetime				
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
-- VISIT_DETAIL
--

