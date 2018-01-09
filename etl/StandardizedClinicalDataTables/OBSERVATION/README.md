# URL to CommonDataModel
- https://github.com/OHDSI/CommonDataModel/wiki/OBSERVATION

# Source Tables

## datetimeevents

- `observation_concept_id` is equal to 4085802 (Referred by nurse)

## admissions

- `observation_concept_id` is equal to 4052017  (Religious affiliation)
- `observation_concept_id` is equal to 40758030 (Language.preferred)
- `observation_concept_id` is equal to 40766231 (Marital status)
- `observation_concept_id` is equal to 44803968 (Ethnicity - National Public Health Classification)
- `observation_concept_id` is equal to 46235654 (Primary insurance)

## chartevents

- maybe some free text data from chartevents could come here soon

# Lookup Tables

- `gcpt_insurance_to_concept`
https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/insurance_to_concept.csvi

- `gcpt_ethnicity_to_concept`
https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/ethnicity_to_concept.csv

- `gcpt_religion_to_concept`
https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/religion_to_concept.csv

- `gcpt_marital_status_to_concept`
https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/marital_status_to_concept.csv

# Examples
``` sql
-- Repartition of different concept in observation table
SELECT observation_concept_id, concept_name, count(1) 
FROM observation 
JOIN concept on observation_concept_id = concept_id 
group by 1, 2 order by 3 desc;
```
 observation_concept_id |                   concept_name                    | count
------------------------+---------------------------------------------------+--------
                      0 | No matching concept                               | 160011
                4085802 | Referred by nurse                                 |  10342
                4296248 | Cost containment                                  |    278
               44803968 | Ethnicity - National Public Health Classification |    127
               46235654 | Primary insurance                                 |    127
               40766231 | Marital status                                    |    101
               40758030 | Language.preferred                                |     73
                4052017 | Religious affiliation                             |     67
