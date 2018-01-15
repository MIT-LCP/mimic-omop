# URL to CommonDataModel
- https://github.com/OHDSI/CommonDataModel/wiki/NOTE

# Source Tables

## noteevents

# Example
``` sql
-- explanation of the note_type_concept_id
-- 
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
