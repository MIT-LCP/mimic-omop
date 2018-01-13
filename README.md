MIMIC-OMOP
==========

Mapping the MIMIC-III database to the OMOP schema

REMARKS
=======

- both MIMIC & OMOP schema do have table & columns descriptions directly into postgres
- take a look at the schemaspy website describing both
	1. [mimic](mimic/doc/schemaspy/index.html)
	1. [omop](omop/doc/schemaspy/index.html)

OMOP TABLES LOADED
==================

- [CARE_SITE](etl/StandardizedHealthSystemDataTables/CARE_SITE)
- [PROVIDER](etl/StandardizedHealthSystemDataTables/PROVIDER)
- [PERSON](etl/StandardizedClinicalDataTables/PERSON)
- [DEATH](etl/StandardizedClinicalDataTables/DEATH)
- [VISIT_OCCURRENCE](etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE)
- [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
- [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
- [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE)
- [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
- [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
- [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [NOTE](etl/StandardizedClinicalDataTables/NOTE)
- [COHORT_DEFINITION](etl/StandardizedDerivedElements/COHORT_DEFINITION)
- [COHORT](etl/StandardizedDerivedElements/COHORT)

MIMIC TABLES EQUIVALENCE
========================

- patients
  - [PERSON](etl/StandardizedClinicalDataTables/PERSON)
- admissions
  - [VISIT_OCCURRENCE](etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
  - [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE)
- transfers
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
- services
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
- prescriptions
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
- inputevents_cv
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
- inputevents_mv
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
- outputevents
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- labevents
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- chartevents
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
- drgcodes
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
- procedure_icd
  - [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
- procedureevents
  - [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE)
- diagnoses_icd
  - [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE)

ROADMAP
=======

- [x] create a postgresql OMOP5.3 empty instance
- [x] create a postgresql MIMIC3  subset instance (100 patients)
- [x] give JDBC access to collaborators with DUA, to the two above schema
- [ ] describe all MIMIC3->OMOP5.3 mapping into a spreadsheet file
- [x] choose the ETL technology [SQL, TALEND, R, Python, other] based on mapping description experience and time remaining
- [ ] extend omop with new columns such mimic contrib or specific icu concepts
- [ ] load the OMOP5.3 tables with existing data (standard concepts...)
- [ ] implement the MIMIC3->OMOP5.3 ETL and test it on the MIMIC3 subset
- [ ] ?use existing ATHENA concept-mapping to map MIMIC3 terminologies to OMOP5.3 standard concepts?
- [ ] test USAGI for mapping MIMIC3 terminologies to OMOP5.3 standard concepts
- [ ] extend USAGI for mapping MIMIC3 terminologies to OMOP5.3 standard concepts


DEADLINE
========

- January, 15th 2018

MEMO
=====

- raw mimic total object: 397844042
- then `mimic_id_seq` = 1397844042
