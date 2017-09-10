DROP SCHEMA omop CASCADE;
CREATE SCHEMA omop;
SET search_path TO omop;
\i 'OMOP CDM ddl - PostgreSQL.sql'
\i 'OMOP CDM constraints - PostgreSQL.sql'
\i 'OMOP CDM comments - PostgreSQL.sql'
