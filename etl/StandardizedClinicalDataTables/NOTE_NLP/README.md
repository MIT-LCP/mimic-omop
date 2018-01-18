# Link to CommonDataModel
- [NOTE_NLP](https://github.com/OHDSI/CommonDataModel/wiki/NOTE_NLP)

- is a contribution table
- note_id is a foreign key to `note` table

# Source Tables

## [noteevents](https://mimic.physionet.org/mimictables/noteevents/)

- sections have not been yet mapped to a standard terminology. CDO (standard from loinc) recently gave up (see https://github.com/MIT-LCP/mimic-omop/issues/13)
- extracted section covers automatically extracted section that present at least 1% in the notes
- the resulting section have been manualy mapped together by Ivan Lerner (section_concept_id)
- the detailed level is left into section_source_concept_id
- notes in error in mimic were note extracted

# Example

## explanation of `section_source_concept_id`
-- the 20 first section
SELECT concept_name, section_source_concept_id, count(1)
FROM omop.note_nlp 
JOIN omop.concept ON section_source_concept_id = concept_id
GROUP by 1, 2 ORDER BY 3 desc LIMIT 20;

## how to access to one section
SELECT lexical_variant 
FROM note_nlp
WHERE section_source_concept_id = 2002120913  -- concept.concept_name = 'Allergies' 
limit 5 ;
