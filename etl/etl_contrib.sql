\set ON_ERROR_STOP true
\timing

\i etl/StandardizedVocabularies/COHORT_DEFINITION/etl.sql
\i etl/StandardizedDerivedElements/COHORT_ATTRIBUTE/etl.sql
\i etl/StandardizedClinicalDataTables/MEASUREMENT/etl_contrib.sql
\i etl/StandardizedVocabularies/ATTRIBUTE_DEFINITION/etl.sql
\i etl/StandardizedClinicalDataTables/NOTE_NLP/etl.sql
