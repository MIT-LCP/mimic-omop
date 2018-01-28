set search_path to :'mimicschema';
\set ECHO
\set QUIET 0
-- Turn off echo and keep things quiet.

-- Format the output for nice TAP.
\pset format unaligned
\pset tuples_only true
\pset pager

-- Revert all changes on failure.
\set ON_ERROR_ROLLBACK 1
\set ON_ERROR_STOP false
\set QUIET 1

\i etl/StandardizedVocabularies/CONCEPT/check_etl.sql
\i etl/StandardizedVocabularies/COHORT_DEFINITION/check_etl.sql
\i etl/StandardizedVocabularies/ATTRIBUTE_DEFINITION/check_etl.sql
\i etl/StandardizedDerivedElements/COHORT_ATTRIBUTE/check_etl.sql
\i etl/StandardizedHealthSystemDataTables/CARE_SITE/check_etl.sql
\i etl/StandardizedClinicalDataTables/PERSON/check_etl.sql
\i etl/StandardizedClinicalDataTables/DEATH/check_etl.sql
\i etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE/check_etl.sql
\i etl/StandardizedClinicalDataTables/OBSERVATION_PERIOD/check_etl.sql
\i etl/StandardizedClinicalDataTables/VISIT_DETAIL/check_etl.sql
\i etl/StandardizedClinicalDataTables/MEASUREMENT/check_etl.sql
\i etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE/check_etl.sql
\i etl/StandardizedHealthSystemDataTables/PROVIDER/check_etl.sql
\i etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE/check_etl.sql
\i etl/StandardizedClinicalDataTables/OBSERVATION/check_etl.sql
\i etl/StandardizedClinicalDataTables/DRUG_EXPOSURE/check_etl.sql
\i etl/StandardizedClinicalDataTables/NOTE/check_etl.sql
\i etl/StandardizedClinicalDataTables/NOTE_NLP/check_etl.sql
