-- MIMICIII FULL
DROP SCHEMA mimiciii CASCADE;
CREATE SCHEMA mimiciii;
SET search_path TO mimiciii;
\i 'postgres_create_tables.sql'
\i 'postgres_load_data_gz.sql'
