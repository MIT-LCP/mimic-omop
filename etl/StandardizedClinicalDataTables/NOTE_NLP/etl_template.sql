 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.NOTE_NLP ()
 SELECT NA.note_nlp_id, NA.note_id, NA.section_concept_id, NA.snippet, NA.offset, NA.lexical_variant, NA.note_nlp_concept_id, NA.note_nlp_source_concept_id, NA.nlp_system, NA.nlp_date, NA.nlp_datetime, NA.term_exists 
FROM NA 