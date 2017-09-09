-- a first way to bulk extract section
-- next steps are:
-- 1. remove no relevant section
-- 2. add missing section from manual read
-- 3. map sections to loinc
-- 4. run the existing UIMA extract_section pipeline 
-- 5. load the OMOP note_nlp table

set search_path TO mimiciii;
DROP  MATERIALIZED VIEW  noteevents_section_count ;
CREATE MATERIALIZED VIEW noteevents_section_count  AS
WITH section_regex (category, regex) AS ( VALUES
('Nursing/other', ''), --NO SECTION, free text
('Nursing', '([A-z]+:)'), --OK
('Radiology', '[ ]*([A-Z ]+:)'), --OK
('ECG', ''),-- NO SECTION
('Physician ', '[ ]*([A-Z]+[A-Z ]+:)'),-- OK
('Discharge summary', '\n([A-Z]+[A-Z ]+:)\n'),-- OK
('Echo', '[ ]*([A-Z]+[A-Z ]+:)'),-- OK
('Respiratory ', '\n[ ]*([A-Z][a-z ]+:)'),-- OK
('Nutrition', '\n[ ]*([A-Z][a-z ]+:)'),-- OK
('General', '\n[ ]*([A-Z][a-z ]+:)'), -- OK, not sure relevant
('Rehab Services', '\n[ ]*([A-Z][a-z ]+:)'), --OK
('Social Work', '\n[ ]*([A-Z][a-z ]+:)'), -- OK
('Case Management ', '\n[ ]*([A-Z][a-z ]+:)'),-- OK
('Pharmacy', '\n[ ]*([A-Z][A-Z]*[a-z ]*[:]{0,1})'),-- OK, but many false positive
('Consult', '\n[ ]*([A-Z][a-z ]+:)'), -- OK
('','')
),
all_label AS (SELECT row_id, category, unnest(regexp_matches(text, regex, 'g')) as label
FROM (SELECT row_id, category, regex, text
	FROM noteevents 
	JOIN section_regex USING ( category )
	 ) AS TMP 
)
SELECT count(1), category, label
FROM all_label
GROUP BY category, label
ORDER BY category, count DESC;
\copy (SELECT * FROM mimiciii.noteevents_section_count WHERE count > 200 ORDER BY category, count DESC) TO 'section_list.csv' CSV HEADER;
