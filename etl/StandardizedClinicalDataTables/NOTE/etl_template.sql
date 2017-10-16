 WITH noteevents AS (SELECT row_id as note_id, subject_id as person_id, chartdate as note_date, charttime as note_datetime, description as note_title, text as note_text, hadm_id as visit_occurrence_id FROM mimic.noteevents) 
 INSERT INTO omop.NOTE (note_id, person_id, note_date, note_datetime, note_title, note_text, visit_occurrence_id)
 SELECT noteevents.note_id, noteevents.person_id, noteevents.note_date, noteevents.note_datetime, noteevents.note_title, noteevents.note_text, noteevents.visit_occurrence_id 
FROM noteevents 