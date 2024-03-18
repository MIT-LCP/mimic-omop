MIMIC-OMOP
==========

This repository contains an Extract-Transform-Load (ETL) process for mapping the [MIMIC-III database](mimic.physionet.org) to the [OMOP Common Data Model](https://github.com/OHDSI/CommonDataModel). This process involves both transforming the structure of the database (i.e. the relational schema), but also standardizing the many concepts in the MIMIC-III database to a standard vocabulary (primarily the [Athena Vocabulary](https://www.ohdsi.org/analytic-tools/athena-standardized-vocabularies/), which you can explore [here](athena.ohdsi.org)).

DOCUMENTATION
===============

- [Resources](https://mit-lcp.github.io/mimic-omop/)
    - [Achilles](https://mit-lcp.github.io/mimic-omop/AchillesWeb)
    - [OMOP Data Model](https://mit-lcp.github.io/mimic-omop/schemaspy-omop)
    - [MIMIC Data Model](https://mit-lcp.github.io/mimic-omop/schemaspy-mimic)

"WHERE IS ..."
===================================================

Below in the README, we provide two sections. The first section, *OMOP TABLES LOADED*, lists the OMOP tables which have been populated from MIMIC-III. You can use this section to figure out what data generated each OMOP TABLE. For example, we can see that the OMOP CDM table *person* was populated using data from the *patients* and *admissions* table in MIMIC-III.

The second section, *MIMIC TABLES EQUIVALENCE*, lists all the tables in MIMIC-III, and shows where the data now exists in the OMOP CDM. For example, we can see that the MIMIC-III table *patients* was used to populate the OMOP CDM tables *person* and *death*.

INSTALLATION INSTRUCTIONS
=========================

- [Manual](./README-run-etl.md)
- [Docker-compose](./docker/README.md)

OMOP TABLES LOADED
==================

- [PERSON](etl/StandardizedClinicalDataTables/PERSON)
  - [patients](https://mimic.physionet.org/mimictables/patients/)
  - [admissions](https://mimic.physionet.org/mimictables/admissions/)
- [DEATH](etl/StandardizedClinicalDataTables/DEATH)
  - [patients](https://mimic.physionet.org/mimictables/patients/)
  - [admissions](https://mimic.physionet.org/mimictables/admissions/)
- [VISIT_OCCURRENCE](etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE)
  - [admissions](https://mimic.physionet.org/mimictables/admissions/)
- [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
  - [admissions](https://mimic.physionet.org/mimictables/admissions/)
  - [transfers](https://mimic.physionet.org/mimictables/transfers/)
  - [service](https://mimic.physionet.org/mimictables/services/)
- [SPECIMEN](etl/StandardizedClinicalDataTables/SPECIMEN)
  - [chartevents](https://mimic.physionet.org/mimictables/chartevents/)
  - [labevents](https://mimic.physionet.org/mimictables/labevents/)
  - [microbiologyevents](https://mimic.physionet.org/mimictables/microbiologyevents/)
- [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
  - [chartevents](https://mimic.physionet.org/mimictables/chartevents/)
  - [labevents](https://mimic.physionet.org/mimictables/labevents/)
  - [microbiologyevents](https://mimic.physionet.org/mimictables/microbiologyevents/)
  - [outputevents](https://mimic.physionet.org/mimictables/outputevents/)
  - [inputevents_mv](https://mimic.physionet.org/mimictables/inputevents_mv/)
- [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
  - [cptevents](https://mimic.physionet.org/mimictables/cptevents/)
  - [procedureevents_mv](https://mimic.physionet.org/mimictables/procedureevents_mv/)
  - [procedure_icd](https://mimic.physionet.org/mimictables/procedures_icd/)
- [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE)
  - [admissions](https://mimic.physionet.org/mimictables/admissions/)
  - [diagnosis_icd](https://mimic.physionet.org/mimictables/diagnoses_icd/)
- [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
  - [admissions](https://mimic.physionet.org/mimictables/admissions/)
  - [chartevents](https://mimic.physionet.org/mimictables/chartevents/)
  - [datetimeevents](https://mimic.physionet.org/mimictables/datetimeevents/)
  - [drgcodes](https://mimic.physionet.org/mimictables/drgcodes/)
- [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
  - [prescriptions](https://mimic.physionet.org/mimictables/prescriptions/)
  - [inputevents_cv](https://mimic.physionet.org/mimictables/inputevents_cv/)
  - [inputevents_mv](https://mimic.physionet.org/mimictables/inputevents_mv/)
- [NOTE](etl/StandardizedClinicalDataTables/NOTE)
  - [notevents](https://mimic.physionet.org/mimictables/noteevents/)
- [NOTE_NLP](etl/StandardizedClinicalDataTables/NOTE_NLP)
  - [notevents](https://mimic.physionet.org/mimictables/noteevents/)
- [COHORT_DEFINITION](etl/StandardizedVocabularies/COHORT_DEFINITION)
- [COHORT](etl/StandardizedDerivedElements/COHORT)
- [COHORT_ATTRIBUTE](etl/StandardizedDerivedElements//COHORT_ATTRIBUTE)
   - [callout](https://mimic.physionet.org/mimictables/callout/)
- [ATTRIBUTE_DEFINITION](etl/StandardizedVocabularies/ATTRIBUTE_DEFINITION)
- [CARE_SITE](etl/StandardizedHealthSystemDataTables/CARE_SITE)
  - [transfers](https://mimic.physionet.org/mimictables/transfers/)
  - [service](https://mimic.physionet.org/mimictables/services/)
- [PROVIDER](etl/StandardizedHealthSystemDataTables/PROVIDER)
  - [caregivers](https://mimic.physionet.org/mimictables/caregivers/)

[![MIMIC](https://github.com/MIT-LCP/mimic-omop/blob/master/images/mimic.png)](https://mimic.physionet.org/)

MIMIC TABLES EQUIVALENCE
========================

- [patients](https://mimic.physionet.org/mimictables/patients/)
  - [PERSON](etl/StandardizedClinicalDataTables/PERSON)
  - [DEATH](etl/StandardizedClinicalDataTables/DEATH)
- [admissions](https://mimic.physionet.org/mimictables/admissions/)
  - [PERSON](etl/StandardizedClinicalDataTables/PERSON)
  - [DEATH](etl/StandardizedClinicalDataTables/DEATH)
  - [VISIT_OCCURRENCE](etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE)
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
  - [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE)
- [transfers](https://mimic.physionet.org/mimictables/transfers/)
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
- [icustays](https://mimic.physionet.org/mimictables/icustays/)
  - The ICUSTAYS table is fully derived from the transfers table
- [service](https://mimic.physionet.org/mimictables/services/)
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
- [prescriptions](https://mimic.physionet.org/mimictables/prescriptions/)
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
- [inputevents_cv](https://mimic.physionet.org/mimictables/inputevents_cv/)
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
- [inputevents_mv](https://mimic.physionet.org/mimictables/inputevents_mv/)
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [outputevents](https://mimic.physionet.org/mimictables/outputevents/)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [labevents](https://mimic.physionet.org/mimictables/labevents/)
  - [SPECIMEN](etl/StandardizedClinicalDataTables/SPECIMEN)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [microbiologyevents](https://mimic.physionet.org/mimictables/microbiologyevents/)
  - [SPECIMEN](etl/StandardizedClinicalDataTables/SPECIMEN)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [chartevents](https://mimic.physionet.org/mimictables/chartevents/)
  - [SPECIMEN](etl/StandardizedClinicalDataTables/SPECIMEN)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
- [drgcodes](https://mimic.physionet.org/mimictables/drgcodes/)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
- [datetimeevents](https://mimic.physionet.org/mimictables/datetimeevents/)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
- [procedure_icd](https://mimic.physionet.org/mimictables/procedures_icd/)
  - [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
- [procedureevents_mv](https://mimic.physionet.org/mimictables/procedureevents_mv/)
  - [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
- [cptevents](https://mimic.physionet.org/mimictables/cptevents/)
  - [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
- [diagnosis_icd](https://mimic.physionet.org/mimictables/diagnoses_icd/)
  - [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE)
- [notevents](https://mimic.physionet.org/mimictables/noteevents/)
  - [NOTE](etl/StandardizedClinicalDataTables/NOTE)
  - [NOTE_NLP](etl/StandardizedClinicalDataTables/NOTE_NLP)
- [caregivers](https://mimic.physionet.org/mimictables/caregivers/)
  - [PROVIDER](etl/StandardizedHealthSystemDataTables/PROVIDER)
- [callout](https://mimic.physionet.org/mimictables/callout/)
  - [COHORT_ATTRIBUTES](etl/StandardizedDerivedElements/COHORT_ATTRIBUTE)


