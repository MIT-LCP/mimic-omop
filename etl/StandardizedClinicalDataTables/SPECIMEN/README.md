# Link to CommonDataModel

- [SPECIMEN](https://github.com/OHDSI/CommonDataModel/wiki/SPECIMEN)

# Principle

A specimen is linked to a measurement by the fact_relationship table and vice-versa. (relationship_id "has specimen").
Since MIMIC does not provide that level of information, they are populated with most appropriate information in order to keep OMOP philosophy.
This saves the prelevement date from chartevent (charttime VS storetime).

# Source Tables (mimic)

## [charteevents](https://mimic.physionet.org/mimictables/chartevents/)

- laboratory chartevents data generates a specimen for each result

## [labevents](https://mimic.physionet.org/mimictables/labevents/)

- laboratory data generates a specimen for each result

## [microbiologyevents](https://mimic.physionet.org/mimictables/microbiologyevents/)

- a specimen is generated for each single specimen id

