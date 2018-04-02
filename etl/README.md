INTRODUCTION
============

Each folder corresponds to the name of an OMOP table. Inside the folder are 1-3 files:

* `etl.sql` - which inserts data into the table from the corresponding MIMIC table(s)
* `check_etl.sql` - a script which tests the ETL is correct
* `README.md` - description of the source table and details of the ETL

RUN THE ETL
===========

See the README-run-etl.md file in the root folder of this repository for details on running the ETL.

Insertion Order (infered by from schemaspy tool)
================================================

1. location
1. attribute_definition
1. concept
1. concept_class
1. vocabulary
1. domain
1. care_site
1. provider
1. person
1. visit_occurrence
1. visit_detail
1. relationship
1. cohort_definition
1. payer_plan_period
1. note
1. cohort
1. concept_synonym
1. concept_ancestor
1. condition_era
1. drug_era
1. observation_period
1. cohort_attribute
1. concept_relationship
1. cost
1. dose_era
1. fact_relationship
1. note_nlp
1. source_to_concept_map
1. death
1. drug_strength
1. specimen
1. device_exposure
1. condition_occurrence
1. drug_exposure
1. procedure_occurrence
1. measurement
1. observation
1. cdm_source
