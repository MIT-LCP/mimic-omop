set search_path to omop;
TRUNCATE TABLE  omop.care_site CASCADE;
TRUNCATE TABLE  omop.person CASCADE;
TRUNCATE TABLE  omop.death CASCADE;
TRUNCATE TABLE  omop.visit_occurrence CASCADE;
TRUNCATE TABLE  omop.visit_detail CASCADE;
TRUNCATE TABLE  omop.procedure_occurrence CASCADE;
\i StandardizedHealthSystemDataTables/CARE_SITE/etl.sql
\i StandardizedClinicalDataTables/PERSON/etl.sql
\i StandardizedClinicalDataTables/DEATH/etl.sql
\i StandardizedClinicalDataTables/VISIT_OCCURRENCE/etl.sql
\i StandardizedClinicalDataTables/VISIT_DETAIL/etl.sql
\i StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE/etl.sql
