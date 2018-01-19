# URL to CommonDataModel
- [PROCEDURE_OCCURRENCE](https://github.com/OHDSI/CommonDataModel/wiki/PROCEDURE_OCCURRENCE)

# Source Tables

## [procedures_icd](https://mimic.physionet.org/mimictables/procedures_icd/)

- `procedure_type_concept_id` = 38003622 ("Procedure recorded as diagnostic code")
- the ICD9 codes are transformed to match to `omop.concept`
- mimic.sequence column is lost in the process
- the procedure date is the admission end date

## [procedureevents_mv](https://mimic.physionet.org/mimictables/procedureevents_mv/)

- `procedure_type_concept_id` = 38000275 ("EHR order list entry")
- code are mapped to SNOMED procedure in `procedure_concept_id`
- the datetime is the begining of the procedure
- quantity is the duration of the procedure in minutes
- rows cancelled have not been exported from mimic
- `visit_detail_id` is assigned

## [cptevents](https://mimic.physionet.org/mimictables/cptevents/)

- `procedure_type_concept_id` = 257 ("Hospitalization Cost Record")
- the procedure date is the chardate when absent substitued with admission start date

# Mapping used

## [cpt4_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/cpt4_to_concept.csv)

- it maps CPT4 codes to information in the `mimic.cpteevents` table
- `\copy (SELECT distinct '[' || coalesce(costcenter,'') || '][' || coalesce(sectionheader,'') || '] ' || subsectionheader || ' ' || coalesce(description, '') as procedure_source_value FROM mimic.cptevents  order by 1) TO '/tmp/cpt4_to_concept.csv' CSV HEADER QUOTE '"';`
- all the relevant information have been collapsed into `procedure_source_value` field
- the mapping to cpt4 is done manually. When not relevant the field `omop_mapping_is_sure` is equal to 0

## [procedure_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/procedure_to_concept.csv)

- it maps SNOMED codes to itemid in the `mimic.procedureevents_mv` table
- No idea how the mapping was made by google

# Examples

## Explanation of `procedure_type_concept_id`

``` sql
SELECT concept_name, concept_id, count(1)
FROM procedure_occurrence
JOIN concept ON concept_id = procedure_type_concept_id
GROUP BY concept_name, concept_id ORDER BY count(1) DESC;
```
|             concept_name              | concept_id | count  |
|---------------------------------------|------------|--------|
| Hospitalization Cost Record           |        257 | 573146|
| EHR order list entry                  |   38000275 | 250284|
| Procedure recorded as diagnostic code |   38003622 | 240095|

## Some interesting recorded procedures

``` sql
SELECT procedure_source_value, count(1)
FROM procedure_occurrence
WHERE procedure_type_concept_id = 38000275
GROUP BY procedure_source_value ORDER BY count(1) DESC
LIMIT 10;
```
| procedure_source_value | count |
|------------------------|-------|
| Chest X-Ray            | 31953|
| 20 Gauge               | 27631|
| 18 Gauge               | 20058|
| EKG                    | 13659|
| Arterial Line          | 12374|
| Invasive Ventilation   | 10442|
| Blood Cultured         |  9873|
| CT scan                |  8510|
| Extubation             |  7909|
| Multi Lumen            |  7664|

``` sql
SELECT concept_name, count(1)
FROM procedure_occurrence
JOIN concept ON concept_id = procedure_source_concept_id
WHERE procedure_type_concept_id = 38003622
GROUP BY concept_name ORDER BY count(1) DESC
LIMIT 10;
```
|                                 concept_name                                  | count |
|-------------------------------------------------------------------------------|-------|
| Venous catheterization, not elsewhere classified                              | 14731|
| Insertion of endotracheal tube                                                | 10333|
| Enteral infusion of concentrated nutritional substances                       |  9300|
| Continuous invasive mechanical ventilation for less than 96 consecutive hours |  9100|
| Transfusion of packed cells                                                   |  7244|
| Extracorporeal circulation auxiliary to open heart surgery                    |  6838|
| Continuous invasive mechanical ventilation for 96 consecutive hours or more   |  6048|
| Prophylactic administration of vaccine against other diseases                 |  5842|
| Coronary arteriography using two catheters                                    |  5337|
| Arterial catheterization                                                      |  4737|

``` sql
SELECT procedure_source_value, count(1)
FROM procedure_occurrence
WHERE procedure_type_concept_id = 257
GROUP BY procedure_source_value ORDER BY count(1) DESC
LIMIT 10;
```
|   procedure_source_value    | count  |
|-----------------------------|--------|
| Hospital inpatient services | 268296|
| Critical care services      | 106469|
| Pulmonary                   | 101563|
| Consultations               |  25925|
| Cardiovascular system       |  21485|
| Respiratory system          |  10516|
| Dialysis                    |   9778|
| Musculoskeletal system      |   6275|
| Digestive system            |   4979|
| Nervous system              |   3662|
