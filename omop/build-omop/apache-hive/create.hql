
/************************

Standardized vocabulary

************************/


CREATE TABLE concept (
  concept_id			INT,
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
PARTITIONED by (domain_id INT)
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



CREATE TABLE vocabulary (
  vocabulary_id			STRING,
  vocabulary_name		STRING,
  vocabulary_reference		STRING,
  vocabulary_version		STRING,
  vocabulary_concept_id		INT
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
  domain_concept_id		INT
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
  concept_class_concept_id	INT
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
  concept_id_1			INT,
  concept_id_2			INT,
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
  relationship_concept_id	INT
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
  concept_id			INT,
  concept_synonym_name		STRING,
  language_concept_id		INT
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
  ancestor_concept_id		INT,
  descendant_concept_id		INT,
  min_levels_of_separation	INT,
  max_levels_of_separation	INT
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
  source_concept_id		INT,
  source_vocabulary_id		STRING,
  source_code_description	STRING,
  target_concept_id		INT,
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
  drug_concept_id		INT,
  ingredient_concept_id		INT,
  amount_value			DECIMAL,
  amount_unit_concept_id	INT,
  numerator_value		DECIMAL,
  numerator_unit_concept_id	INT,
  denominator_value		DECIMAL,
  denominator_unit_concept_id	INT,
  box_size			INT,
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
  cohort_definition_id			INT,
  cohort_definition_name		STRING,
  cohort_definition_description		STRING,
  definition_type_concept_id		INT,
  cohort_definition_syntax		STRING,
  subject_concept_id			INT,
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
  attribute_definition_id		INT,
  attribute_name			STRING,
  attribute_description			STRING,
  attribute_type_concept_id		INT,
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
     person_id					INT , 
     gender_concept_id				INT , 
     year_of_birth				INT , 
     month_of_birth				INT, 
     day_of_birth				INT, 
     birth_datetime				TIMESTAMP 	,
     race_concept_id				INT, 
     ethnicity_concept_id			INT, 
     location_id				INT, 
     provider_id				INT, 
     care_site_id				INT, 
     person_source_value			STRING, 
     gender_source_value			STRING,
     gender_source_concept_id			INT, 
     race_source_value				STRING 	, 
     race_source_concept_id			INT, 
     ethnicity_source_value			STRING 	,
     ethnicity_source_concept_id		INT
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
     observation_period_id			INT , 
     person_id					INT , 
     observation_period_start_date		DATE , 
     observation_period_start_datetime		TIMESTAMP ,
     observation_period_end_date		DATE ,
     observation_period_end_datetime		TIMESTAMP ,
	 period_type_concept_id			INT
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
         specimen_id					INT ,
	 person_id					INT ,
	 specimen_concept_id				INT ,
	 specimen_type_concept_id			INT ,
	 specimen_date					DATE ,
	 specimen_datetime				TIMESTAMP ,
	 quantity					DECIMAL ,
	 unit_concept_id				INT ,
	 anatomic_site_concept_id			INT ,
	 disease_status_concept_id			INT ,
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
     person_id						INT , 
     death_date						DATE , 
     death_datetime					TIMESTAMP ,
     death_type_concept_id				INT ,
     cause_concept_id					INT , 
     cause_source_value					STRING,
	 cause_source_concept_id			INT
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
     visit_occurrence_id			INT , 
     person_id					INT , 
     visit_concept_id				INT , 
     visit_start_date				DATE , 
     visit_start_datetime			TIMESTAMP ,
     visit_end_date				DATE ,
     visit_end_datetime				TIMESTAMP ,
     visit_type_concept_id			INT ,
     provider_id				INT,
     care_site_id				INT, 
     visit_source_value				STRING,
     visit_source_concept_id			INT ,
     admitting_source_concept_id		INT ,
     admitting_source_value			STRING ,
     discharge_to_concept_id			INT ,
     discharge_to_source_value			STRING ,
     preceding_visit_occurrence_id		INT
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
     visit_detail_id				INT , 
     person_id					INT , 
     visit_detail_concept_id			INT , 
     visit_start_date				DATE , 
     visit_start_datetime			TIMESTAMP ,
     visit_end_date				DATE ,
     visit_end_datetime				TIMESTAMP ,
     visit_type_concept_id			INT ,
     provider_id				INT,
     care_site_id				INT, 
     visit_source_value				STRING,
     visit_source_concept_id			INT ,
     admitting_source_concept_id		INT ,
     admitting_source_value			STRING ,
     discharge_to_concept_id			INT ,
     discharge_to_source_value			STRING ,
     preceding_visit_detail_id			INT ,
     visit_detail_parent_id			INT ,
     visit_occurrence_id				INT 
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
     procedure_occurrence_id		INT , 
     person_id				INT , 
     procedure_concept_id		INT , 
     procedure_date			DATE , 
     procedure_datetime			TIMESTAMP ,
     procedure_type_concept_id		INT ,
     modifier_concept_id		INT ,
     quantity				INT , 
     provider_id			INT , 
     visit_occurrence_id		INT , 
     visit_detail_id			INT ,
     procedure_source_value		STRING ,
     procedure_source_concept_id	INT ,
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
     drug_exposure_id			INT , 
     person_id				INT , 
     drug_concept_id			INT , 
     drug_exposure_start_date		DATE , 
     drug_exposure_start_datetime	TIMESTAMP ,
     drug_exposure_end_date		DATE ,
     drug_exposure_end_datetime		TIMESTAMP ,
     verbatim_end_date			DATE ,
     drug_type_concept_id		INT ,
     stop_reason			STRING , 
     refills				INT , 
     quantity				DECIMAL , 
     days_supply			INT , 
     sig				STRING , 
     route_concept_id			INT ,
     lot_number				STRING ,
     provider_id			INT , 
     visit_occurrence_id		INT , 
     visit_detail_id			INT ,
     drug_source_value			STRING ,
     drug_source_concept_id		INT ,
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
     device_exposure_id				INT , 
     person_id					INT , 
     device_concept_id				INT , 
     device_exposure_start_date			DATE , 
     device_exposure_start_datetime		TIMESTAMP ,
     device_exposure_end_date			DATE ,
     device_exposure_end_datetime		TIMESTAMP ,
     device_type_concept_id			INT ,
     unique_device_id				STRING ,
     quantity					INT ,
     provider_id				INT , 
     visit_occurrence_id			INT , 
     visit_detail_id				INT ,
     device_source_value			STRING ,
     device_source_concept_id			INT
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
     condition_occurrence_id		INT , 
     person_id				INT , 
     condition_concept_id		INT , 
     condition_start_date		DATE , 
     condition_start_datetime		TIMESTAMP ,
     condition_end_date			DATE ,
     condition_end_datetime		TIMESTAMP ,
     condition_type_concept_id		INT ,
     stop_reason			STRING , 
     provider_id			INT , 
     visit_occurrence_id		INT , 
     visit_detail_id			INT ,
     condition_source_value		STRING ,
     condition_source_concept_id	INT ,
     condition_status_source_value	STRING ,
     condition_status_concept_id	INT 
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
     measurement_id				INT , 
     person_id					INT , 
     measurement_concept_id			INT , 
     measurement_date				DATE , 
     measurement_datetime			TIMESTAMP ,
     operator_concept_id			INT , 
     value_as_number				DECIMAL , 
     value_as_concept_id			INT , 
     unit_concept_id				INT , 
     range_low					DECIMAL , 
     range_high					DECIMAL , 
     provider_id				INT , 
     visit_occurrence_id			INT ,  
     visit_detail_id		        	INT ,
     measurement_source_value			STRING , 
     measurement_source_concept_id		INT ,
     unit_source_value				STRING ,
     value_source_value				STRING
    ) 
 PARTITIONED by (measurement_type_concept_id INT)
-- CLUSTERED BY (birth_datetime) INTO 128 BUCKETS
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;



CREATE TABLE note 
    ( 
     note_id					INT , 
     person_id					INT , 
     note_date					DATE ,
     note_datetime				TIMESTAMP ,
     note_type_concept_id			INT ,
     note_class_concept_id			INT ,
     note_title					STRING ,
     note_text					STRING ,
     encoding_concept_id			INT ,
     language_concept_id			INT ,
     provider_id				INT ,
     visit_occurrence_id			INT ,
     note_source_value				STRING ,
     visit_detail_id				INT 
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
  note_nlp_id					INT	,
  note_id					INT ,
  section_concept_id				INT ,
  snippet					STRING ,
  "offset"					STRING ,
  lexical_variant				STRING ,
  note_nlp_concept_id				INT ,
  note_nlp_source_concept_id			INT ,
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
     observation_id				INT , 
     person_id					INT , 
     observation_concept_id			INT , 
     observation_date				DATE , 
     observation_datetime			TIMESTAMP ,
     observation_type_concept_id		INT , 
     value_as_number				DECIMAL , 
     value_as_string				STRING , 
     value_as_concept_id			INT , 
     qualifier_concept_id			INT ,
     unit_concept_id				INT , 
     provider_id				INT , 
     visit_occurrence_id			INT , 
     visit_detail_id				INT ,
     observation_source_value			STRING ,
     observation_source_concept_id		INT , 
     unit_source_value				STRING ,
     qualifier_source_value			STRING
    ) 
 PARTITIONED by (observation_type_concept_id INT)
-- CLUSTERED BY (birth_datetime) INTO 128 BUCKETS
 STORED AS ORC
 TBLPROPERTIES (
 'orc.compress'='SNAPPY',
 'orc.create.index'='true',
 'orc.bloom.filter.columns'='',
 'orc.bloom.filter.fpp'='0.05',
 'orc.stripe.size'='268435456',
 'orc.row.index.stride'='10000') ;



CREATE TABLE fact_relationship 
    ( 
     domain_concept_id_1			INT , 
     fact_id_1					INT ,
     domain_concept_id_2			INT ,
     fact_id_2					INT ,
     relationship_concept_id			INT
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
     location_id				INT , 
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
     care_site_id				INT , 
     care_site_name				STRING ,
     place_of_service_concept_id		INT ,
     location_id				INT , 
     care_site_source_value			STRING , 
     place_of_service_source_value		STRING
    ) 
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


	
CREATE TABLE provider ( provider_id				INT , provider_name				STRING , NPI					STRING , DEA					STRING , specialty_concept_id			INT , care_site_id				INT , year_of_birth				INT , gender_concept_id				INT , provider_source_value			STRING , specialty_source_value			STRING , specialty_source_concept_id		INT , gender_source_value			STRING , gender_source_concept_id			INT) 
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
--     payer_plan_period_id			INT , 
--     person_id					INT , 
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
--     cost_id				INT  		 , 
--     cost_event_id       		INT    		 ,
--     cost_domain_id      		STRING   		 ,
--     cost_type_concept_id     		INT     		 ,
--     currency_concept_id		INT ,
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
--     payer_plan_period_id		INT ,
--     amount_allowed			DECIMAL , 
--     revenue_code_concept_id		INT , 
--     revenue_code_source_value   	STRING ,
--     drg_concept_id			INT,
--     drg_source_value			STRING
--    ) 
--;
--




/************************

Standardized derived elements

************************/

CREATE TABLE cohort ( cohort_definition_id			INT , subject_id					INT , cohort_start_date				DATE , cohort_end_date				DATE) 
STORED AS ORC
TBLPROPERTIES ( 
'orc.compress'='SNAPPY',
'orc.create.index'='true',
'orc.bloom.filter.columns'='',
'orc.bloom.filter.fpp'='0.05',
'orc.stripe.size'='268435456',
'orc.row.index.stride'='10000')
;


CREATE TABLE cohort_attribute ( cohort_definition_id			INT , cohort_start_date				DATE , cohort_end_date				DATE , subject_id					INT , attribute_definition_id			INT , value_as_number				DECIMAL , value_as_concept_id			INT) 
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
--     drug_era_id				INT , 
--     person_id					INT , 
--     drug_concept_id				INT , 
--     drug_era_start_date			DATE , 
--     drug_era_end_date				DATE , 
--     drug_exposure_count			INT ,
--     gap_days					INT
--    ) 
--;
--
--
--CREATE TABLE dose_era 
--    (
--     dose_era_id				INT , 
--     person_id					INT , 
--     drug_concept_id				INT , 
--     unit_concept_id				INT , 
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
--     condition_era_id				INT , 
--     person_id					INT , 
--     condition_concept_id			INT , 
--     condition_era_start_date			DATE , 
--     condition_era_end_date			DATE , 
--     condition_occurrence_count			INT
--    ) 
--;





