# Link to CommonDataModel
- [OBSERVATION](https://github.com/OHDSI/CommonDataModel/wiki/OBSERVATION)

# Source Tables (mimic)

## [datetimeevents](https://mimic.physionet.org/mimictables/datetimeevents/)

- `observation_concept_id` is equal to 4085802 ("Referred by nurse")
- `visit_detail_id` is assigned

## [admissions](https://mimic.physionet.org/mimictables/admissions/)

- `observation_concept_id` is equal to 4052017  ("Religious affiliation")
- `observation_concept_id` is equal to 40758030 ("Language.preferred")
- `observation_concept_id` is equal to 40766231 ("Marital status")
- `observation_concept_id` is equal to 44803968 ("Ethnicity - National Public Health Classification")
- `observation_concept_id` is equal to 46235654 ("Primary insurance")

## [chartevents](https://mimic.physionet.org/mimictables/chartevents/)

- Textual data from chartevents are stored here
- Categorical variables are note considered as free text and are then stored in the measurement table

# Mapping used

## [insurance_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/insurance_to_concept.csv)

- it maps insurance in standard concept 

## [ethnicity_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/ethnicity_to_concept.csv)

- it maps ethnicity in standard concept 

## [religion_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/religion_to_concept.csv)

- it maps religion in standard concept 

## [marital_status_to_concept](github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/marital_status_to_concept.csv)

- it maps marital_status in standard concept 

# Examples

## Repartition of different concepts in `observation` table

``` sql
SELECT observation_concept_id, concept_name, count(1) 
FROM observation 
JOIN concept on observation_concept_id = concept_id 
GROUP BY observation_concept_id, concept_name ORDER BY count(1) desc;
```
| observation_concept_id |                   concept_name                    | count|
|------------------------|---------------------------------------------------|--------|
|                      0 | No matching concept                               | 160011|
|                4085802 | Referred by nurse                                 |  10342|
|                4296248 | Cost containment                                  |    278|
|               44803968 | Ethnicity - National Public Health Classification |    127|
|               46235654 | Primary insurance                                 |    127|
|               40766231 | Marital status                                    |    101|
|               40758030 | Language.preferred                                |     73|
|                4052017 | Religious affiliation                             |     67|
