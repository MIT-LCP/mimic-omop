# URL to CommonDataModel
- [CONDITION_OCCURRENCE](https://github.com/OHDSI/CommonDataModel/wiki/CONDITION_OCCURRENCE)

# Source Tables

## [diagnosis_icd](https://mimic.physionet.org/mimictables/diagnoses_icd/)
- omop standard code is SNOMED
- omop provides a mapping from icd9 to SNOMED
- all icd9 codes are found into omop
- however not all SNOMED codes are mapped to icd9
- then both `concept_id` and `source_concept_id` are stored
- when concept_id = 0 then the coding can be found from icd9 code in `source_concept_id` column
- rows with null icd9 code are removed from the table
- google mention some codes are not condition but observation or procedure. Not sure to understand 
- because snomed-icd9 mapping produces multiple snomed code for one icd9, OMOP spec says we should duplicate rows in the table. The main concern is how to generate `condition_occurrence_id` and should be adressed elegantly soon

## [admissions](https://mimic.physionet.org/mimictables/admissions/)

- the chief complaint admissions diagnosis column
- when `condition_type_concept_id` = 42894222

- Warning : only diagnoses that occur >= 10 times are mapped (= 31102 admissions)
- Warning : one diagnosis in admissions.diagnosis may be mapped >= 2 concept.concept_id 

# Mapping used

## [seq_num_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/seq_num_to_concept.csv)

- sequence the condition
- there is no beyond 20

## [admissions_diagnosis_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/admissions_diagnosis_to_concept.csv)

- free text have been mapped manually from @aparrot
- it represent 50% of admissions diagnosis mapped
- a manual a and collaborativ method should be done for the other unmapped code

# Example

## explanation of the `visit_type_concept_id`

``` sql
SELECT concept_name, concept_id, count(1)
FROM condition_occurrence
JOIN concept
ON condition_type_concept_id = concept_id
GROUP BY concept_name, concept_id ORDER BY count(1) desc;
```

## Repartition diagnosis of the admissions

```sql
SELECT concept_name, concept_id, count(1)
FROM condition_occurrence
JOIN concept
ON condition_concept_id = concept_id
WHERE condition_type_concept_id = 42894222                   -- concept.concept_name = 'EHR Chief Compliant'
GROUP BY concept_name, concept_id ORDER BY count(1) desc limit 10;
```

##  Repartition main diagnosis at the discharge

```sql
SELECT concept_name, concept_id, count(1)
FROM condition_occurrence
JOIN concept
ON condition_concept_id = concept_id
WHERE condition_type_concept_id = 38000184                   -- concept.concept_name = 'Inpatient detail - 1st position'
GROUP BY concept_name, concept_id ORDER BY count(1) desc limit 10;
```
