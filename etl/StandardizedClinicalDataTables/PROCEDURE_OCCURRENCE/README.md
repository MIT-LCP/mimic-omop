# Source Tables

## ̀`mimic.procedure_icd`

- `procedure_type_concept_id` = 38003622 (Procedure recorded as diagnostic code)
- the ICD9 codes are transformed to match to omop.concept
- mimic.sequence column is lost in the process
- the procedure date is the admission end date

## ̀`mimic.procedureevents_mv`

- `procedure_type_concept_id` = 38000275 (EHR order list entry)
- code are mapped to SNOMED procedure
- the datetime is the begining of the procedure
- quantity is the duration of the procedure in minutes
- rows cancelled have not been exported from mimic
- visit_detail_id is assigned 

## ̀`mimic.cptevents`

- `procedure_type_concept_id` = 257 ("Hospitalization Cost Record")
- the procedure date is the chardate when absent substitued with admission start date

# Lookup Tables

## `cpt4_to_concept`

- it maps CPT4 codes to information in the `mimic.cpteevents` table
- `\copy (SELECT distinct '[' || coalesce(costcenter,'') || '][' || coalesce(sectionheader,'') || '] ' || subsectionheader || ' ' || coalesce(description, '') as procedure_source_value FROM mimic.cptevents  order by 1) TO '/tmp/cpt4_to_concept.csv' CSV HEADER QUOTE '"';`
- all the relevant information have been collapsed into `procedure_source_value` field
- the mapping to cpt4 is done manually. When not relevant the field `omop_mapping_is_sure` is equal to 0

## `procedure_to_concept`

- it maps SNOMED codes to itemid in the `mimic.procedureevents_mv` table
- No idea how the mapping was made by google
