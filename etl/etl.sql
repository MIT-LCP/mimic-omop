--BEGIN;
\set ON_ERROR_STOP true
\timing

TRUNCATE TABLE  :OMOP_SCHEMA.care_site CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.cohort_definition CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.cohort_attribute CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.attribute_definition CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.person CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.death CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.visit_occurrence CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.observation_period CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.visit_detail CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.procedure_occurrence CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.provider CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.condition_occurrence CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.observation CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.drug_exposure CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.measurement CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.specimen CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.note CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.note_nlp CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.fact_relationship CASCADE;
TRUNCATE TABLE  :OMOP_SCHEMA.dose_era CASCADE;


--\i omop/build-omop/postgresql/mimic-omop-disable-trigger.sql
\i etl/pg_function.sql
\i etl/StandardizedVocabularies/CONCEPT/etl.sql
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
\i etl/StandardizedDerivedElements/DOSE_ERA/etl.sql
--\i omop/build-omop/postgresql/mimic-omop-enable-trigger.sql
--ROLLBACK;
--COMMIT;
