MIMIC-OMOP
==========

Mapping the MIMIC-III database to the OMOP schema

REMARKS
=======

- both MIMIC & OMOP schema do have table & columns descriptions directly into postgres
- take a look at the schemaspy website describing both
	1. [mimic](mimic/doc/schemaspy/index.html)
	1. [omop](omop/doc/schemaspy/index.html)

ETL DONE
========

- [CARE_SITE](etl/StandardizedHealthSystemDataTables/CARE_SITE/README.md)
- [PROVIDER](etl/StandardizedHealthSystemDataTables/PROVIDER/README.md)
- [PERSON](etl/StandardizedClinicalDataTables/PERSON/README.md)
- [DEATH](etl/StandardizedClinicalDataTables/DEATH/README.md)
- [VISIT_OCCURRENCE](etl/StandardizedClinicalDataTables/VISIT_OCCURRENCE/README.md)
- [VISIT_DETAIL](etl/StandardizedClinicalDataTables/VISIT_DETAIL/README.md)
- [PROCEDURE_OCCURRENCE](etl/StandardizedClinicalDataTables/PROCEDURE_OCCURRENCE/README.md)
- [CONDITION_OCCURRENCE](etl/StandardizedClinicalDataTables/CONDITION_OCCURRENCE/README.md)
- [OBSERVATION](etl/StandardizedClinicalDataTables/OBSERVATION/README.md)
- [DRUG_EXPOSURE](etl/StandardizedClinicalDataTables/DRUG_EXPOSURE/README.md)
- [MEASUREMENT](etl/StandardizedClinicalDataTables/MEASUREMENT/README.md)
- [COHORT_DEFINITION](etl/StandardizedDerivedElements/COHORT_DEFINITION/README.md)
- [COHORT](etl/StandardizedDerivedElements/COHORT/README.md)

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
