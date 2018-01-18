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

``` sql
SELECT concept_name, note_type_concept_id, count(1)
FROM note
JOIN concept ON note_type_concept_id = concept_id
GROUP BY concept_name, note_type_concept_id ORDER BY count(1) desc;
```
|    concept_name     | note_type_concept_id | count |
|---------------------|----------------------|-------|
| Nursing report      |             44814644 |  2326|
| Radiology report    |             44814641 |   990|
| Pathology report    |             44814642 |   482|
| No matching concept |                    0 |   476|
| Discharge summary   |             44814637 |   123|
| Ancillary report    |             44814643 |    38|
| Inpatient note      |             44814639 |    11|

##  explanation of `section_source_value`

``` sql
-- = type of note in non standard mimic concept
SELECT note_source_value, count(1)
FROM omop.note
GROUP by note_source_value ORDER BY count(1) desc
LIMIT 10;
```
| note_source_value | count |
|-------------------|-------|
| Nursing/other     |  1757|
| Radiology         |   990|
| Nursing           |   569|
| Physician         |   402|
| ECG               |   402|
| Discharge summary |   123|
| Echo              |    80|
| Respiratory       |    71|
| Nutrition         |    20|
| General           |    11|
