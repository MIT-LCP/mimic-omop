# URL to CommonDataModel
- [CONDITION_OCCURRENCE](https://github.com/OHDSI/CommonDataModel/wiki/CONDITION_OCCURRENCE)

# Source Tables

## [diagnosis_icd](https://mimic.physionet.org/mimictables/diagnoses_icd/)
- omop standard code is SNOMED
- omoo provides a mapping from icd9 to SNOMED
- all icd9 codes are found into omop
- however not all SNOMED codes are mapped to icd9
- then both concept_id and source_concept_id are stored
- when concept_id = 0 then the coding can be found from icd9 code in source_concept_id column
- rows with null icd9 code are removed from the table
- google mention some codes are not condition but observation or procedure. Not sure to understand 
- because snomed-icd9 mapping produces multiple snomed code for one icd9, OMOP spec says we should duplicate rows in the table. The main concern is how to generate condition_occurrence_id and should be adressed elegantly soon

## [admissions](https://mimic.physionet.org/mimictables/admissions/)

- the chief complaint admissions diagnosis column
- when `condition_type_concept_id` = 42894222

- Warning : only diagnoses that occur >= 10 times are mapped (= 31102 admissions)
- Warning : one diagnosis in admissions.diagnosis may be mapped >= 2 concept.concept_id 

# Lookup Tables

## gcpt_seq_num_to_concept

- sequence the condition
- there is no beyond 20

## gcpt_admissions_diagnosis_to_concept

- free text have been mapped manually from @aparrot
- it represent 50% of admissions diagnosis mapped
- a manual a and collaborativ method should be done for the other unmapped code

# Example
``` sql
-- explanation of the visit_type_concept_id
SELECT concept_name, concept_id, count(1)
FROM condition_occurrence
JOIN concept
ON condition_type_concept_id = concept_id
GROUP BY concept_name, concept_id ORDER BY count(1) desc;
```
           concept_name           | concept_id | count
----------------------------------+------------+-------
 EHR Chief Complaint              |   42894222 |   156
 Inpatient detail - 1st position  |   38000184 |   127
 Inpatient detail - 2nd position  |   38000185 |   125
 Inpatient detail - 3rd position  |   38000186 |   124
 Inpatient detail - 4th position  |   38000187 |   116
 Inpatient detail - 5th position  |   38000188 |   109
 Inpatient detail - 20th position |   44818713 |   103
 Inpatient detail - 6th position  |   38000189 |   103
 Inpatient detail - 7th position  |   38000190 |    95
 Inpatient detail - 8th position  |   38000191 |    88
 Inpatient detail - 9th position  |   38000192 |    75
 Inpatient detail - 10th position |   38000193 |    57
 Inpatient detail - 11th position |   38000194 |    51
 Inpatient detail - 12th position |   38000195 |    40
 Inpatient detail - 13th position |   38000196 |    34
 Inpatient detail - 14th position |   38000197 |    31
 Inpatient detail - 15th position |   38000198 |    27
 Inpatient detail - 16th position |   44818709 |    23
 Inpatient detail - 17th position |   44818710 |    22
 Inpatient detail - 18th position |   44818711 |    19
 Inpatient detail - 19th position |   44818712 |    18

```sql
-- Repartition diagnosis of the admissions
SELECT concept_name, concept_id, count(1)
FROM condition_occurrence
JOIN concept
ON condition_concept_id = concept_id
WHERE condition_type_concept_id = 42894222                   -- concept.concept_name = 'EHR Chief Compliant'
GROUP BY concept_name, concept_id ORDER BY count(1) desc limit 10;
```

```sql
-- Repartition main diagnosis at the discharge
SELECT concept_name, concept_id, count(1)
FROM condition_occurrence
JOIN concept
ON condition_concept_id = concept_id
WHERE condition_type_concept_id = 38000184                   -- concept.concept_name = 'Inpatient detail - 1st position'
GROUP BY concept_name, concept_id ORDER BY count(1) desc limit 10;
```
