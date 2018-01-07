set search_path to mimic;

\i ../mimic/build-mimic/postgres_update_mimic.sql

TRUNCATE TABLE  omop.care_site CASCADE;
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

\i ../mimic/build-mimic/postgres_create_mimic_id.sql
\i pg_function.sql
\i StandardizedVocabularies/CONCEPT/etl.sql
\i StandardizedHealthSystemDataTables/CARE_SITE/etl.sql
\i StandardizedClinicalDataTables/PERSON/etl.sql
\i StandardizedClinicalDataTables/DEATH/etl.sql
\i StandardizedClinicalDataTables/VISIT_OCCURRENCE/etl.sql
\i StandardizedClinicalDataTables/VISIT_DETAIL/etl.sql
\i StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE/etl.sql
\i StandardizedHealthSystemDataTables/PROVIDER/etl.sql
\i StandardizedClinicalDataTables/CONDITION_OCCURRENCE/etl.sql
\i StandardizedClinicalDataTables/OBSERVATION/etl.sql
\i StandardizedClinicalDataTables/DRUG_EXPOSURE/etl.sql
\i StandardizedClinicalDataTables/MEASUREMENT/etl.sql
