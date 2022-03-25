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

OMOP TABLES LOADED
==================

- [PERSON](etl/StandardizedClinicalDataTables/PERSON)
  - [patients](https://mimic.mit.edu/docs/iii/tables/patients/)
  - [admissions](https://mimic.mit.edu/docs/iii/tables/admissions/)
- [DEATH](etl/StandardizedClinicalDataTables/DEATH)
  - [patients](https://mimic.mit.edu/docs/iii/tables/patients/)
  - [admissions](https://mimic.mit.edu/docs/iii/tables/admissions/)
- [VISIT_OCCURRENCE](etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE)
  - [admissions](https://mimic.mit.edu/docs/iii/tables/admissions/)
- [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
  - [admissions](https://mimic.mit.edu/docs/iii/tables/admissions/)
  - [transfers](https://mimic.mit.edu/docs/iii/tables/transfers/)
  - [service](https://mimic.mit.edu/docs/iii/tables/services/)
- [SPECIMEN](etl/StandardizedClinicalDataTables/SPECIMEN)
  - [chartevents](https://mimic.mit.edu/docs/iii/tables/chartevents/)
  - [labevents](https://mimic.mit.edu/docs/iii/tables/labevents/)
  - [microbiologyevents](https://mimic.mit.edu/docs/iii/tables/microbiologyevents/)
- [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
  - [chartevents](https://mimic.mit.edu/docs/iii/tables/chartevents/)
  - [labevents](https://mimic.mit.edu/docs/iii/tables/labevents/)
  - [microbiologyevents](https://mimic.mit.edu/docs/iii/tables/microbiologyevents/)
  - [outputevents](https://mimic.mit.edu/docs/iii/tables/outputevents/)
  - [inputevents_mv](https://mimic.mit.edu/docs/iii/tables/inputevents_mv/)
- [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
  - [cptevents](https://mimic.mit.edu/docs/iii/tables/cptevents/)
  - [procedureevents_mv](https://mimic.mit.edu/docs/iii/tables/procedureevents_mv/)
  - [procedure_icd](https://mimic.mit.edu/docs/iii/tables/procedures_icd/)
- [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE)
  - [admissions](https://mimic.mit.edu/docs/iii/tables/admissions/)
  - [diagnosis_icd](https://mimic.mit.edu/docs/iii/tables/diagnoses_icd/)
- [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
  - [admissions](https://mimic.mit.edu/docs/iii/tables/admissions/)
  - [chartevents](https://mimic.mit.edu/docs/iii/tables/chartevents/)
  - [datetimeevents](https://mimic.mit.edu/docs/iii/tables/datetimeevents/)
  - [drgcodes](https://mimic.mit.edu/docs/iii/tables/drgcodes/)
- [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
  - [prescriptions](https://mimic.mit.edu/docs/iii/tables/prescriptions/)
  - [inputevents_cv](https://mimic.mit.edu/docs/iii/tables/inputevents_cv/)
  - [inputevents_mv](https://mimic.mit.edu/docs/iii/tables/inputevents_mv/)
- [NOTE](etl/StandardizedClinicalDataTables/NOTE)
  - [notevents](https://mimic.mit.edu/docs/iii/tables/noteevents/)
- [NOTE_NLP](etl/StandardizedClinicalDataTables/NOTE_NLP)
  - [notevents](https://mimic.mit.edu/docs/iii/tables/noteevents/)
- [COHORT_DEFINITION](etl/StandardizedVocabularies/COHORT_DEFINITION)
- [COHORT](etl/StandardizedDerivedElements/COHORT)
- [COHORT_ATTRIBUTE](etl/StandardizedDerivedElements//COHORT_ATTRIBUTE)
   - [callout](https://mimic.mit.edu/docs/iii/tables/callout/)
- [ATTRIBUTE_DEFINITION](etl/StandardizedVocabularies/ATTRIBUTE_DEFINITION)
- [CARE_SITE](etl/StandardizedHealthSystemDataTables/CARE_SITE)
  - [transfers](https://mimic.mit.edu/docs/iii/tables/transfers/)
  - [service](https://mimic.mit.edu/docs/iii/tables/services/)
- [PROVIDER](etl/StandardizedHealthSystemDataTables/PROVIDER)
  - [caregivers](https://mimic.mit.edu/docs/iii/tables/caregivers/)

[![MIMIC](https://github.com/MIT-LCP/mimic-omop/blob/master/images/mimic.png)](https://mimic.physionet.org/)

MIMIC TABLES EQUIVALENCE
========================

- [patients](https://mimic.mit.edu/docs/iii/tables/patients/)
  - [PERSON](etl/StandardizedClinicalDataTables/PERSON)
  - [DEATH](etl/StandardizedClinicalDataTables/DEATH)
- [admissions](https://mimic.mit.edu/docs/iii/tables/admissions/)
  - [PERSON](etl/StandardizedClinicalDataTables/PERSON)
  - [DEATH](etl/StandardizedClinicalDataTables/DEATH)
  - [VISIT_OCCURRENCE](etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE)
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
  - [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE)
- [transfers](https://mimic.mit.edu/docs/iii/tables/transfers/)
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
- [icustays](https://mimic.mit.edu/docs/iii/tables/icustays/)
  - The ICUSTAYS table is fully derived from the transfers table
- [service](https://mimic.mit.edu/docs/iii/tables/services/)
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
- [prescriptions](https://mimic.mit.edu/docs/iii/tables/prescriptions/)
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
- [inputevents_cv](https://mimic.mit.edu/docs/iii/tables/inputevents_cv/)
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
- [inputevents_mv](https://mimic.mit.edu/docs/iii/tables/inputevents_mv/)
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [outputevents](https://mimic.mit.edu/docs/iii/tables/outputevents/)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [labevents](https://mimic.mit.edu/docs/iii/tables/labevents/)
  - [SPECIMEN](etl/StandardizedClinicalDataTables/SPECIMEN)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [microbiologyevents](https://mimic.mit.edu/docs/iii/tables/microbiologyevents/)
  - [SPECIMEN](etl/StandardizedClinicalDataTables/SPECIMEN)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [chartevents](https://mimic.mit.edu/docs/iii/tables/chartevents/)
  - [SPECIMEN](etl/StandardizedClinicalDataTables/SPECIMEN)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
- [drgcodes](https://mimic.mit.edu/docs/iii/tables/drgcodes/)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
- [datetimeevents](https://mimic.mit.edu/docs/iii/tables/datetimeevents/)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
- [procedure_icd](https://mimic.mit.edu/docs/iii/tables/procedures_icd/)
  - [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
- [procedureevents_mv](https://mimic.mit.edu/docs/iii/tables/procedureevents_mv/)
  - [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
- [cptevents](https://mimic.mit.edu/docs/iii/tables/cptevents/)
  - [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
- [diagnosis_icd](https://mimic.mit.edu/docs/iii/tables/diagnoses_icd/)
  - [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE)
- [notevents](https://mimic.mit.edu/docs/iii/tables/noteevents/)
  - [NOTE](etl/StandardizedClinicalDataTables/NOTE)
  - [NOTE_NLP](etl/StandardizedClinicalDataTables/NOTE_NLP)
- [caregivers](https://mimic.mit.edu/docs/iii/tables/caregivers/)
  - [PROVIDER](etl/StandardizedHealthSystemDataTables/PROVIDER)
- [callout](https://mimic.mit.edu/docs/iii/tables/callout/)
  - [COHORT_ATTRIBUTES](etl/StandardizedDerivedElements/COHORT_ATTRIBUTE)


