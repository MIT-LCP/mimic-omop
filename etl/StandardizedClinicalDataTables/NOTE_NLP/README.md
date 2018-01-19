# Link to CommonDataModel
- [NOTE_NLP](https://github.com/OHDSI/CommonDataModel/wiki/NOTE_NLP)

- is a contribution table
- `note_id` is a foreign key to `note` table

# Source Tables (mimic)

## [noteevents](https://mimic.physionet.org/mimictables/noteevents/)

- sections have not been yet mapped to a standard terminology. CDO (standard from loinc) recently gave up (see https://github.com/MIT-LCP/mimic-omop/issues/13)
- extracted section covers automatically extracted section that present at least 1% in the notes
- the resulting section have been manualy mapped together by Ivan Lerner (`section_concept_id`)
- the detailed level is left into `section_source_concept_id`
- notes in error in mimic were note extracted

# Examples

## explanation of `section_source_concept_id`

``` sql
SELECT concept_name, section_source_concept_id, count(1)
FROM note_nlp
JOIN concept ON section_source_concept_id = concept_id
GROUP by 1, 2 ORDER BY 3 desc LIMIT 20;
```
|     concept_name      | section_source_concept_id | count |
|-----------------------|---------------------------|-------|
| Heart rhythm:         |                2001067175 |  9958|
| Respiratory / Chest:  |                2001067198 |  5440|
| Cardiovascular:       |                2001067189 |  4498|
| No particular Section |                2001066541 |  4446|
| IVF:                  |                2001067188 |  3924|
| HISTORY:              |                2001067383 |  3920|
| Abdominal:            |                2001067200 |  3816|
| IMPRESSION:           |                2001067379 |  3710|
| Neurologic:           |                2001067185 |  3555|
| Allergies:            |                2001067155 |  3519|
| Drains:               |                2001067165 |  3112|
| Peripheral Vascular:  |                2001067207 |  2788|
| Lines:                |                2001067183 |  2752|
| HPI:                  |                2001067197 |  2520|
| Disposition:          |                2001067187 |  2448|
| RUL Lung Sounds:      |                2001067547 |  2380|
| LLL Lung Sounds:      |                2001067548 |  2380|
| LUL Lung Sounds:      |                2001067546 |  2380|
| RLL Lung Sounds:      |                2001067549 |  2380|
| BP:                   |                2001067168 |  2334|

## how to access to one section

``` sql
-- the 5 first section
SELECT lexical_variant
FROM note_nlp
WHERE section_source_concept_id = 2001067155                      -- concept.concept_name = 'Allergies'
limit 5 ;
```
| lexical_variant |
|-----------------|
| Allergies:     ||
|    Penicillins ||
|    Unknown;    ||
|    |
| Allergies:     ||
|    Penicillins ||
|    Unknown;    ||
|    |
| Allergies:     ||
|    Penicillins ||
|    Unknown;    ||
|    |
| Allergies:     ||
|    Penicillins ||
|    Unknown;    ||
|    |
| Allergies:     ||
|    Penicillins ||
|    Unknown;    ||
|    |
