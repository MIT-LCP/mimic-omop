-- SELECT '\copy (SELECT * FROM omop.' || table_name || ') TO PROGRAM ''gzip > etl/Result/' || table_name || '.csv.gz'' CSV HEADER QUOTE ''"'';'
--  FROM
--     information_schema.tables
--  WHERE
--   table_catalog = 'mimic' AND
--    table_schema = 'omop'
-- ;
------------------------------------------------------------------------------------------------------------------------------------
 \copy (SELECT * FROM omop.attribute_definition) TO PROGRAM 'gzip > etl/Result/attribute_definition.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.cdm_source) TO PROGRAM 'gzip > etl/Result/cdm_source.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.vocabulary) TO PROGRAM 'gzip > etl/Result/vocabulary.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.note_nlp) TO PROGRAM 'gzip > etl/Result/note_nlp.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.dose_era) TO PROGRAM 'gzip > etl/Result/dose_era.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.person) TO PROGRAM 'gzip > etl/Result/person.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.payer_plan_period) TO PROGRAM 'gzip > etl/Result/payer_plan_period.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.domain) TO PROGRAM 'gzip > etl/Result/domain.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.concept_relationship) TO PROGRAM 'gzip > etl/Result/concept_relationship.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.fact_relationship) TO PROGRAM 'gzip > etl/Result/fact_relationship.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.relationship) TO PROGRAM 'gzip > etl/Result/relationship.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.cohort) TO PROGRAM 'gzip > etl/Result/cohort.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.concept_synonym) TO PROGRAM 'gzip > etl/Result/concept_synonym.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.concept_ancestor) TO PROGRAM 'gzip > etl/Result/concept_ancestor.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.drug_strength) TO PROGRAM 'gzip > etl/Result/drug_strength.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.observation_period) TO PROGRAM 'gzip > etl/Result/observation_period.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.location) TO PROGRAM 'gzip > etl/Result/location.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.cohort_definition) TO PROGRAM 'gzip > etl/Result/cohort_definition.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.specimen) TO PROGRAM 'gzip > etl/Result/specimen.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.death) TO PROGRAM 'gzip > etl/Result/death.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.visit_detail) TO PROGRAM 'gzip > etl/Result/visit_detail.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.procedure_occurrence) TO PROGRAM 'gzip > etl/Result/procedure_occurrence.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.drug_exposure) TO PROGRAM 'gzip > etl/Result/drug_exposure.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.condition_occurrence) TO PROGRAM 'gzip > etl/Result/condition_occurrence.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.note) TO PROGRAM 'gzip > etl/Result/note.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.care_site) TO PROGRAM 'gzip > etl/Result/care_site.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.provider) TO PROGRAM 'gzip > etl/Result/provider.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.observation) TO PROGRAM 'gzip > etl/Result/observation.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.source_to_concept_map) TO PROGRAM 'gzip > etl/Result/source_to_concept_map.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.cohort_attribute) TO PROGRAM 'gzip > etl/Result/cohort_attribute.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.concept_class) TO PROGRAM 'gzip > etl/Result/concept_class.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.drug_era) TO PROGRAM 'gzip > etl/Result/drug_era.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.condition_era) TO PROGRAM 'gzip > etl/Result/condition_era.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.cost) TO PROGRAM 'gzip > etl/Result/cost.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.device_exposure) TO PROGRAM 'gzip > etl/Result/device_exposure.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.measurement) TO PROGRAM 'gzip > etl/Result/measurement.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.concept) TO PROGRAM 'gzip > etl/Result/concept.csv.gz' CSV HEADER QUOTE '"';
 \copy (SELECT * FROM omop.visit_occurrence) TO PROGRAM 'gzip > etl/Result/visit_occurrence.csv.gz' CSV HEADER QUOTE '"';
