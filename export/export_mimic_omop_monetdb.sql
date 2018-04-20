-- SELECT '\copy (SELECT * FROM omop.' || table_name || ') TO PROGRAM ''gzip > etl/Result/' || table_name || '.csv.gz'' CSV HEADER QUOTE ''"'';'
--  FROM
--     information_schema.tables
--  WHERE
--   table_catalog = 'mimic' AND
--    table_schema = 'omop'
-- ;
------------------------------------------------------------------------------------------------------------------------------------
 \copy (SELECT note_id , person_id , note_date , note_datetime , note_type_concept_id , note_class_concept_id , note_title , replace( note_text, E'\\', '\\\\' ) as note_text , encoding_concept_id , language_concept_id , provider_id , visit_occurrence_id , note_source_value , visit_detail_id FROM omop.note) TO PROGRAM 'gzip > etl/Result/note.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT note_nlp_id , note_id , section_concept_id , snippet, replace( lexical_variant, E'\\', '\\\\' ) as lexical_variant, note_nlp_concept_id , note_nlp_source_concept_id , nlp_system , nlp_date , nlp_datetime , term_exists , term_temporal , term_modifiers , offset_begin , offset_end , section_source_value , section_source_concept_id FROM omop.note_nlp) TO PROGRAM 'gzip > etl/Result/note_nlp.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.attribute_definition) TO PROGRAM 'gzip > etl/Result/attribute_definition.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.cdm_source) TO PROGRAM 'gzip > etl/Result/cdm_source.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.vocabulary) TO PROGRAM 'gzip > etl/Result/vocabulary.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.dose_era) TO PROGRAM 'gzip > etl/Result/dose_era.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.person) TO PROGRAM 'gzip > etl/Result/person.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.payer_plan_period) TO PROGRAM 'gzip > etl/Result/payer_plan_period.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.domain) TO PROGRAM 'gzip > etl/Result/domain.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.concept_relationship) TO PROGRAM 'gzip > etl/Result/concept_relationship.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"'; \copy (SELECT * FROM omop.fact_relationship) TO PROGRAM 'gzip > etl/Result/fact_relationship.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.relationship) TO PROGRAM 'gzip > etl/Result/relationship.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.cohort) TO PROGRAM 'gzip > etl/Result/cohort.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.concept_synonym) TO PROGRAM 'gzip > etl/Result/concept_synonym.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.concept_ancestor) TO PROGRAM 'gzip > etl/Result/concept_ancestor.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.drug_strength) TO PROGRAM 'gzip > etl/Result/drug_strength.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.observation_period) TO PROGRAM 'gzip > etl/Result/observation_period.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.location) TO PROGRAM 'gzip > etl/Result/location.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.cohort_definition) TO PROGRAM 'gzip > etl/Result/cohort_definition.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.specimen) TO PROGRAM 'gzip > etl/Result/specimen.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.death) TO PROGRAM 'gzip > etl/Result/death.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.visit_detail) TO PROGRAM 'gzip > etl/Result/visit_detail.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.procedure_occurrence) TO PROGRAM 'gzip > etl/Result/procedure_occurrence.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT drug_exposure_id , person_id , drug_concept_id , drug_exposure_start_date , drug_exposure_start_datetime , drug_exposure_end_date , drug_exposure_end_datetime , verbatim_end_date , drug_type_concept_id , replace( stop_reason, E'\\', '\\\\' ) as sto_reason , refills , quantity , days_supply , replace( sig, E'\\', '\\\\' ) as sig , route_concept_id , replace( lot_number, E'\\', '\\\\' ) as lot_number , provider_id , visit_occurrence_id , visit_detail_id , replace( drug_source_value, E'\\', '\\\\' ) as drug_source_value , drug_source_concept_id , replace( route_source_value, E'\\', '\\\\' ) as route_source_value , replace( dose_unit_source_value, E'\\', '\\\\' ) as dose_unit_source_value , replace( quantity_source_value, E'\\', '\\\\' ) as quantity_source_value FROM omop.drug_exposure) TO PROGRAM 'gzip > etl/Result/drug_exposure.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.condition_occurrence) TO PROGRAM 'gzip > etl/Result/condition_occurrence.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.care_site) TO PROGRAM 'gzip > etl/Result/care_site.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.provider) TO PROGRAM 'gzip > etl/Result/provider.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.observation) TO PROGRAM 'gzip > etl/Result/observation.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.source_to_concept_map) TO PROGRAM 'gzip > etl/Result/source_to_concept_map.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.cohort_attribute) TO PROGRAM 'gzip > etl/Result/cohort_attribute.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.concept_class) TO PROGRAM 'gzip > etl/Result/concept_class.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.drug_era) TO PROGRAM 'gzip > etl/Result/drug_era.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.condition_era) TO PROGRAM 'gzip > etl/Result/condition_era.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.cost) TO PROGRAM 'gzip > etl/Result/cost.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.device_exposure) TO PROGRAM 'gzip > etl/Result/device_exposure.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT measurement_id , person_id , measurement_concept_id , measurement_date , measurement_datetime , measurement_type_concept_id , operator_concept_id , value_as_number , value_as_concept_id , unit_concept_id , range_low , range_high , provider_id , visit_occurrence_id , visit_detail_id , replace( measurement_source_value , E'\\', '\\\\' ) as measurement_source_value , measurement_source_concept_id,  replace(  unit_source_value , E'\\', '\\\\' ) as unit_source_value , replace( value_source_value, E'\\', '\\\\' ) as value_source_value FROM omop.measurement) TO PROGRAM 'gzip > etl/Result/measurement.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,standard_concept,concept_code,valid_start_date,valid_end_date,invalid_reason FROM omop.concept) TO PROGRAM 'gzip > etl/Result/concept.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
 \copy (SELECT * FROM omop.visit_occurrence) TO PROGRAM 'gzip > etl/Result/visit_occurrence.csv.gz' CSV DELIMITER '|' HEADER QUOTE '"';
