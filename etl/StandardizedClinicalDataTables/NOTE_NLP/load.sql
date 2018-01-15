--- useful for note_nlp etl integration
--CREATE TABLE omop.tmp_note_nlp_concept
--(       
--  section_code integer
--, category_code integer
--, section_text text
--);
--
--CREATE TABLE omop.tmp_note_nlp 
--(       
--  row_id integer
--, section_index integer
--, section_count integer
--, section_code integer 
--, section_begin integer
--, section_end integer 
--, section_text text
--);

TRUNCATE TABLE omop.tmp_note_nlp;
\copy omop.tmp_note_nlp FROM PROGRAM 'gzip -dc ~/git/mimic-omop/extras/private/fait_doc_section_mimic.csv.gz' CSV DELIMITER ';' NULL '' QUOTE '"' ESCAPE E'\\';
-- TRUNCATE TABLE omop.tmp_note_nlp_concept;
-- \copy omop.tmp_note_nlp_concept FROM '~/git/mimic-omop/extras/data/note_section_list.csv' CSV DELIMITER ',' NULL '' QUOTE '"' ESCAPE E'\\';

