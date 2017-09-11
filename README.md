MIMIC-OMOP
==========

Mapping the MIMIC-III database to the OMOP schema

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
- [ ] give JDBC access to collaborators with DUA, to the two above schema
- [ ] describe all MIMIC3->OMOP5.3 mapping into a spreadsheet file
- [ ] choose the ETL technology [SQL, TALEND, R, Python, other] based on mapping description experience and time remaining
- [ ] load the OMOP5.3 tables with existing data (standard concepts...)
- [ ] implement the MIMIC3->OMOP5.3 ETL and test it on the MIMIC3 subset
- [ ] ?use existing ATHENA concept-mapping to map MIMIC3 terminologies to OMOP5.3 standard concepts?
- [ ] test USAGI for mapping MIMIC3 terminologies to OMOP5.3 standard concepts
- [ ] extend USAGI for mapping MIMIC3 terminologies to OMOP5.3 standard concepts


DEADLINE
========

- January, 15th 2018

