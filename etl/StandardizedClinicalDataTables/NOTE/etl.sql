 WITH
"noteevents" AS (
SELECT
  mimic_id as note_id
, cgid
, subject_id
, hadm_id
, chartdate as note_date
, charttime as note_datetime
, description as note_title
, text as note_text
, category as note_source_value
FROM noteevents
WHERE  iserror IS NULL
),
"gcpt_note_category_to_concept" AS (
SELECT category as note_source_value, concept_id as note_type_concept_id FROM gcpt_note_category_to_concept),
"admissions" as (SELECT hadm_id, mimic_id as visit_occurrence_id FROM admissions),
"patients" as (SELECT subject_id, mimic_id as person_id FROM patients),
"caregivers" AS (SELECT mimic_id AS provider_id, cgid FROM caregivers),
"row_to_insert" AS (
SELECT
  note_id
, person_id
, note_date
, note_datetime as note_datetime
, coalesce(gcpt_note_category_to_concept.note_type_concept_id,0) AS  note_type_concept_id
, 0 AS note_class_concept_id -- TODO/ not yet mapped to CDO
, note_title
, note_text
, 0 AS encoding_concept_id
, 40639385 as language_concept_id -- English (from metadata, maybe not the best)
, provider_id
, visit_occurrence_id
, noteevents.note_source_value AS note_source_value
, null::integer visit_detail_id
FROM noteevents
LEFT JOIN gcpt_note_category_to_concept ON trim(noteevents.note_source_value) = trim(gcpt_note_category_to_concept.note_source_value)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN caregivers USING (cgid)
)
INSERT INTO :OMOP_SCHEMA.NOTE
(
    note_id
  , person_id
  , note_date
  , note_datetime
  , note_type_concept_id
  , note_class_concept_id
  , note_title
  , note_text
  , encoding_concept_id
  , language_concept_id
  , provider_id
  , visit_occurrence_id
  , note_source_value
  , visit_detail_id
)
SELECT
  note_id
, person_id
, note_date
, note_datetime
, note_type_concept_id
, note_class_concept_id
, note_title
, note_text
, encoding_concept_id
, language_concept_id
, provider_id
, visit_occurrence_id
, note_source_value
, visit_detail_id
FROM row_to_insert;
