# Link to CommonDataModel
- [NOTE](https://github.com/OHDSI/CommonDataModel/wiki/NOTE)

# Source Tables

## [noteevents](https://mimic.physionet.org/mimictables/noteevents/)

- source category goes into `value_source_value`

## Mapping used

- notes categories have been mapped to omop standard concepts
    - https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/note_category_to_concept.csv

# Example

## explanation of the `note_type_concept_id`
SELECT concept_name, note_type_concept_id, count(1)
from note
JOIN concept ON note_type_concept_id = concept_id
group by concept_name, note_type_concept_id ORDER BY count(1) desc;

##  explanation of `section_source_value`
-- = type of note in non standard mimic concept
SELECT section_source_value, count(1)
FROM omop.note_nlp
GROUP by section_source_value ORDER BY count(1) desc;
