CREATE TABLE omop.tmp_note_nlp_concept
(       
  section_code integer
, category_code integer
, section_text text
);

CREATE TABLE omop.tmp_note_nlp 
(       
  row_id integer
, section_code integer
, section_count integer
, section_index integer 
, section_begin integer
, section_end integer 
, section_text text
);



