# URL to CommonDataModel
- https://github.com/OHDSI/CommonDataModel/wiki/NOTE

# Source Tables

## noteevents

- source category goes into value_source_value
- notes categories have been mapped to omop standard concepts

# Example
``` sql
-- explanation of the note_type_concept_id
-- = type of note in standard omop concept
SELECT concept_name, note_type_concept_id, count(1)
from note
JOIN concept ON note_type_concept_id = concept_id
group by concept_name, note_type_concept_id ORDER BY count(1) desc;
```
    concept_name     | note_type_concept_id |  count
---------------------+----------------------+---------
 Nursing report      |             44814644 | 1046053
 Radiology report    |             44814641 |  522279
 Pathology report    |             44814642 |  254845
 No matching concept |                    0 |  174330
 Discharge summary   |             44814637 |   59652
 Ancillary report    |             44814643 |   17622
 Inpatient note      |             44814639 |    8399


``` sql
-- explanation of secion_source_value
-- = type of note in non standard mimic concept
SELECT section_source_value, count(1)
FROM omop.note_nlp
GROUP by section_source_value ORDER BY count(1) desc;
