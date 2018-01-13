/*********************************************************************************
# Copyright 2014-6 Observational Health Data Sciences and Informatics
#
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
********************************************************************************/

/************************

 ####### #     # ####### ######      #####  ######  #     #           #######      #####     
 #     # ##   ## #     # #     #    #     # #     # ##   ##    #    # #           #     #    
 #     # # # # # #     # #     #    #       #     # # # # #    #    # #                 #    
 #     # #  #  # #     # ######     #       #     # #  #  #    #    # ######       #####     
 #     # #     # #     # #          #       #     # #     #    #    #       # ### #          
 #     # #     # #     # #          #     # #     # #     #     #  #  #     # ### #          
 ####### #     # ####### #           #####  ######  #     #      ##    #####  ### #######  
                                                                              

script to create OMOP common data model, version 5.2 for PostgreSQL database

last revised: 14 July 2017

Authors:  Patrick Ryan, Christian Reich


*************************/


/************************

Standardized vocabulary

************************/

SET hive.enforce.bucketing=true;
SET hive.enforce.sorting=true;

CREATE TABLE concept (
  concept_id			INTEGER,
  concept_name			STRING,
  domain_id			STRING,
  vocabulary_id			STRING,
  concept_class_id		STRING,
  standard_concept		STRING,
  concept_code			STRING,
  valid_start_date		DATE,
  valid_end_date		DATE,
  invalid_reason		STRING
)
PARTITIONED by (domain_id INTEGER)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;
INSERT OVERWRITE INTO mimic-omop.concept  PARTITION (domain_id)
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
FROM mimic-avro;



CREATE TABLE vocabulary (
  vocabulary_id			STRING,
  vocabulary_name		STRING,
  vocabulary_reference		STRING,
  vocabulary_version		STRING,
  vocabulary_concept_id		INTEGER
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;




CREATE TABLE domain (
  domain_id			STRING,
  domain_name			STRING,
  domain_concept_id		INTEGER
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE concept_class (
  concept_class_id		STRING,
  concept_class_name		STRING,
  concept_class_concept_id	INTEGER
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;




CREATE TABLE concept_relationship (
  concept_id_1			INTEGER,
  concept_id_2			INTEGER,
  relationship_id		STRING,
  valid_start_date		DATE,
  valid_end_date		DATE,
  invalid_reason		STRING
  )
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE relationship (
  relationship_id		STRING,
  relationship_name		STRING,
  is_hierarchical		STRING,
  defines_ancestry		STRING,
  reverse_relationship_id	STRING,
  relationship_concept_id	INTEGER
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


CREATE TABLE concept_synonym (
  concept_id			INTEGER,
  concept_synonym_name		STRING,
  language_concept_id		INTEGER
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


CREATE TABLE concept_ancestor (
  ancestor_concept_id		INTEGER,
  descendant_concept_id		INTEGER,
  min_levels_of_separation	INTEGER,
  max_levels_of_separation	INTEGER
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE source_to_concept_map (
  source_code			STRING,
  source_concept_id		INTEGER,
  source_vocabulary_id		STRING,
  source_code_description	STRING,
  target_concept_id		INTEGER,
  target_vocabulary_id		STRING,
  valid_start_date		DATE,
  valid_end_date		DATE,
  invalid_reason		STRING
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;




CREATE TABLE drug_strength (
  drug_concept_id		INTEGER,
  ingredient_concept_id		INTEGER,
  amount_value			DECIMAL,
  amount_unit_concept_id	INTEGER,
  numerator_value		DECIMAL,
  numerator_unit_concept_id	INTEGER,
  denominator_value		DECIMAL,
  denominator_unit_concept_id	INTEGER,
  box_size			INTEGER,
  valid_start_date		DATE,
  valid_end_date		DATE,
  invalid_reason		STRING
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE cohort_definition (
  cohort_definition_id			INTEGER,
  cohort_definition_name		STRING,
  cohort_definition_description		STRING,
  definition_type_concept_id		INTEGER,
  cohort_definition_syntax		STRING,
  subject_concept_id			INTEGER,
  cohort_initiation_date		DATE
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


CREATE TABLE attribute_definition (
  attribute_definition_id		INTEGER,
  attribute_name			STRING,
  attribute_description			STRING,
  attribute_type_concept_id		INTEGER,
  attribute_syntax			STRING
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


/**************************

Standardized meta-data

***************************/


CREATE TABLE cdm_source 
    (  
     cdm_source_name					STRING,
	 cdm_source_abbreviation			STRING,
	 cdm_holder					STRING,
	 source_description				STRING,
	 source_documentation_reference			STRING,
	 cdm_etl_reference				STRING,
	 source_release_date				DATE,
	 cdm_release_date				DATE,
	 cdm_version					STRING,
	 vocabulary_version				STRING
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;







/************************

Standardized clinical data

************************/


CREATE TABLE person 
    (
     person_id					INTEGER , 
     gender_concept_id				INTEGER , 
     year_of_birth				INTEGER , 
     month_of_birth				INTEGER, 
     day_of_birth				INTEGER, 
     birth_datetime				TIMESTAMP 	,
     race_concept_id				INTEGER, 
     ethnicity_concept_id			INTEGER, 
     location_id				INTEGER, 
     provider_id				INTEGER, 
     care_site_id				INTEGER, 
     person_source_value			STRING, 
     gender_source_value			STRING,
     gender_source_concept_id			INTEGER, 
     race_source_value				STRING 	, 
     race_source_concept_id			INTEGER, 
     ethnicity_source_value			STRING 	,
     ethnicity_source_concept_id		INTEGER
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;





CREATE TABLE observation_period 
    ( 
     observation_period_id			INTEGER , 
     person_id					INTEGER , 
     observation_period_start_date		DATE , 
     observation_period_start_datetime		TIMESTAMP ,
     observation_period_end_date		DATE ,
     observation_period_end_datetime		TIMESTAMP ,
	 period_type_concept_id			INTEGER
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE specimen
    ( 
         specimen_id					INTEGER ,
	 person_id					INTEGER ,
	 specimen_concept_id				INTEGER ,
	 specimen_type_concept_id			INTEGER ,
	 specimen_date					DATE ,
	 specimen_datetime				TIMESTAMP ,
	 quantity					DECIMAL ,
	 unit_concept_id				INTEGER ,
	 anatomic_site_concept_id			INTEGER ,
	 disease_status_concept_id			INTEGER ,
	 specimen_source_id				STRING ,
	 specimen_source_value				STRING ,
	 unit_source_value				STRING ,
	 anatomic_site_source_value			STRING ,
	 disease_status_source_value			STRING
	)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE death 
    ( 
     person_id						INTEGER , 
     death_date						DATE , 
     death_datetime					TIMESTAMP ,
     death_type_concept_id				INTEGER ,
     cause_concept_id					INTEGER , 
     cause_source_value					STRING,
	 cause_source_concept_id			INTEGER
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE visit_occurrence 
    ( 
     visit_occurrence_id			INTEGER , 
     person_id					INTEGER , 
     visit_concept_id				INTEGER , 
     visit_start_date				DATE , 
     visit_start_datetime			TIMESTAMP ,
     visit_end_date				DATE ,
     visit_end_datetime				TIMESTAMP ,
     visit_type_concept_id			INTEGER ,
     provider_id				INTEGER,
     care_site_id				INTEGER, 
     visit_source_value				STRING,
     visit_source_concept_id			INTEGER ,
     admitting_source_concept_id		INTEGER ,
     admitting_source_value			STRING ,
     discharge_to_concept_id			INTEGER ,
     discharge_to_source_value			STRING ,
     preceding_visit_occurrence_id		INTEGER
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


CREATE TABLE visit_detail
    ( 
     visit_detail_id				INTEGER , 
     person_id					INTEGER , 
     visit_detail_concept_id			INTEGER , 
     visit_start_date				DATE , 
     visit_start_datetime			TIMESTAMP ,
     visit_end_date				DATE ,
     visit_end_datetime				TIMESTAMP ,
     visit_type_concept_id			INTEGER ,
     provider_id				INTEGER,
     care_site_id				INTEGER, 
     visit_source_value				STRING,
     visit_source_concept_id			INTEGER ,
     admitting_source_concept_id		INTEGER ,
     admitting_source_value			STRING ,
     discharge_to_concept_id			INTEGER ,
     discharge_to_source_value			STRING ,
     preceding_visit_detail_id			INTEGER ,
     visit_detail_parent_id			INTEGER ,
     visit_occurrence_id				INTEGER 
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


CREATE TABLE procedure_occurrence 
    ( 
     procedure_occurrence_id		INTEGER , 
     person_id				INTEGER , 
     procedure_concept_id		INTEGER , 
     procedure_date			DATE , 
     procedure_datetime			TIMESTAMP ,
     procedure_type_concept_id		INTEGER ,
     modifier_concept_id		INTEGER ,
     quantity				INTEGER , 
     provider_id			INTEGER , 
     visit_occurrence_id		INTEGER , 
     visit_detail_id			INTEGER ,
     procedure_source_value		STRING ,
     procedure_source_concept_id	INTEGER ,
     qualifier_source_value		STRING
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE drug_exposure 
    ( 
     drug_exposure_id			INTEGER , 
     person_id				INTEGER , 
     drug_concept_id			INTEGER , 
     drug_exposure_start_date		DATE , 
     drug_exposure_start_datetime	TIMESTAMP ,
     drug_exposure_end_date		DATE ,
     drug_exposure_end_datetime		TIMESTAMP ,
     verbatim_end_date			DATE ,
     drug_type_concept_id		INTEGER ,
     stop_reason			STRING , 
     refills				INTEGER , 
     quantity				DECIMAL , 
     days_supply			INTEGER , 
     sig				STRING , 
     route_concept_id			INTEGER ,
     lot_number				STRING ,
     provider_id			INTEGER , 
     visit_occurrence_id		INTEGER , 
     visit_detail_id			INTEGER ,
     drug_source_value			STRING ,
     drug_source_concept_id		INTEGER ,
     route_source_value			STRING ,
     dose_unit_source_value		STRING
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


CREATE TABLE device_exposure 
    ( 
     device_exposure_id				INTEGER , 
     person_id					INTEGER , 
     device_concept_id				INTEGER , 
     device_exposure_start_date			DATE , 
     device_exposure_start_datetime		TIMESTAMP ,
     device_exposure_end_date			DATE ,
     device_exposure_end_datetime		TIMESTAMP ,
     device_type_concept_id			INTEGER ,
     unique_device_id				STRING ,
     quantity					INTEGER ,
     provider_id				INTEGER , 
     visit_occurrence_id			INTEGER , 
     visit_detail_id				INTEGER ,
     device_source_value			STRING ,
     device_source_concept_id			INTEGER
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


CREATE TABLE condition_occurrence 
    ( 
     condition_occurrence_id		INTEGER , 
     person_id				INTEGER , 
     condition_concept_id		INTEGER , 
     condition_start_date		DATE , 
     condition_start_datetime		TIMESTAMP ,
     condition_end_date			DATE ,
     condition_end_datetime		TIMESTAMP ,
     condition_type_concept_id		INTEGER ,
     stop_reason			STRING , 
     provider_id			INTEGER , 
     visit_occurrence_id		INTEGER , 
     visit_detail_id			INTEGER ,
     condition_source_value		STRING ,
     condition_source_concept_id	INTEGER ,
     condition_status_source_value	STRING ,
     condition_status_concept_id	INTEGER 
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE measurement 
    ( 
     measurement_id				INTEGER , 
     person_id					INTEGER , 
     measurement_concept_id			INTEGER , 
     measurement_date				DATE , 
     measurement_datetime			TIMESTAMP ,
     measurement_type_concept_id		INTEGER ,
     operator_concept_id			INTEGER , 
     value_as_number				DECIMAL , 
     value_as_concept_id			INTEGER , 
     unit_concept_id				INTEGER , 
     range_low					DECIMAL , 
     range_high					DECIMAL , 
     provider_id				INTEGER , 
     visit_occurrence_id			INTEGER ,  
     visit_detail_id		        	INTEGER ,
     measurement_source_value			STRING , 
     measurement_source_concept_id		INTEGER ,
     unit_source_value				STRING ,
     value_source_value				STRING
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE note 
    ( 
     note_id					INTEGER , 
     person_id					INTEGER , 
     note_date					DATE ,
     note_datetime				TIMESTAMP ,
     note_type_concept_id			INTEGER ,
     note_class_concept_id			INTEGER ,
     note_title					STRING ,
     note_text					STRING ,
     encoding_concept_id			INTEGER ,
     language_concept_id			INTEGER ,
     provider_id				INTEGER ,
     visit_occurrence_id			INTEGER ,
     note_source_value				STRING ,
     visit_detail_id				INTEGER 
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



/*This table is new in CDM v5.2*/
CREATE TABLE note_nlp
(
  note_nlp_id					INTEGER	,
  note_id					INTEGER ,
  section_concept_id				INTEGER ,
  snippet					STRING ,
  "offset"					STRING ,
  lexical_variant				STRING ,
  note_nlp_concept_id				INTEGER ,
  note_nlp_source_concept_id			INTEGER ,
  nlp_system					STRING ,
  nlp_date					DATE ,
  nlp_datetime					TIMESTAMP ,
  term_exists					STRING ,
  term_temporal					STRING ,
  term_modifiers				STRING
)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


CREATE TABLE observation 
    ( 
     observation_id				INTEGER , 
     person_id					INTEGER , 
     observation_concept_id			INTEGER , 
     observation_date				DATE , 
     observation_datetime			TIMESTAMP ,
     observation_type_concept_id		INTEGER , 
     value_as_number				DECIMAL , 
     value_as_string				STRING , 
     value_as_concept_id			INTEGER , 
     qualifier_concept_id			INTEGER ,
     unit_concept_id				INTEGER , 
     provider_id				INTEGER , 
     visit_occurrence_id			INTEGER , 
     visit_detail_id				INTEGER ,
     observation_source_value			STRING ,
     observation_source_concept_id		INTEGER , 
     unit_source_value				STRING ,
     qualifier_source_value			STRING
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE fact_relationship 
    ( 
     domain_concept_id_1			INTEGER , 
     fact_id_1					INTEGER ,
     domain_concept_id_2			INTEGER ,
     fact_id_2					INTEGER ,
     relationship_concept_id			INTEGER
	)
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;




/************************

Standardized health system data

************************/



CREATE TABLE location 
    ( 
     location_id				INTEGER , 
     address_1					STRING , 
     address_2					STRING , 
     city					STRING , 
     state					STRING , 
     zip					STRING , 
     county					STRING , 
     location_source_value			STRING
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;



CREATE TABLE care_site 
    ( 
     care_site_id				INTEGER , 
     care_site_name				STRING ,
     place_of_service_concept_id		INTEGER ,
     location_id				INTEGER , 
     care_site_source_value			STRING , 
     place_of_service_source_value		STRING
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


	
CREATE TABLE provider 
    ( 
     provider_id				INTEGER ,
     provider_name				STRING , 
     NPI					STRING , 
     DEA					STRING , 
     specialty_concept_id			INTEGER , 
     care_site_id				INTEGER , 
     year_of_birth				INTEGER ,
     gender_concept_id				INTEGER ,
     provider_source_value			STRING , 
     specialty_source_value			STRING ,
     specialty_source_concept_id		INTEGER , 
     gender_source_value			STRING ,
     gender_source_concept_id			INTEGER
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;




/************************

Standardized health economics

************************/


--CREATE TABLE payer_plan_period 
--    ( 
--     payer_plan_period_id			INTEGER , 
--     person_id					INTEGER , 
--     payer_plan_period_start_date		DATE , 
--     payer_plan_period_end_date			DATE , 
--     payer_source_value				VARCHAR (50)		 , 
--     plan_source_value				VARCHAR (50)		 , 
--     family_source_value			VARCHAR (50)		 
--    ) 
--;
--
--
--
--
--CREATE TABLE cost 
--    (
--     cost_id				INTEGER  		 , 
--     cost_event_id       		INTEGER    		 ,
--     cost_domain_id      		STRING   		 ,
--     cost_type_concept_id     		INTEGER     		 ,
--     currency_concept_id		INTEGER ,
--     total_charge			DECIMAL , 
--     total_cost				DECIMAL , 
--     total_paid				DECIMAL , 
--     paid_by_payer			DECIMAL , 
--     paid_by_patient			DECIMAL , 
--     paid_patient_copay			DECIMAL , 
--     paid_patient_coinsurance		DECIMAL , 
--     paid_patient_deductible		DECIMAL , 
--     paid_by_primary			DECIMAL , 
--     paid_ingredient_cost		DECIMAL , 
--     paid_dispensing_fee		DECIMAL , 
--     payer_plan_period_id		INTEGER ,
--     amount_allowed			DECIMAL , 
--     revenue_code_concept_id		INTEGER , 
--     revenue_code_source_value   	STRING ,
--     drg_concept_id			INTEGER,
--     drg_source_value			STRING
--    ) 
--;
--




/************************

Standardized derived elements

************************/

CREATE TABLE cohort 
    ( 
     cohort_definition_id			INTEGER , 
     subject_id					INTEGER ,
     cohort_start_date				DATE , 
     cohort_end_date				DATE
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


CREATE TABLE cohort_attribute 
    ( 
     cohort_definition_id			INTEGER , 
     cohort_start_date				DATE , 
     cohort_end_date				DATE , 
     subject_id					INTEGER , 
     attribute_definition_id			INTEGER ,
     value_as_number				DECIMAL ,
     value_as_concept_id			INTEGER
    ) 
PARTITIONED by (domain_id)
CLUSTERED BY (concept_id) INTO 128 BUCKETS
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;




--CREATE TABLE drug_era 
--    ( 
--     drug_era_id				INTEGER , 
--     person_id					INTEGER , 
--     drug_concept_id				INTEGER , 
--     drug_era_start_date			DATE , 
--     drug_era_end_date				DATE , 
--     drug_exposure_count			INTEGER ,
--     gap_days					INTEGER
--    ) 
--;
--
--
--CREATE TABLE dose_era 
--    (
--     dose_era_id				INTEGER , 
--     person_id					INTEGER , 
--     drug_concept_id				INTEGER , 
--     unit_concept_id				INTEGER , 
--     dose_value					DECIMAL ,
--     dose_era_start_date			DATE , 
--     dose_era_end_date				DATE 
--    ) 
--;
--
--
--
--
--CREATE TABLE condition_era 
--    ( 
--     condition_era_id				INTEGER , 
--     person_id					INTEGER , 
--     condition_concept_id			INTEGER , 
--     condition_era_start_date			DATE , 
--     condition_era_end_date			DATE , 
--     condition_occurrence_count			INTEGER
--    ) 
--;







