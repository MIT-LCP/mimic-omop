-- Modify some of the tables: rearranging and adding columns
-- These changes will likely be incorporated into a future version of OMOP CDM

ALTER TABLE observation_period ADD COLUMN "observation_period_start_datetime" TIMESTAMP NOT NULL ;
ALTER TABLE observation_period ADD COLUMN "observation_period_end_datetime" TIMESTAMP NOT NULL ;


ALTER TABLE visit_occurrence ADD COLUMN "admitting_concept_id" INTEGER NULL ;
ALTER TABLE visit_occurrence ADD COLUMN "discharge_to_source_concept_id" INTEGER NULL ;

ALTER TABLE visit_detail ADD COLUMN "visit_detail_source_value" VARCHAR(50) NULL ;
ALTER TABLE visit_detail ADD COLUMN "visit_detail_source_concept_id" INTEGER NULL ;
ALTER TABLE visit_detail ADD COLUMN "admitting_concept_id" INTEGER NULL ;
ALTER TABLE visit_detail ADD COLUMN "discharge_to_source_concept_id" INTEGER NULL;


-- those are usefull
ALTER TABLE dose_era ADD COLUMN temporal_unit_concept_id integer;
COMMENT ON COLUMN dose_era.temporal_unit_concept_id  IS 'Stores temporal unit, daily, hourly ...';

ALTER TABLE dose_era ADD COLUMN temporal_value numeric;
COMMENT ON COLUMN dose_era.temporal_value IS 'Stores temporal value';

ALTER TABLE drug_exposure ADD COLUMN quantity_source_value text ;
COMMENT ON COLUMN drug_exposure.quantity_source_value IS 'Stores the source quantity value';

-- Below are columns we are considering adding

--ALTER TABLE death ADD COLUMN visit_detail_id BIGINT;
--COMMENT ON COLUMN death.visit_detail_id             IS '[CONTRIB] A foreign key to the visit in the VISIT_DETAIL table during where the death occured';

--ALTER TABLE death ADD COLUMN visit_occurrence_id BIGINT;
--COMMENT ON COLUMN death.visit_occurrence_id             IS '[CONTRIB] A foreign key to the visit in the VISIT_OCCURRENCE table during where the death occured';
--
--ALTER TABLE death ADD COLUMN death_visit_detail_delay double precision;
--COMMENT ON COLUMN death.death_visit_detail_delay             IS '[CONTRIB] Difference between deathtime and visit_start_datetime of VISIT_DETAIL table';
--
--ALTER TABLE death ADD COLUMN death_visit_occurrence_delay double precision;
--COMMENT ON COLUMN death.death_visit_occurrence_delay      IS '[CONTRIB] Difference between deathtime and visit_start_datetime of VISIT_OCCURRENCE table';
--
--ALTER TABLE measurement ADD COLUMN quality_concept_id bigint;
--COMMENT ON COLUMN measurement.quality_concept_id             IS '[CONTRIB] Quality mask, can be queried with regex, to filter based on quality aspects';
--
--ALTER TABLE visit_occurrence ADD COLUMN age_in_year integer;
--COMMENT ON COLUMN visit_occurrence.age_in_year             IS '[CONTRIB] Age at visit';
--
--ALTER TABLE visit_occurrence ADD COLUMN age_in_month integer;
--COMMENT ON COLUMN visit_occurrence.age_in_month             IS '[CONTRIB] Age at visit';
--
--ALTER TABLE visit_occurrence ADD COLUMN age_in_day integer;
--COMMENT ON COLUMN visit_occurrence.age_in_day IS '[CONTRIB] Age at visit';
--
--ALTER TABLE visit_occurrence ADD COLUMN visit_occurrence_length double precision;
--COMMENT ON COLUMN visit_occurrence.visit_occurrence_length IS '[CONTRIB] Length of visit occurrence';
--
--ALTER TABLE visit_detail ADD COLUMN visit_detail_length double precision;
--COMMENT ON COLUMN visit_detail.visit_detail_length IS '[CONTRIB] Length of visit detail';
--
--ALTER TABLE visit_detail ADD COLUMN discharge_delay double precision;
--COMMENT ON COLUMN visit_detail.discharge_delay IS '[CONTRIB] Delay between discharge decision and effective discharge';


-- there is actually no need to limit the character size in postgres.
-- limiting them is error prone and does not improve any performances or etl security
-- the OMOP spec says it is possible to alter the text length

-- SELECT
--     'ALTER TABLE '||columns.table_name||' ALTER COLUMN   '||columns.column_name||' TYPE text;'
--  FROM
--     information_schema.columns
--  WHERE
--    columns.table_catalog = 'mimic' AND
--    columns.table_schema = 'omop' AND
--    columns.data_type ilike 'character%';
 ALTER TABLE attribute_definition ALTER COLUMN   attribute_name TYPE text;
 ALTER TABLE cdm_source ALTER COLUMN   cdm_source_name TYPE text;
 ALTER TABLE cdm_source ALTER COLUMN   cdm_source_abbreviation TYPE text;
 ALTER TABLE cdm_source ALTER COLUMN   cdm_holder TYPE text;
 ALTER TABLE cdm_source ALTER COLUMN   source_documentation_reference TYPE text;
 ALTER TABLE cdm_source ALTER COLUMN   cdm_etl_reference TYPE text;
 ALTER TABLE cdm_source ALTER COLUMN   cdm_version TYPE text;
 ALTER TABLE cdm_source ALTER COLUMN   vocabulary_version TYPE text;
 ALTER TABLE vocabulary ALTER COLUMN   vocabulary_id TYPE text;
 ALTER TABLE vocabulary ALTER COLUMN   vocabulary_name TYPE text;
 ALTER TABLE vocabulary ALTER COLUMN   vocabulary_reference TYPE text;
 ALTER TABLE vocabulary ALTER COLUMN   vocabulary_version TYPE text;
 ALTER TABLE note_nlp ALTER COLUMN   snippet TYPE text;
-- ALTER TABLE note_nlp ALTER COLUMN   offset TYPE text;
 ALTER TABLE note_nlp ALTER COLUMN   lexical_variant TYPE text;
 ALTER TABLE note_nlp ALTER COLUMN   nlp_system TYPE text;
 ALTER TABLE note_nlp ALTER COLUMN   term_exists TYPE text;
 ALTER TABLE note_nlp ALTER COLUMN   term_temporal TYPE text;
 ALTER TABLE note_nlp ALTER COLUMN   term_modifiers TYPE text;
 ALTER TABLE person ALTER COLUMN   person_source_value TYPE text;
 ALTER TABLE person ALTER COLUMN   gender_source_value TYPE text;
 ALTER TABLE person ALTER COLUMN   race_source_value TYPE text;
 ALTER TABLE person ALTER COLUMN   ethnicity_source_value TYPE text;
 ALTER TABLE payer_plan_period ALTER COLUMN   payer_source_value TYPE text;
 ALTER TABLE payer_plan_period ALTER COLUMN   plan_source_value TYPE text;
 ALTER TABLE payer_plan_period ALTER COLUMN   family_source_value TYPE text;
 ALTER TABLE domain ALTER COLUMN   domain_id TYPE text;
 ALTER TABLE domain ALTER COLUMN   domain_name TYPE text;
 ALTER TABLE concept_relationship ALTER COLUMN   relationship_id TYPE text;
 ALTER TABLE concept_relationship ALTER COLUMN   invalid_reason TYPE text;
 ALTER TABLE relationship ALTER COLUMN   relationship_id TYPE text;
 ALTER TABLE relationship ALTER COLUMN   relationship_name TYPE text;
 ALTER TABLE relationship ALTER COLUMN   is_hierarchical TYPE text;
 ALTER TABLE relationship ALTER COLUMN   defines_ancestry TYPE text;
 ALTER TABLE relationship ALTER COLUMN   reverse_relationship_id TYPE text;
 ALTER TABLE concept_synonym ALTER COLUMN   concept_synonym_name TYPE text;
 ALTER TABLE drug_strength ALTER COLUMN   invalid_reason TYPE text;
 ALTER TABLE location ALTER COLUMN   address_1 TYPE text;
 ALTER TABLE location ALTER COLUMN   address_2 TYPE text;
 ALTER TABLE location ALTER COLUMN   city TYPE text;
 ALTER TABLE location ALTER COLUMN   state TYPE text;
 ALTER TABLE location ALTER COLUMN   zip TYPE text;
 ALTER TABLE location ALTER COLUMN   county TYPE text;
 ALTER TABLE location ALTER COLUMN   location_source_value TYPE text;
 ALTER TABLE cohort_definition ALTER COLUMN   cohort_definition_name TYPE text;
ALTER TABLE specimen ALTER COLUMN   specimen_source_id TYPE text;
 ALTER TABLE specimen ALTER COLUMN   specimen_source_value TYPE text;
 ALTER TABLE specimen ALTER COLUMN   unit_source_value TYPE text;
 ALTER TABLE specimen ALTER COLUMN   anatomic_site_source_value TYPE text;
 ALTER TABLE specimen ALTER COLUMN   disease_status_source_value TYPE text;
 ALTER TABLE death ALTER COLUMN   cause_source_value TYPE text;
 ALTER TABLE visit_detail ALTER COLUMN   visit_source_value TYPE text;
 ALTER TABLE visit_detail ALTER COLUMN   admitting_source_value TYPE text;
 ALTER TABLE visit_detail ALTER COLUMN   discharge_to_source_value TYPE text;
 ALTER TABLE procedure_occurrence ALTER COLUMN   procedure_source_value TYPE text;
 ALTER TABLE procedure_occurrence ALTER COLUMN   modifier_source_value TYPE text;
 ALTER TABLE drug_exposure ALTER COLUMN   stop_reason TYPE text;
 ALTER TABLE drug_exposure ALTER COLUMN   lot_number TYPE text;
 ALTER TABLE drug_exposure ALTER COLUMN   drug_source_value TYPE text;
 ALTER TABLE drug_exposure ALTER COLUMN   route_source_value TYPE text;
 ALTER TABLE drug_exposure ALTER COLUMN   dose_unit_source_value TYPE text;
 ALTER TABLE condition_occurrence ALTER COLUMN   stop_reason TYPE text;
 ALTER TABLE condition_occurrence ALTER COLUMN   condition_source_value TYPE text;
 ALTER TABLE condition_occurrence ALTER COLUMN   condition_status_source_value TYPE text;
 ALTER TABLE note ALTER COLUMN   note_title TYPE text;
 ALTER TABLE note ALTER COLUMN   note_source_value TYPE text;
 ALTER TABLE care_site ALTER COLUMN   care_site_name TYPE text;
 ALTER TABLE care_site ALTER COLUMN   care_site_source_value TYPE text;
 ALTER TABLE care_site ALTER COLUMN   place_of_service_source_value TYPE text;
 ALTER TABLE provider ALTER COLUMN   provider_name TYPE text;
 ALTER TABLE provider ALTER COLUMN   npi TYPE text;
 ALTER TABLE provider ALTER COLUMN   dea TYPE text;
 ALTER TABLE provider ALTER COLUMN   provider_source_value TYPE text;
 ALTER TABLE provider ALTER COLUMN   specialty_source_value TYPE text;
 ALTER TABLE provider ALTER COLUMN   gender_source_value TYPE text;
 ALTER TABLE observation ALTER COLUMN   value_as_string TYPE text;
 ALTER TABLE observation ALTER COLUMN   observation_source_value TYPE text;
 ALTER TABLE observation ALTER COLUMN   unit_source_value TYPE text;
 ALTER TABLE observation ALTER COLUMN   qualifier_source_value TYPE text;
 ALTER TABLE source_to_concept_map ALTER COLUMN   source_code TYPE text;
 ALTER TABLE source_to_concept_map ALTER COLUMN   source_vocabulary_id TYPE text;
 ALTER TABLE source_to_concept_map ALTER COLUMN   source_code_description TYPE text;
 ALTER TABLE source_to_concept_map ALTER COLUMN   target_vocabulary_id TYPE text;
 ALTER TABLE source_to_concept_map ALTER COLUMN   invalid_reason TYPE text;
 ALTER TABLE concept_class ALTER COLUMN   concept_class_id TYPE text;
 ALTER TABLE concept_class ALTER COLUMN   concept_class_name TYPE text;
 ALTER TABLE cost ALTER COLUMN   cost_domain_id TYPE text;
 ALTER TABLE cost ALTER COLUMN   revenue_code_source_value TYPE text;
 ALTER TABLE cost ALTER COLUMN   drg_source_value TYPE text;
 ALTER TABLE device_exposure ALTER COLUMN   unique_device_id TYPE text;
 ALTER TABLE device_exposure ALTER COLUMN   device_source_value TYPE text;
 ALTER TABLE measurement ALTER COLUMN  measurement_source_value TYPE text;
 ALTER TABLE measurement ALTER COLUMN   unit_source_value TYPE text;
 ALTER TABLE measurement ALTER COLUMN   value_source_value TYPE text;
 ALTER TABLE visit_occurrence ALTER COLUMN   visit_source_value TYPE text;
 ALTER TABLE visit_occurrence ALTER COLUMN   admitting_source_value TYPE text;
 ALTER TABLE visit_occurrence ALTER COLUMN   discharge_to_source_value TYPE text;

 ALTER TABLE concept ALTER COLUMN   concept_name TYPE text;
 ALTER TABLE concept ALTER COLUMN   domain_id TYPE text;
 ALTER TABLE concept ALTER COLUMN   vocabulary_id TYPE text;
 ALTER TABLE concept ALTER COLUMN   concept_class_id TYPE text;
 ALTER TABLE concept ALTER COLUMN   standard_concept TYPE text;
 ALTER TABLE concept ALTER COLUMN   concept_code TYPE text;
 ALTER TABLE concept ALTER COLUMN   invalid_reason TYPE text;

-- mimic does not provide some dates for drugs.
-- this allows populating them
ALTER TABLE drug_exposure ALTER COLUMN drug_exposure_start_date DROP NOT NULL;
ALTER TABLE drug_exposure ALTER COLUMN drug_exposure_end_date DROP NOT NULL;
ALTER TABLE dose_era ALTER COLUMN dose_era_start_date DROP NOT NULL;
ALTER TABLE dose_era ALTER COLUMN dose_era_end_date DROP NOT NULL;



-- NOTE NLP table looks like missing columns
-- cf http://forums.ohdsi.org/t/note-nlp-questions/3379/4
ALTER TABLE note_nlp DROP COLUMN "offset" ;
ALTER TABLE note_nlp ADD COLUMN "offset_begin" integer ;
ALTER TABLE note_nlp ADD COLUMN "offset_end" integer ;
ALTER TABLE note_nlp ADD COLUMN "section_source_value" text ;
ALTER TABLE note_nlp ADD COLUMN "section_source_concept_id" integer ;


-- bigint is a better choice for future and international database merging challenges

--  SELECT
--    'ALTER TABLE '||columns.table_name||' ALTER COLUMN   '||columns.column_name||' TYPE bigint;'
-- FROM
--    information_schema.columns
-- WHERE
--   columns.table_catalog = 'mimic' AND
--   columns.table_schema = 'omop' AND
--   columns.data_type = 'integer';
-- ALTER TABLE concept_class ALTER COLUMN   concept_class_concept_id TYPE bigint;
-- ALTER TABLE source_to_concept_map ALTER COLUMN   source_concept_id TYPE bigint;
-- ALTER TABLE source_to_concept_map ALTER COLUMN   target_concept_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   measurement_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   measurement_concept_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   measurement_type_concept_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   operator_concept_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   value_as_concept_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   unit_concept_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   visit_occurrence_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   visit_detail_id TYPE bigint;
-- ALTER TABLE measurement ALTER COLUMN   measurement_source_concept_id TYPE bigint;
-- ALTER TABLE device_exposure ALTER COLUMN   device_exposure_id TYPE bigint;
-- ALTER TABLE device_exposure ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE device_exposure ALTER COLUMN   device_concept_id TYPE bigint;
-- ALTER TABLE device_exposure ALTER COLUMN   device_type_concept_id TYPE bigint;
-- ALTER TABLE device_exposure ALTER COLUMN   quantity TYPE bigint;
-- ALTER TABLE device_exposure ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE device_exposure ALTER COLUMN   visit_occurrence_id TYPE bigint;
-- ALTER TABLE device_exposure ALTER COLUMN   visit_detail_id TYPE bigint;
-- ALTER TABLE device_exposure ALTER COLUMN   device_source_concept_id TYPE bigint;
-- ALTER TABLE vocabulary ALTER COLUMN   vocabulary_concept_id TYPE bigint;
-- ALTER TABLE visit_occurrence ALTER COLUMN   visit_occurrence_id TYPE bigint;
-- ALTER TABLE visit_occurrence ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE visit_occurrence ALTER COLUMN   visit_concept_id TYPE bigint;
-- ALTER TABLE visit_occurrence ALTER COLUMN   visit_type_concept_id TYPE bigint;
-- ALTER TABLE visit_occurrence ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE visit_occurrence ALTER COLUMN   care_site_id TYPE bigint;
-- ALTER TABLE visit_occurrence ALTER COLUMN   visit_source_concept_id TYPE bigint;
-- ALTER TABLE visit_occurrence ALTER COLUMN   admitting_concept_id TYPE bigint;
-- ALTER TABLE visit_occurrence ALTER COLUMN   discharge_to_concept_id TYPE bigint;
-- ALTER TABLE visit_occurrence ALTER COLUMN   preceding_visit_occurrence_id TYPE bigint;
-- ALTER TABLE attribute_definition ALTER COLUMN   attribute_definition_id TYPE bigint;
-- ALTER TABLE attribute_definition ALTER COLUMN   attribute_type_concept_id TYPE bigint;
-- ALTER TABLE note_nlp ALTER COLUMN   note_id TYPE bigint;
-- ALTER TABLE note_nlp ALTER COLUMN   section_concept_id TYPE bigint;
-- ALTER TABLE note_nlp ALTER COLUMN   note_nlp_concept_id TYPE bigint;
-- ALTER TABLE note_nlp ALTER COLUMN   note_nlp_source_concept_id TYPE bigint;
-- ALTER TABLE dose_era ALTER COLUMN   dose_era_id TYPE bigint;
-- ALTER TABLE dose_era ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE dose_era ALTER COLUMN   drug_concept_id TYPE bigint;
-- ALTER TABLE dose_era ALTER COLUMN   unit_concept_id TYPE bigint;
-- ALTER TABLE concept ALTER COLUMN   concept_id TYPE bigint;
-- ALTER TABLE concept_relationship ALTER COLUMN   concept_id_1 TYPE bigint;
-- ALTER TABLE concept_relationship ALTER COLUMN   concept_id_2 TYPE bigint;
-- ALTER TABLE domain ALTER COLUMN   domain_concept_id TYPE bigint;
-- ALTER TABLE cohort ALTER COLUMN   cohort_definition_id TYPE bigint;
-- ALTER TABLE cohort ALTER COLUMN   subject_id TYPE bigint;
-- ALTER TABLE cohort_attribute ALTER COLUMN   cohort_definition_id TYPE bigint;
-- ALTER TABLE cohort_attribute ALTER COLUMN   subject_id TYPE bigint;
-- ALTER TABLE cohort_attribute ALTER COLUMN   attribute_definition_id TYPE bigint;
-- ALTER TABLE cohort_attribute ALTER COLUMN   value_as_concept_id TYPE bigint;
-- ALTER TABLE fact_relationship ALTER COLUMN   domain_concept_id_1 TYPE bigint;
-- ALTER TABLE fact_relationship ALTER COLUMN   fact_id_1 TYPE bigint;
-- ALTER TABLE fact_relationship ALTER COLUMN   domain_concept_id_2 TYPE bigint;
-- ALTER TABLE fact_relationship ALTER COLUMN   fact_id_2 TYPE bigint;
-- ALTER TABLE fact_relationship ALTER COLUMN   relationship_concept_id TYPE bigint;
-- ALTER TABLE drug_era ALTER COLUMN   drug_era_id TYPE bigint;
-- ALTER TABLE drug_era ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE drug_era ALTER COLUMN   drug_concept_id TYPE bigint;
-- ALTER TABLE drug_era ALTER COLUMN   drug_exposure_count TYPE bigint;
-- ALTER TABLE drug_era ALTER COLUMN   gap_days TYPE bigint;
-- ALTER TABLE relationship ALTER COLUMN   relationship_concept_id TYPE bigint;
-- ALTER TABLE concept_synonym ALTER COLUMN   concept_id TYPE bigint;
-- ALTER TABLE concept_synonym ALTER COLUMN   language_concept_id TYPE bigint;
-- ALTER TABLE cost ALTER COLUMN   cost_id TYPE bigint;
-- ALTER TABLE cost ALTER COLUMN   cost_event_id TYPE bigint;
-- ALTER TABLE cost ALTER COLUMN   cost_type_concept_id TYPE bigint;
-- ALTER TABLE cost ALTER COLUMN   currency_concept_id TYPE bigint;
-- ALTER TABLE cost ALTER COLUMN   payer_plan_period_id TYPE bigint;
-- ALTER TABLE cost ALTER COLUMN   revenue_code_concept_id TYPE bigint;
-- ALTER TABLE cost ALTER COLUMN   drg_concept_id TYPE bigint;
-- ALTER TABLE concept_ancestor ALTER COLUMN   ancestor_concept_id TYPE bigint;
-- ALTER TABLE concept_ancestor ALTER COLUMN   descendant_concept_id TYPE bigint;
-- ALTER TABLE concept_ancestor ALTER COLUMN   min_levels_of_separation TYPE bigint;
-- ALTER TABLE concept_ancestor ALTER COLUMN   max_levels_of_separation TYPE bigint;
-- ALTER TABLE death ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE death ALTER COLUMN   death_type_concept_id TYPE bigint;
-- ALTER TABLE death ALTER COLUMN   cause_concept_id TYPE bigint;
-- ALTER TABLE death ALTER COLUMN   cause_source_concept_id TYPE bigint;
-- ALTER TABLE drug_strength ALTER COLUMN   drug_concept_id TYPE bigint;
-- ALTER TABLE drug_strength ALTER COLUMN   ingredient_concept_id TYPE bigint;
-- ALTER TABLE drug_strength ALTER COLUMN   amount_unit_concept_id TYPE bigint;
-- ALTER TABLE drug_strength ALTER COLUMN   numerator_unit_concept_id TYPE bigint;
-- ALTER TABLE drug_strength ALTER COLUMN   denominator_unit_concept_id TYPE bigint;
-- ALTER TABLE drug_strength ALTER COLUMN   box_size TYPE bigint;
-- ALTER TABLE specimen ALTER COLUMN   specimen_id TYPE bigint;
-- ALTER TABLE specimen ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE specimen ALTER COLUMN   specimen_concept_id TYPE bigint;
-- ALTER TABLE specimen ALTER COLUMN   specimen_type_concept_id TYPE bigint;
-- ALTER TABLE specimen ALTER COLUMN   unit_concept_id TYPE bigint;
-- ALTER TABLE specimen ALTER COLUMN   anatomic_site_concept_id TYPE bigint;
-- ALTER TABLE specimen ALTER COLUMN   disease_status_concept_id TYPE bigint;
-- ALTER TABLE condition_occurrence ALTER COLUMN   condition_occurrence_id TYPE bigint;
-- ALTER TABLE condition_occurrence ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE condition_occurrence ALTER COLUMN   condition_concept_id TYPE bigint;
-- ALTER TABLE condition_occurrence ALTER COLUMN   condition_type_concept_id TYPE bigint;
-- ALTER TABLE condition_occurrence ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE condition_occurrence ALTER COLUMN   visit_occurrence_id TYPE bigint;
-- ALTER TABLE condition_occurrence ALTER COLUMN   visit_detail_id TYPE bigint;
-- ALTER TABLE condition_occurrence ALTER COLUMN   condition_source_concept_id TYPE bigint;
-- ALTER TABLE condition_occurrence ALTER COLUMN   condition_status_concept_id TYPE bigint;
-- ALTER TABLE observation_period ALTER COLUMN   observation_period_id TYPE bigint;
-- ALTER TABLE observation_period ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE observation_period ALTER COLUMN   period_type_concept_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   visit_detail_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   visit_detail_concept_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   visit_type_concept_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   care_site_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   visit_source_concept_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   admitting_concept_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   discharge_to_concept_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   preceding_visit_detail_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   visit_detail_parent_id TYPE bigint;
-- ALTER TABLE visit_detail ALTER COLUMN   visit_occurrence_id TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   drug_exposure_id TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   drug_concept_id TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   drug_type_concept_id TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   refills TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   days_supply TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   route_concept_id TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   visit_occurrence_id TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   visit_detail_id TYPE bigint;
-- ALTER TABLE drug_exposure ALTER COLUMN   drug_source_concept_id TYPE bigint;
-- ALTER TABLE note ALTER COLUMN   note_id TYPE bigint;
-- ALTER TABLE note ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE note ALTER COLUMN   note_type_concept_id TYPE bigint;
-- ALTER TABLE note ALTER COLUMN   note_class_concept_id TYPE bigint;
-- ALTER TABLE note ALTER COLUMN   encoding_concept_id TYPE bigint;
-- ALTER TABLE note ALTER COLUMN   language_concept_id TYPE bigint;
-- ALTER TABLE note ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE note ALTER COLUMN   visit_occurrence_id TYPE bigint;
-- ALTER TABLE note ALTER COLUMN   visit_detail_id TYPE bigint;
-- ALTER TABLE location ALTER COLUMN   location_id TYPE bigint;
-- ALTER TABLE cohort_definition ALTER COLUMN   cohort_definition_id TYPE bigint;
-- ALTER TABLE cohort_definition ALTER COLUMN   definition_type_concept_id TYPE bigint;
-- ALTER TABLE cohort_definition ALTER COLUMN   subject_concept_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   observation_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   observation_concept_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   observation_type_concept_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   value_as_concept_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   qualifier_concept_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   unit_concept_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   visit_occurrence_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   visit_detail_id TYPE bigint;
-- ALTER TABLE observation ALTER COLUMN   observation_source_concept_id TYPE bigint;
-- ALTER TABLE provider ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE provider ALTER COLUMN   specialty_concept_id TYPE bigint;
-- ALTER TABLE provider ALTER COLUMN   care_site_id TYPE bigint;
-- ALTER TABLE provider ALTER COLUMN   year_of_birth TYPE bigint;
-- ALTER TABLE provider ALTER COLUMN   gender_concept_id TYPE bigint;
-- ALTER TABLE provider ALTER COLUMN   specialty_source_concept_id TYPE bigint;
-- ALTER TABLE provider ALTER COLUMN   gender_source_concept_id TYPE bigint;
-- ALTER TABLE condition_era ALTER COLUMN   condition_era_id TYPE bigint;
-- ALTER TABLE condition_era ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE condition_era ALTER COLUMN   condition_concept_id TYPE bigint;
-- ALTER TABLE condition_era ALTER COLUMN   condition_occurrence_count TYPE bigint;
-- ALTER TABLE payer_plan_period ALTER COLUMN   payer_plan_period_id TYPE bigint;
-- ALTER TABLE payer_plan_period ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE care_site ALTER COLUMN   care_site_id TYPE bigint;
-- ALTER TABLE care_site ALTER COLUMN   place_of_service_concept_id TYPE bigint;
-- ALTER TABLE care_site ALTER COLUMN   location_id TYPE bigint;
-- ALTER TABLE procedure_occurrence ALTER COLUMN   procedure_occurrence_id TYPE bigint;
-- ALTER TABLE procedure_occurrence ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE procedure_occurrence ALTER COLUMN   procedure_concept_id TYPE bigint;
-- ALTER TABLE procedure_occurrence ALTER COLUMN   procedure_type_concept_id TYPE bigint;
-- ALTER TABLE procedure_occurrence ALTER COLUMN   modifier_concept_id TYPE bigint;
-- ALTER TABLE procedure_occurrence ALTER COLUMN   quantity TYPE bigint;
-- ALTER TABLE procedure_occurrence ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE procedure_occurrence ALTER COLUMN   visit_occurrence_id TYPE bigint;
-- ALTER TABLE procedure_occurrence ALTER COLUMN   visit_detail_id TYPE bigint;
-- ALTER TABLE procedure_occurrence ALTER COLUMN   procedure_source_concept_id TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   person_id TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   gender_concept_id TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   year_of_birth TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   month_of_birth TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   day_of_birth TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   race_concept_id TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   ethnicity_concept_id TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   location_id TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   provider_id TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   care_site_id TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   gender_source_concept_id TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   race_source_concept_id TYPE bigint;
-- ALTER TABLE person ALTER COLUMN   ethnicity_source_concept_id TYPE bigint;
