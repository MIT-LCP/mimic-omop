--BEGIN;
\set ON_ERROR_STOP true
set search_path to :'mimicschema';
\timing

TRUNCATE TABLE  omop.care_site CASCADE;
TRUNCATE TABLE  omop.cohort_definition CASCADE;
TRUNCATE TABLE  omop.cohort_attribute CASCADE;
TRUNCATE TABLE  omop.attribute_definition CASCADE;
TRUNCATE TABLE  omop.person CASCADE;
TRUNCATE TABLE  omop.death CASCADE;
TRUNCATE TABLE  omop.visit_occurrence CASCADE;
TRUNCATE TABLE  omop.observation_period CASCADE;
TRUNCATE TABLE  omop.visit_detail CASCADE;
TRUNCATE TABLE  omop.procedure_occurrence CASCADE;
TRUNCATE TABLE  omop.provider CASCADE;
TRUNCATE TABLE  omop.condition_occurrence CASCADE;
TRUNCATE TABLE  omop.observation CASCADE;
TRUNCATE TABLE  omop.drug_exposure CASCADE;
TRUNCATE TABLE  omop.measurement CASCADE;
TRUNCATE TABLE  omop.specimen CASCADE;
TRUNCATE TABLE  omop.note CASCADE;
TRUNCATE TABLE  omop.note_nlp CASCADE;
TRUNCATE TABLE  omop.fact_relationship CASCADE;


\i omop/build-omop/postgresql/mimic-omop-disable-trigger.sql

\i etl/pg_function.sql
\i etl/StandardizedVocabularies/CONCEPT/etl.sql -- SHALL be first loaded table
\i etl/StandardizedHealthSystemDataTables/CARE_SITE/etl.sql
\i etl/StandardizedHealthSystemDataTables/PROVIDER/etl.sql
\i etl/StandardizedClinicalDataTables/PERSON/etl.sql
\i etl/StandardizedClinicalDataTables/DEATH/etl.sql
\i etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE/etl.sql
\i etl/StandardizedClinicalDataTables/OBSERVATION_PERIOD/etl.sql
\i etl/StandardizedClinicalDataTables/VISIT_DETAIL/etl.sql
\i etl/StandardizedClinicalDataTables/NOTE/etl.sql
\i etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE/etl.sql
\i etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE/etl.sql
\i etl/StandardizedClinicalDataTables/DRUG_EXPOSURE/etl.sql
\i etl/StandardizedClinicalDataTables/OBSERVATION/etl.sql
\i etl/StandardizedClinicalDataTables/MEASUREMENT/etl.sql
\i etl/StandardizedClinicalDataTables/SPECIMEN/etl.sql

--\i omop/build-omop/postgresql/mimic-omop-enable-trigger.sql
--ROLLBACK;
--COMMIT;
