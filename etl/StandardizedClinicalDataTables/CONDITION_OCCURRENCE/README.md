# Source Tables

## diagnosis_icd

- omop standard code is SNOMED
- omoo provides a mapping from icd9 to SNOMED
- all icd9 codes are found into omop
- however not all SNOMED codes are mapped to icd9
- then both concept_id and source_concept_id are stored
- when concept_id = 0 then the coding can be found from icd9 code in source_concept_id column
- rows with null icd9 code are removed from the table
- google mention some codes are not condition but observation or procedure. Not sure to understand 
- because snomed-icd9 mapping produces multiple snomed code for one icd9, OMOP spec says we should duplicate rows in the table. The main concern is how to generate condition_occurrence_id and should be adressed elegantly soon

## admissions

- the chief complaint admissions diagnosis column
- when `condition_type_concept_id` = 42894222

# Lookup Tables

## gcpt_seq_num_to_concept

- sequence the condition
- there is no beyond 20

## gcpt_admissions_diagnosis_to_concept

- free text have been mapped manually from @aparrot
- it represent 50% of admissions diagnosis mapped
- a manual a and collaborativ method should be done for the other unmapped code
