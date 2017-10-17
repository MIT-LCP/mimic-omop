# Data loaded

```
SELECT count(1), vocabulary_id FROM omop.concept group BY vocabulary_id ORDER BY count DESC;
  count  |  vocabulary_id   
---------+------------------
 1650444 | RxNorm Extension
  785712 | SNOMED
  679882 | NDC
  278569 | RxNorm
  168506 | SPL
  135899 | LOINC
  108971 | ICD10CM
   37411 | NDFRT
   18672 | ICD9CM
    7830 | HCPCS
    6129 | ATC
    4657 | ICD9Proc
     972 | UCUM
     829 | NUCC
     538 | Revenue Code
     486 | VA Class
     426 | Relationship
     300 | Concept Class
     180 | Currency
     111 | Specialty
     100 | Condition Type
      95 | Procedure Type
      89 | ABMS
      82 | Vocabulary
      59 | Place of Service
      55 | Domain
      53 | Race
      14 | Drug Type
      14 | Death Type
      13 | Observation Type
      10 | Note Type
       6 | Meas Type
       6 | Obs Period Type
       5 | Gender
       5 | Visit
       3 | Device Type
       3 | Cost Type
       3 | Visit Type
       2 | Ethnicity
       1 | Specimen Type
       1 | None
(41 lignes)

```
