-- SELECT '\copy omop.' || table_name || ' FROM PROGRAM ''gzip -dc ' || table_name || '.csv.gz'' CSV HEADER NULL '''' QUOTE ''"'';'
--  FROM
--     information_schema.tables
--  WHERE
--   table_catalog = 'mimic' AND
--    table_schema = 'omop'
-- ;

drop schema if exists omop cascade;
create schema omop;
set search_path to omop;
\i 'omop_cdm_ddl.sql'
\i 'mimic-omop-alter.sql'

\copy omop.provider FROM PROGRAM 'gzip -dc provider.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.concept_class FROM PROGRAM 'gzip -dc concept_class.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.relationship FROM PROGRAM 'gzip -dc relationship.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.observation FROM PROGRAM 'gzip -dc observation.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.payer_plan_period FROM PROGRAM 'gzip -dc payer_plan_period.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.source_to_concept_map FROM PROGRAM 'gzip -dc source_to_concept_map.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.visit_occurrence FROM PROGRAM 'gzip -dc visit_occurrence.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.cdm_source FROM PROGRAM 'gzip -dc cdm_source.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.domain FROM PROGRAM 'gzip -dc domain.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.condition_occurrence FROM PROGRAM 'gzip -dc condition_occurrence.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.fact_relationship FROM PROGRAM 'gzip -dc fact_relationship.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.location FROM PROGRAM 'gzip -dc location.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.condition_era FROM PROGRAM 'gzip -dc condition_era.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.cohort_attribute FROM PROGRAM 'gzip -dc cohort_attribute.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.care_site FROM PROGRAM 'gzip -dc care_site.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.person FROM PROGRAM 'gzip -dc person.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.observation_period FROM PROGRAM 'gzip -dc observation_period.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.concept_synonym FROM PROGRAM 'gzip -dc concept_synonym.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.visit_detail FROM PROGRAM 'gzip -dc visit_detail.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.procedure_occurrence FROM PROGRAM 'gzip -dc procedure_occurrence.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.drug_strength FROM PROGRAM 'gzip -dc drug_strength.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.concept_ancestor FROM PROGRAM 'gzip -dc concept_ancestor.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.drug_era FROM PROGRAM 'gzip -dc drug_era.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.dose_era FROM PROGRAM 'gzip -dc dose_era.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.vocabulary FROM PROGRAM 'gzip -dc vocabulary.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.cohort_definition FROM PROGRAM 'gzip -dc cohort_definition.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.device_exposure FROM PROGRAM 'gzip -dc device_exposure.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.note FROM PROGRAM 'gzip -dc note.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.drug_exposure FROM PROGRAM 'gzip -dc drug_exposure.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.measurement FROM PROGRAM 'gzip -dc measurement.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.attribute_definition FROM PROGRAM 'gzip -dc attribute_definition.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.death FROM PROGRAM 'gzip -dc death.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.concept_relationship FROM PROGRAM 'gzip -dc concept_relationship.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.cost FROM PROGRAM 'gzip -dc cost.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.specimen FROM PROGRAM 'gzip -dc specimen.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.cohort FROM PROGRAM 'gzip -dc cohort.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.note_nlp FROM PROGRAM 'gzip -dc note_nlp.csv.gz' CSV HEADER NULL '' QUOTE '"';
\copy omop.concept FROM PROGRAM 'gzip -dc concept.csv.gz' CSV HEADER NULL '' QUOTE '"';
