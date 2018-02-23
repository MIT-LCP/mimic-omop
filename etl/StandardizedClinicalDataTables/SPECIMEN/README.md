# Link to CommonDataModel
- [SPECIMEN](https://github.com/OHDSI/CommonDataModel/wiki/SPECIMEN)

# Remark 
The proper etl.sql file is actually in MEASUREMENT/etl.sql

# Principle

A specimen is linked to a measurement by the fact_relationship table and vice-versa. (relationship_id "has specimen").
Since MIMIC does not provide that level of information, they are populated with most appropriate information in order to keep OMOP philosophy.
- for chartevents provide two timestamp : charttime and storetime
   - charttime is the prelevement timestamp and populates specimen_datetime
   - storetime populates measurement_datetime
- for labevents and microbiologyevents, there is only one timestamp with populates specimen and measurement timestamp

# Source Tables (mimic)

## [charteevents](https://mimic.physionet.org/mimictables/chartevents/)

- laboratory chartevents data generates a specimen for each result

## [labevents](https://mimic.physionet.org/mimictables/labevents/)

- laboratory data generates a specimen for each result

## [microbiologyevents](https://mimic.physionet.org/mimictables/microbiologyevents/)

- a specimen is generated for each single specimen id

# Mapping used

## [labs_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/labs_specimen_to_concept.csv)

- it maps d_labitems.fluid to specimen_concept_id 

## [microbiology_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/microbiology_specimen_to_concept.csv)

- it maps microbiologyevents.spec_type_desc to specimen_concept_id

# Examples

## Distinct specimen_type_concept_id
``` sql
SELECT distinct specimen_type_concept_id
FROM specimen;
```

## Distinct specimen_concept_id
``` sql
SELECT distinct specimen_concept_id
FROM specimen;
```
