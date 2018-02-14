-- MIMICIII FULL
DROP SCHEMA mimicdemo CASCADE;
CREATE SCHEMA mimicdemo;
SET search_path TO mimicdemo;
\i 'postgres_create_tables.sql'
\i 'postgres_load_data.sql'
