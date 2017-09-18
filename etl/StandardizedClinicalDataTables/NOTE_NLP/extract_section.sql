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
\copy (WITH tot AS (SELECT count(1) as nb, category FROM noteevents GROUP BY category),
tmp AS (
SELECT * FROM mimiciii.noteevents_section_count
LEFT JOIN tot USING (category)
WHERE count > 200
)
SELECT * , ( count::float / nb::float * 100::float ) as percent_avec_section FROM tmp
GROUP BY tmp.category, label, count, nb
ORDER BY tmp.category, percent_avec_section DESC) TO '/tmp/section_list.csv' CSV HEADER;
