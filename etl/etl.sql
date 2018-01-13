set search_path to mimiciii;
\timing
\i mimic/build-mimic/postgres_update_mimic.sql

TRUNCATE TABLE  omop.care_site CASCADE;
TRUNCATE TABLE  omop.cohort_definition CASCADE;
TRUNCATE TABLE  omop.cohort_attribute CASCADE;
TRUNCATE TABLE  omop.attribute_definition CASCADE;
TRUNCATE TABLE  omop.person CASCADE;
TRUNCATE TABLE  omop.death CASCADE;
TRUNCATE TABLE  omop.visit_occurrence CASCADE;
TRUNCATE TABLE  omop.visit_detail CASCADE;
TRUNCATE TABLE  omop.procedure_occurrence CASCADE;
TRUNCATE TABLE  omop.provider CASCADE;
TRUNCATE TABLE  omop.condition_occurrence CASCADE;
TRUNCATE TABLE  omop.observation CASCADE;
TRUNCATE TABLE  omop.drug_exposure CASCADE;
TRUNCATE TABLE  omop.measurement CASCADE;

--\i mimic/build-mimic/postgres_create_mimic_id.sql

\i omop/build-omop/postgresql/mimic-omop-disable-trigger.sql

\i etl/pg_function.sql
\i etl/StandardizedVocabularies/CONCEPT/etl.sql
\i etl/StandardizedDerivedElements/COHORT_ATTRIBUTE/etl.sql
\i etl/StandardizedHealthSystemDataTables/CARE_SITE/etl.sql
\i etl/StandardizedClinicalDataTables/PERSON/etl.sql
\i etl/StandardizedClinicalDataTables/DEATH/etl.sql
\i etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE/etl.sql
\i etl/StandardizedClinicalDataTables/VISIT_DETAIL/etl.sql
\i etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE/etl.sql
\i etl/StandardizedHealthSystemDataTables/PROVIDER/etl.sql
\i etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE/etl.sql
\i etl/StandardizedClinicalDataTables/OBSERVATION/etl.sql
\i etl/StandardizedClinicalDataTables/DRUG_EXPOSURE/etl.sql
\i etl/StandardizedClinicalDataTables/MEASUREMENT/etl.sql

\i omop/build-omop/postgresql/mimic-omop-enable-trigger.sql
