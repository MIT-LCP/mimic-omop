-- MIMICIII SUBSET
DROP SCHEMA mimic CASCADE;
CREATE SCHEMA mimic;
SET search_path TO mimic;
\i 'postgres_create_tables.sql'
\i 'postgres_add_comments.sql'
\i 'postgres_load_subset_tables.sql'
\i 'postgres_add_constraints.sql'
