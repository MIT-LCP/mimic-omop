TRUNCATE TABLE omop.tmp_note_nlp;
\copy omop.tmp_note_nlp FROM PROGRAM 'gzip -dc ~/git/mimic-omop/extras/private/fait_doc_section_mimic.csv.gz' CSV DELIMITER ';' NULL '' QUOTE '"' ESCAPE E'\\';
TRUNCATE TABLE omop.tmp_note_nlp_concept;
\copy omop.tmp_note_nlp_concept FROM '~/git/mimic-omop/extras/data/note_section_list.csv' CSV DELIMITER ',' NULL '' QUOTE '"' ESCAPE E'\\';

