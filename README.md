MIMIC-OMOP
==========

Mapping the MIMIC-III database to the OMOP schema

[![OMOP](https://github.com/MIT-LCP/mimic-omop/blob/master/images/ohdsi.png)](https://github.com/OHDSI/CommonDataModel/wiki)

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
  - [transfers](https://mimic.physionet.org/mimictables/transfers/)
  - [service](https://mimic.physionet.org/mimictables/services/)
- [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
  - [chartevents](https://mimic.physionet.org/mimictables/chartevents/)
  - [labevents](https://mimic.physionet.org/mimictables/labevents/)
  - [microbiologyevents](https://mimic.physionet.org/mimictables/microbiologyevents/)
  - [outputevents](https://mimic.physionet.org/mimictables/outputevents/)
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
  - [inputevents_mv](https://mimic.physionet.org/mimictables/inputevents_mv/)
  - [datetimeevents](https://mimic.physionet.org/mimictables/datetimeevents/)
  - [drgcodes](https://mimic.physionet.org/mimictables/drgcodes/)
- [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
  - [prescription](https://mimic.physionet.org/mimictables/prescriptions/)
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
  - [VISIT_OCCURRENCE](etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
  - [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE)
- [transfers](https://mimic.physionet.org/mimictables/transfers/)
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
- [service](https://mimic.physionet.org/mimictables/services/)
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
- [icustays](https://mimic.physionet.org/mimictables/icustays/)
  - [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL)
- [prescription](https://mimic.physionet.org/mimictables/prescriptions/)
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
- [inputevents_cv](https://mimic.physionet.org/mimictables/inputevents_cv/)
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
- [inputevents_mv](https://mimic.physionet.org/mimictables/inputevents_mv/)
  - [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE)
  - [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION)
- [outputevents](https://mimic.physionet.org/mimictables/outputevents/)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [labevents](https://mimic.physionet.org/mimictables/labevents/)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
- [microbiologyevents](https://mimic.physionet.org/mimictables/microbiologyevents/)
  - [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT)
  - [FACT_RELATIONSHIP](etl/StandardizedClinicalDataTables/FACT_RELATIONSHIP)
- [chartevents](https://mimic.physionet.org/mimictables/chartevents/)
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


REMARKS
=======

- both MIMIC & OMOP schema do have table & columns descriptions directly into postgres
- take a look at the schemaspy website describing both
	1. [mimic](mimic/doc/schemaspy/index.html)
	1. [omop](omop/doc/schemaspy/index.html)


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
