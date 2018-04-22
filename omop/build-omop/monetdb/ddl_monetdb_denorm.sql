
DROP TABLE omop.concept ;
CREATE TABLE omop.concept (
  concept_id			INTEGER			NOT NULL,
  concept_name			TEXT  NULL,
  domain_id			TEXT  NULL,
  vocabulary_id			TEXT  NULL,
  concept_class_id		TEXT  NULL,
  standard_concept		TEXT  NULL,
  concept_code			TEXT  NULL,
  valid_start_date		DATE			NOT NULL,
  valid_end_date		DATE			NOT NULL,
  invalid_reason		TEXT  NULL
)
;




DROP TABLE omop.vocabulary ;
CREATE TABLE omop.vocabulary (
  vocabulary_id			TEXT  NULL,
  vocabulary_name		TEXT  NULL,
  vocabulary_reference		TEXT  NULL,
  vocabulary_version		TEXT  NULL,
  vocabulary_concept_id		INTEGER			NOT NULL
)
;




DROP TABLE omop.domain ;
CREATE TABLE omop.domain (
  domain_id			TEXT  NULL,
  domain_name			TEXT  NULL,
  domain_concept_id		INTEGER			NOT NULL
)
;



DROP TABLE omop.concept_class ;
CREATE TABLE omop.concept_class (
  concept_class_id		TEXT  NULL,
  concept_class_name		TEXT  NULL,
  concept_class_concept_id	INTEGER			NOT NULL
)
;




DROP TABLE omop.concept_relationship ;
CREATE TABLE omop.concept_relationship (
  concept_id_1			INTEGER			NOT NULL,
  concept_id_2			INTEGER			NOT NULL,
  relationship_id		TEXT  NULL,
  valid_start_date		DATE			NOT NULL,
  valid_end_date		DATE			NOT NULL,
  invalid_reason		TEXT  NULL)
;



DROP TABLE omop.relationship ;
CREATE TABLE omop.relationship (
  relationship_id		TEXT  NULL,
  relationship_name		TEXT  NULL,
  is_hierarchical		TEXT  NULL,
  defines_ancestry		TEXT  NULL,
  reverse_relationship_id	TEXT  NULL,
  relationship_concept_id	INTEGER			NOT NULL
)
;


DROP TABLE omop.concept_synonym ;
CREATE TABLE omop.concept_synonym (
  concept_id			INTEGER			NOT NULL,
  concept_synonym_name		TEXT  NULL,
  language_concept_id		INTEGER			NOT NULL
)
;


DROP TABLE omop.concept_ancestor ;
CREATE TABLE omop.concept_ancestor (
  ancestor_concept_id		INTEGER			NOT NULL,
  descendant_concept_id		INTEGER			NOT NULL,
  min_levels_of_separation	INTEGER			NOT NULL,
  max_levels_of_separation	INTEGER			NOT NULL
)
;



DROP TABLE omop.source_to_concept_map ;
CREATE TABLE omop.source_to_concept_map (
  source_code			TEXT  NULL,
  source_concept_id		INTEGER			NOT NULL,
  source_vocabulary_id		TEXT  NULL,
  source_code_description	TEXT  NULL,
  target_concept_id		INTEGER			NOT NULL,
  target_vocabulary_id		TEXT  NULL,
  valid_start_date		DATE			NOT NULL,
  valid_end_date		DATE			NOT NULL,
  invalid_reason		TEXT  NULL
)
;




DROP TABLE omop.drug_strength ;
CREATE TABLE omop.drug_strength (
  drug_concept_id		INTEGER		NOT NULL,
  ingredient_concept_id		INTEGER		NOT NULL,
  amount_value			DOUBLE PRECISION		NULL,
  amount_unit_concept_id	INTEGER		NULL,
  numerator_value		DOUBLE PRECISION		NULL,
  numerator_unit_concept_id	INTEGER		NULL,
  denominator_value		DOUBLE PRECISION		NULL,
  denominator_unit_concept_id	INTEGER		NULL,
  box_size			INTEGER		NULL,
  valid_start_date		DATE		NOT NULL,
  valid_end_date		DATE		NOT NULL,
  invalid_reason		TEXT  NULL
)
;



DROP TABLE omop.cohort_definition ;
CREATE TABLE omop.cohort_definition (
  cohort_definition_id			INTEGER			NOT NULL,
  cohort_definition_name		TEXT  NULL,
  cohort_definition_description		TEXT  			NULL,
  definition_type_concept_id		INTEGER			NOT NULL,
  cohort_definition_syntax		TEXT  			NULL,
  subject_concept_id			INTEGER			NOT NULL,
  cohort_initiation_date		DATE			NULL
)
;


DROP TABLE omop.attribute_definition ;
CREATE TABLE omop.attribute_definition (
  attribute_definition_id		INTEGER			NOT NULL,
  attribute_name			TEXT  NULL,
  attribute_description			TEXT  			NULL,
  attribute_type_concept_id		INTEGER			NOT NULL,
  attribute_syntax			TEXT  			NULL
)
;


/**************************

Standardized meta-data

***************************/


DROP TABLE omop.cdm_source ;
CREATE TABLE omop.cdm_source 
    (  
     cdm_source_name					TEXT  NULL,
	 cdm_source_abbreviation			TEXT  NULL,
	 cdm_holder					TEXT  NULL,
	 source_description				TEXT  			NULL,
	 source_documentation_reference			TEXT  NULL,
	 cdm_etl_reference				TEXT  NULL,
	 source_release_date				DATE			NULL,
	 cdm_release_date				DATE			NULL,
	 cdm_version					TEXT  NULL,
	 vocabulary_version				TEXT  NULL
    ) 
;







/************************

Standardized clinical data

************************/

DROP TABLE omop.PERSON;
CREATE TABLE omop.person 
    (
  person_id                    integer  NULL 
, gender_concept_id            integer  NULL 
, gender_concept_name          text     NULL 
, gender_concept_code          text     NULL 
, gender_concept_code_system   text     NULL 
, year_of_birth                integer  NULL 
, month_of_birth               integer  NULL 
, day_of_birth                 integer  NULL 
, birth_datetime               timestamp NULL 
, race_concept_id              integer  NULL 
, race_concept_name            text     NULL 
, race_concept_code            text     NULL 
, race_concept_code_system     text     NULL 
, ethnicity_concept_id         integer  NULL 
, location_id                  integer  NULL 
, provider_id                  integer  NULL 
, care_site_id                 integer  NULL 
, person_source_value          text     NULL 
, gender_source_value          text     NULL 
, gender_source_concept_id     integer  NULL 
, race_source_value            text     NULL 
, race_source_concept_id       integer  NULL 
, ethnicity_source_value       text     NULL 
, ethnicity_source_concept_id  integer  NULL 

    ) 
;





DROP TABLE omop.observation_period ;
CREATE TABLE omop.observation_period 
    ( 
     observation_period_id			INTEGER		NOT NULL , 
     person_id					INTEGER		NOT NULL , 
     observation_period_start_date		DATE		NOT NULL , 
     observation_period_start_datetime		TIMESTAMP	NOT NULL ,
     observation_period_end_date		DATE		NOT NULL ,
     observation_period_end_datetime		TIMESTAMP	NOT NULL ,
	 period_type_concept_id			INTEGER		NOT NULL
    ) 
;



DROP TABLE omop.specimen;
CREATE TABLE omop.specimen
    ( 
         specimen_id					INTEGER			NOT NULL ,
	 person_id					INTEGER			NOT NULL ,
	 specimen_concept_id				INTEGER			NOT NULL ,
	 specimen_type_concept_id			INTEGER			NOT NULL ,
	 specimen_date					DATE			NOT NULL ,
	 specimen_datetime				TIMESTAMP		NULL ,
	 quantity					DOUBLE PRECISION			NULL ,
	 unit_concept_id				INTEGER			NULL ,
	 anatomic_site_concept_id			INTEGER			NULL ,
	 disease_status_concept_id			INTEGER			NULL ,
	 specimen_source_id				TEXT  NULL,
	 specimen_source_value				TEXT  NULL,
	 unit_source_value				TEXT  NULL,
	 anatomic_site_source_value			TEXT  NULL,
	 disease_status_source_value			TEXT  NULL
	)
;



DROP TABLE omop.death ;
CREATE TABLE omop.death 
    ( 
     person_id						INTEGER			NOT NULL , 
     death_date						DATE			NOT NULL , 
     death_datetime					TIMESTAMP		NULL ,
     death_type_concept_id				INTEGER			NOT NULL ,
     cause_concept_id					INTEGER			NULL , 
     cause_source_value					TEXT  NULL,
	 cause_source_concept_id			INTEGER			NULL
    ) 
;



DROP TABLE omop.visit_occurrence ;
CREATE TABLE omop.visit_occurrence 
    ( 
  visit_occurrence_id             integer   NULL 
, person_id                       integer   NULL 
, visit_concept_id                integer   NULL 
, visit_concept_name              text      NULL 
, visit_concept_code              text      NULL 
, visit_concept_code_system       text      NULL 
, visit_start_date                date      NULL 
, visit_start_datetime            timestamp NULL 
, visit_end_date                  date      NULL 
, visit_end_datetime              timestamp NULL 
, visit_type_concept_id           integer   NULL 
, visit_type_concept_name         text      NULL 
, visit_type_concept_code         text      NULL 
, visit_type_concept_code_system  text      NULL 
, provider_id                     integer   NULL 
, care_site_id                    integer   NULL 
, care_site_code                  text      NULL 
, care_site_name                  text      NULL 
, visit_source_value              text NULL 
, visit_source_concept_id         integer   NULL 
, admitting_concept_id            integer   NULL 
, admitting_concept_name          text      NULL 
, admitting_concept_code          text      NULL 
, admitting_concept_code_system   text      NULL 
, admitting_source_value          text NULL 
, admitting_source_concept_id     integer   NULL 
, discharge_to_concept_id         integer   NULL 
, discharge_concept_name          text      NULL 
, discharge_concept_code          text      NULL 
, discharge_concept_code_system   text      NULL 
, discharge_to_source_value       text NULL 
, discharge_to_source_concept_id  integer   NULL 
, preceding_visit_occurrence_id   integer   NULL 
    ) 
;


DROP TABLE omop.visit_detail;
CREATE TABLE omop.visit_detail
    ( 
  visit_detail_id                   integer   NULL 
, person_id                         integer   NULL 
, visit_detail_concept_id           integer   NULL 
, visit_detail_concept_name         text      NULL 
, visit_detail_concept_code         text      NULL 
, visit_detail_concept_code_system  text      NULL 
, visit_start_date                  date      NULL 
, visit_start_datetime              timestamp NULL 
, visit_end_date                    date      NULL 
, visit_end_datetime                timestamp NULL 
, visit_type_concept_id             integer   NULL 
, visit_type_concept_name           text      NULL 
, visit_type_concept_code           text      NULL 
, visit_type_concept_code_system    text      NULL 
, provider_id                       integer   NULL 
, care_site_id                      integer   NULL 
, care_site_code                    text      NULL 
, care_site_name                    text      NULL 
, visit_source_value                text      NULL
, visit_source_concept_id           integer   NULL 
, admitting_concept_id              integer   NULL 
, admitting_concept_name            text      NULL 
, admitting_concept_code            text      NULL 
, admitting_concept_code_system     text      NULL 
, admitting_source_value            text      NULL
, admitting_source_concept_id       integer   NULL 
, discharge_to_concept_id           integer   NULL 
, discharge_concept_name            text      NULL 
, discharge_concept_code            text      NULL 
, discharge_concept_code_system     text      NULL 
, discharge_to_source_value         text      NULL
, discharge_to_source_concept_id    integer   NULL 
, preceding_visit_detail_id         integer   NULL 
, visit_detail_parent_id            integer   NULL 
, visit_occurrence_id               integer   NULL 
    ) 
;


DROP TABLE omop.procedure_occurrence ;
CREATE TABLE omop.procedure_occurrence 
    ( 
     procedure_occurrence_id		INTEGER			NOT NULL , 
     person_id				INTEGER			NOT NULL , 
     procedure_concept_id		INTEGER			NOT NULL , 
     procedure_date			DATE			NOT NULL , 
     procedure_datetime			TIMESTAMP		NULL ,
     procedure_type_concept_id		INTEGER			NOT NULL ,
     modifier_concept_id		INTEGER			NULL ,
     quantity				INTEGER			NULL , 
     provider_id			INTEGER			NULL , 
     visit_occurrence_id		INTEGER			NULL , 
     visit_detail_id			INTEGER			NULL ,
     procedure_source_value		TEXT  NULL,
     procedure_source_concept_id	INTEGER			NULL ,
     qualifier_source_value		TEXT  NULL
    ) 
;



DROP TABLE omop.drug_exposure ;
CREATE TABLE omop.drug_exposure 
    ( 
     drug_exposure_id			INTEGER			NOT NULL , 
     person_id				INTEGER			NOT NULL , 
     drug_concept_id			INTEGER			NULL , 
     drug_exposure_start_date		DATE			NULL , 
     drug_exposure_start_datetime	TIMESTAMP		NULL ,
     drug_exposure_end_date		DATE			NULL ,
     drug_exposure_end_datetime		TIMESTAMP		NULL ,
     verbatim_end_date			DATE			NULL ,
     drug_type_concept_id		INTEGER			NULL ,
     stop_reason			TEXT  NULL,
     refills				INTEGER			NULL , 
     quantity				DOUBLE PRECISION			NULL , 
     days_supply			INTEGER			NULL , 
     sig				TEXT  			NULL , 
     route_concept_id			INTEGER			NULL ,
     lot_number				TEXT  NULL,
     provider_id			INTEGER			NULL , 
     visit_occurrence_id		INTEGER			NULL , 
     visit_detail_id			INTEGER			NULL ,
     drug_source_value			TEXT  NULL,
     drug_source_concept_id		INTEGER			NULL ,
     route_source_value			TEXT  NULL,
     dose_unit_source_value		TEXT  NULL,
     quantity_source_value              TEXT NULL
    ) 
;

DROP TABLE omop.device_exposure ;
CREATE TABLE omop.device_exposure 
    ( 
     device_exposure_id				INTEGER			NOT NULL , 
     person_id					INTEGER			NOT NULL , 
     device_concept_id				INTEGER			NOT NULL , 
     device_exposure_start_date			DATE			NOT NULL , 
     device_exposure_start_datetime		TIMESTAMP		NULL ,
     device_exposure_end_date			DATE			NULL ,
     device_exposure_end_datetime		TIMESTAMP		NULL ,
     device_type_concept_id			INTEGER			NOT NULL ,
     unique_device_id				TEXT  NULL,
     quantity					INTEGER			NULL ,
     provider_id				INTEGER			NULL , 
     visit_occurrence_id			INTEGER			NULL , 
     visit_detail_id				INTEGER			NULL ,
     device_source_value			TEXT  NULL,
     device_source_concept_id			INTEGER			NULL
    ) 
;





DROP TABLE omop.measurement ;
CREATE TABLE omop.measurement 
    ( 
  measurement_id                   integer                    NULL 
, person_id                        integer                    NULL 
, measurement_concept_id           integer                    NULL 
, measurement_concept_name         text                       NULL 
, measurement_concept_code         text                       NULL 
, measurement_concept_code_system  text                       NULL 
, measurement_date                 date                       NULL 
, measurement_datetime             timestamp                  NULL 
, measurement_type_concept_id      integer                    NULL 
, measurement_type_concept_name    text                       NULL 
, operator_concept_id              integer                    NULL 
, operator_concept_name            text                       NULL 
, value_as_number                  double precision           NULL 
, value_as_concept_id              integer                    NULL 
, unit_concept_id                  integer                    NULL 
, unit_concept_name                text                       NULL 
, unit_concept_code                text                       NULL 
, unit_concept_code_system         text                       NULL 
, range_low                        double precision           NULL 
, range_high                       double precision           NULL 
, provider_id                      integer                    NULL 
, visit_occurrence_id              integer                    NULL 
, visit_detail_id                  integer                    NULL 
, measurement_source_value         text                       NULL 
, measurement_source_concept_id    integer                    NULL 
, unit_source_value                text                       NULL 
, value_source_value               text                       NULL 

    ) 
;



DROP TABLE omop.note ;
CREATE TABLE omop.note 
    ( 
     note_id					INTEGER			NOT NULL , 
     person_id					INTEGER			NOT NULL , 
     note_date					DATE			NOT NULL ,
     note_datetime				TIMESTAMP		NULL ,
     note_type_concept_id			INTEGER			NOT NULL ,
     note_class_concept_id			INTEGER			NOT NULL ,
     note_title					TEXT  NULL,
     note_text					TEXT  			NOT NULL ,
     encoding_concept_id			INTEGER			NOT NULL ,
     language_concept_id			INTEGER			NOT NULL ,
     provider_id				INTEGER			NULL ,
     visit_occurrence_id			INTEGER			NULL ,
     note_source_value				TEXT  NULL,
     visit_detail_id				INTEGER			NULL 
    ) 
;



/*This table is new in CDM v5.2*/
DROP TABLE omop.note_nlp;
CREATE TABLE omop.note_nlp
(
  note_nlp_id					BIGINT 			NOT NULL ,
  note_id					INTEGER			NOT NULL ,
  section_concept_id				INTEGER			NULL ,
  snippet					TEXT  NULL,
  lexical_variant				TEXT  NULL,
  note_nlp_concept_id				INTEGER			NULL ,
  note_nlp_source_concept_id			INTEGER			NULL ,
  nlp_system					TEXT  NULL,
  nlp_date					DATE			NOT NULL ,
  nlp_datetime					TIMESTAMP		NULL ,
  term_exists					TEXT  NULL,
  term_temporal					TEXT  NULL,
  term_modifiers				TEXT  NULL,
  offset_begin INTEGER			NULL ,
  offset_end INTEGER			NULL ,
  section_source_value TEXT  NULL,
  section_source_concept_id INTEGER			NULL
)
;



DROP TABLE omop.observation ;
CREATE TABLE omop.observation 
    ( 
     observation_id				INTEGER			NOT NULL , 
     person_id					INTEGER			NOT NULL , 
     observation_concept_id			INTEGER			NOT NULL , 
     observation_date				DATE			NOT NULL , 
     observation_datetime			TIMESTAMP		NULL ,
     observation_type_concept_id		INTEGER			NOT NULL , 
     value_as_number				DOUBLE PRECISION			NULL , 
     value_as_string				TEXT  NULL,
     value_as_concept_id			INTEGER			NULL , 
     qualifier_concept_id			INTEGER			NULL ,
     unit_concept_id				INTEGER			NULL , 
     provider_id				INTEGER			NULL , 
     visit_occurrence_id			INTEGER			NULL , 
     visit_detail_id				INTEGER			NULL ,
     observation_source_value			TEXT  NULL,
     observation_source_concept_id		INTEGER			NULL , 
     unit_source_value				TEXT  NULL,
     qualifier_source_value			TEXT  NULL
    ) 
;



DROP TABLE omop.fact_relationship ;
CREATE TABLE omop.fact_relationship 
    ( 
     domain_concept_id_1			INTEGER			NOT NULL , 
     fact_id_1					INTEGER			NOT NULL ,
     domain_concept_id_2			INTEGER			NOT NULL ,
     fact_id_2					INTEGER			NOT NULL ,
     relationship_concept_id			INTEGER			NOT NULL
	)
;




/************************

Standardized health system data

************************/



DROP TABLE omop.location ;
CREATE TABLE omop.location 
    ( 
     location_id				INTEGER			NOT NULL , 
     address_1					TEXT  NULL,
     address_2					TEXT  NULL,
     city					TEXT  NULL,
     state					TEXT  NULL,
     zip					TEXT  NULL,
     county					TEXT  NULL,
     location_source_value			TEXT  NULL
    ) 
;



DROP TABLE omop.care_site ;
CREATE TABLE omop.care_site 
    ( 
  care_site_id                          integer NULL 
, care_site_name                        text    NULL 
, place_of_service_concept_id           integer NULL 
, place_of_service_concept_name         text    NULL 
, place_of_service_concept_code         text    NULL 
, place_of_service_concept_code_system  text    NULL 
, location_id                           integer NULL 
, care_site_source_value                text    NULL 
, place_of_service_source_value         text    NULL 
    ) 
;


	
DROP TABLE omop.provider ;
CREATE TABLE omop.provider 
    ( 
     provider_id				INTEGER			NOT NULL ,
     provider_name				TEXT  NULL,
     NPI					TEXT  NULL,
     DEA					TEXT  NULL,
     specialty_concept_id			INTEGER			NULL , 
     care_site_id				INTEGER			NULL , 
     year_of_birth				INTEGER			NULL ,
     gender_concept_id				INTEGER			NULL ,
     provider_source_value			TEXT  NULL,
     specialty_source_value			TEXT  NULL,
     specialty_source_concept_id		INTEGER			NULL , 
     gender_source_value			TEXT  NULL,
     gender_source_concept_id			INTEGER			NULL
    ) 
;




/************************

Standardized health economics

************************/


DROP TABLE omop.payer_plan_period ;
CREATE TABLE omop.payer_plan_period 
    ( 
     payer_plan_period_id			INTEGER			NOT NULL , 
     person_id					INTEGER			NOT NULL , 
     payer_plan_period_start_date		DATE			NOT NULL , 
     payer_plan_period_end_date			DATE			NOT NULL , 
     payer_source_value				TEXT  NULL,
     plan_source_value				TEXT  NULL,
     family_source_value			TEXT  NULL
    ) 
;




DROP TABLE omop.cost ;
CREATE TABLE omop.cost 
    (
     cost_id				INTEGER	  		NOT NULL , 
     cost_event_id       		INTEGER    		NOT NULL ,
     cost_domain_id      		TEXT  NULL,
     cost_type_concept_id     		INTEGER     		NOT NULL ,
     currency_concept_id		INTEGER			NULL ,
     total_charge			DOUBLE PRECISION			NULL , 
     total_cost				DOUBLE PRECISION			NULL , 
     total_paid				DOUBLE PRECISION			NULL , 
     paid_by_payer			DOUBLE PRECISION			NULL , 
     paid_by_patient			DOUBLE PRECISION			NULL , 
     paid_patient_copay			DOUBLE PRECISION			NULL , 
     paid_patient_coinsurance		DOUBLE PRECISION			NULL , 
     paid_patient_deductible		DOUBLE PRECISION			NULL , 
     paid_by_primary			DOUBLE PRECISION			NULL , 
     paid_ingredient_cost		DOUBLE PRECISION			NULL , 
     paid_dispensing_fee		DOUBLE PRECISION			NULL , 
     payer_plan_period_id		INTEGER			NULL ,
     amount_allowed			DOUBLE PRECISION			NULL , 
     revenue_code_concept_id		INTEGER			NULL , 
     revenue_code_source_value   	TEXT  NULL,
     drg_concept_id			INTEGER			NULL,
     drg_source_value			TEXT  NULL
    ) 
;





/************************

Standardized derived elements

************************/

DROP TABLE omop.cohort ;
CREATE TABLE omop.cohort 
    ( 
     cohort_definition_id			INTEGER			NOT NULL , 
     subject_id					INTEGER			NOT NULL ,
     cohort_start_date				DATE			NOT NULL , 
     cohort_end_date				DATE			NOT NULL
    ) 
;


DROP TABLE omop.cohort_attribute ;
CREATE TABLE omop.cohort_attribute 
    ( 
     cohort_definition_id			INTEGER			NOT NULL , 
     cohort_start_date				DATE			NOT NULL , 
     cohort_end_date				DATE			NOT NULL , 
     subject_id					INTEGER			NOT NULL , 
     attribute_definition_id			INTEGER			NOT NULL ,
     value_as_number				DOUBLE PRECISION			NULL ,
     value_as_concept_id			INTEGER			NULL
    ) 
;




DROP TABLE omop.drug_era ;
CREATE TABLE omop.drug_era 
    ( 
     drug_era_id				INTEGER			NOT NULL , 
     person_id					INTEGER			NOT NULL , 
     drug_concept_id				INTEGER			NOT NULL , 
     drug_era_start_date			DATE			NOT NULL , 
     drug_era_end_date				DATE			NOT NULL , 
     drug_exposure_count			INTEGER			NULL ,
     gap_days					INTEGER			NULL
    ) 
;


DROP TABLE omop.dose_era ;
CREATE TABLE omop.dose_era 
    (
     dose_era_id				INTEGER			NOT NULL , 
     person_id					INTEGER			NOT NULL , 
     drug_concept_id				INTEGER			NOT NULL , 
     unit_concept_id				INTEGER			NOT NULL , 
     dose_value					DOUBLE PRECISION			NOT NULL ,
     dose_era_start_date			DATE			NULL , 
     dose_era_end_date				DATE			NULL 
    ) 
;




DROP TABLE omop.condition_era ;
CREATE TABLE omop.condition_era 
    ( 
     condition_era_id				INTEGER			NOT NULL , 
     person_id					INTEGER			NOT NULL , 
     condition_concept_id			INTEGER			NOT NULL , 
     condition_era_start_date			DATE			NOT NULL , 
     condition_era_end_date			DATE			NOT NULL , 
     condition_occurrence_count			INTEGER			NULL
    ) 
;







DROP TABLE omop.condition_occurrence ;
CREATE TABLE omop.condition_occurrence 
    ( 
  condition_occurrence_id             integer   NULL 
, person_id                           integer   NULL 
, condition_concept_id                integer   NULL 
, condition_concept_name              text      NULL 
, condition_concept_code              text      NULL 
, condition_concept_code_system       text      NULL 
, condition_start_date                date      NULL 
, condition_start_datetime            timestamp NULL 
, condition_end_date                  date      NULL 
, condition_end_datetime              timestamp NULL 
, condition_type_concept_id           integer   NULL 
, condition_type_concept_name         text      NULL 
, condition_type_concept_code         text      NULL 
, condition_type_concept_code_system  text      NULL 
, stop_reason                         text      NULL 
, provider_id                         integer   NULL 
, visit_occurrence_id                 integer   NULL 
, visit_detail_id                     integer   NULL 
, condition_source_value              text      NULL 
, condition_source_concept_id         integer   NULL 
, condition_source_concept_name       text      NULL 
, condition_status_source_value       text      NULL 
, condition_status_concept_id         integer   NULL 
, condition_status_concept_name       text      NULL 

    ) 
;

