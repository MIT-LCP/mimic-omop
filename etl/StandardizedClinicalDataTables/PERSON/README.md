# Source Tables

## `mimic.patients`

- information about death are mooved to `omop.death` table

## `mimic.admissions`

- the ethicity comes from admissions, the first recorded value is put in the omop.person table 

# Lookup Tables

## `gcpt_ethnicity_to_concept`

- this maps the mimic ethnicity to omop ethnicity
- this has been made by google
