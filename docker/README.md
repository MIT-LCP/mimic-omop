# How to

Clone the repository

You might adapt the `postgres.conf` file to your hardware. In particular the `shared_memory`.

You will have to either download the `mimicdemo` or `mimiciii` datasets, and place them in the `mimic` folder,
respectively. `data-mimicdemo` and `data-mimiciii`. Place the (gzipped for mimiciii/plain for mimicdemo) csv files 
directly in the folder.

You will also need to download from athena the vocabulary and place it in the `extras/athena` folder.

```
root
├── extras
│   ├── athena
│   │   ├── CONCEPT.csv
│   │   ├── CONCEPT_ANCESTOR.csv
│   │   ├── CONCEPT_CLASS.csv
│   │   ├── CONCEPT_CPT4.csv
│   │   ├── CONCEPT_RELATIONSHIP.csv
│   │   ├── CONCEPT_SYNONYM.csv
│   │   ├── DOMAIN.csv
│   │   ├── DRUG_STRENGTH.csv
│   │   ├── RELATIONSHIP.csv
│   │   ├── VOCABULARY.csv
│   │   ├── athena2023.zip
│   │   ├── cpt.bat
│   │   ├── cpt.sh
│   │   ├── cpt4.jar
│   │   └── readme.txt
├── mimic
│   ├── data-mimicdemo
│   │   ├── ADMISSIONS.csv
│   │   ├── CALLOUT.csv
│   │   ├── CAREGIVERS.csv
│   │   ├── CHARTEVENTS.csv
│   │   ├── CPTEVENTS.csv
│   │   ├── DATETIMEEVENTS.csv
│   │   ├── DIAGNOSES_ICD.csv
│   │   ├── DRGCODES.csv
│   │   ├── D_CPT.csv
│   │   ├── D_ICD_DIAGNOSES.csv
│   │   ├── D_ICD_PROCEDURES.csv
│   │   ├── D_ITEMS.csv
│   │   ├── D_LABITEMS.csv
│   │   ├── ICUSTAYS.csv
│   │   ├── INPUTEVENTS_CV.csv
│   │   ├── INPUTEVENTS_MV.csv
│   │   ├── LABEVENTS.csv
│   │   ├── LICENSE.txt
│   │   ├── MICROBIOLOGYEVENTS.csv
│   │   ├── NOTEEVENTS.csv
│   │   ├── OUTPUTEVENTS.csv
│   │   ├── PATIENTS.csv
│   │   ├── PRESCRIPTIONS.csv
│   │   ├── PROCEDUREEVENTS_MV.csv
│   │   ├── PROCEDURES_ICD.csv
│   │   ├── SERVICES.csv
│   │   ├── SHA256SUMS.txt
│   │   ├── TRANSFERS.csv
│   │   └── index.html
│   ├── data-mimiciii
│   │   ├── ADMISSIONS.csv.gz
│   │   ├── CALLOUT.csv.gz
│   │   ├── CAREGIVERS.csv.gz
│   │   ├── CHARTEVENTS.csv.gz
│   │   ├── CPTEVENTS.csv.gz
│   │   ├── DATETIMEEVENTS.csv.gz
│   │   ├── DIAGNOSES_ICD.csv.gz
│   │   ├── DRGCODES.csv.gz
│   │   ├── D_CPT.csv.gz
│   │   ├── D_ICD_DIAGNOSES.csv.gz
│   │   ├── D_ICD_PROCEDURES.csv.gz
│   │   ├── D_ITEMS.csv.gz
│   │   ├── D_LABITEMS.csv.gz
│   │   ├── ICUSTAYS.csv.gz
│   │   ├── INPUTEVENTS_CV.csv.gz
│   │   ├── INPUTEVENTS_MV.csv.gz
│   │   ├── LABEVENTS.csv.gz
│   │   ├── LICENSE.txt
│   │   ├── MICROBIOLOGYEVENTS.csv.gz
│   │   ├── NOTEEVENTS.csv.gz
│   │   ├── OUTPUTEVENTS.csv.gz
│   │   ├── PATIENTS.csv.gz
│   │   ├── PRESCRIPTIONS.csv.gz
│   │   ├── PROCEDUREEVENTS_MV.csv.gz
│   │   ├── PROCEDURES_ICD.csv.gz
│   │   ├── README.md
│   │   ├── SERVICES.csv.gz
│   │   ├── SHA256SUMS.txt
│   │   ├── TRANSFERS.csv.gz
│   │   └── index.html

```

Then run in the root folder:
```shell
# edit docker/.env to choose either mimiciii or mimicdemo
docker compose -f docker/docker-compose.yml build
docker compose -f docker/docker-compose.yml up
```

It should last almost two hour to build the database, and you will find the output gzipped csvs in the `etl/Result`
folder.

```
root
├── etl
│   ├── Result
│   │   ├── OMOP CDM indexes required - PostgreSQL.sql
│   │   ├── OMOP CDM postgresql ddl.txt
│   │   ├── README.md
│   │   ├── analyze.sql
│   │   ├── attribute_definition.csv.gz
│   │   ├── care_site.csv.gz
│   │   ├── cdm_source.csv.gz
│   │   ├── cohort.csv.gz
│   │   ├── cohort_attribute.csv.gz
│   │   ├── cohort_definition.csv.gz
│   │   ├── concept.csv.gz
│   │   ├── concept_ancestor.csv.gz
│   │   ├── concept_class.csv.gz
│   │   ├── concept_relationship.csv.gz
│   │   ├── concept_synonym.csv.gz
│   │   ├── condition_era.csv.gz
│   │   ├── condition_occurrence.csv.gz
│   │   ├── cost.csv.gz
│   │   ├── death.csv.gz
│   │   ├── device_exposure.csv.gz
│   │   ├── domain.csv.gz
│   │   ├── dose_era.csv.gz
│   │   ├── drug_era.csv.gz
│   │   ├── drug_exposure.csv.gz
│   │   ├── drug_strength.csv.gz
│   │   ├── fact_relationship.csv.gz
│   │   ├── import_mimic_omop.sql
│   │   ├── location.csv.gz
│   │   ├── measurement.csv.gz
│   │   ├── mimic-omop-alter.sql
│   │   ├── mimic-omop-disable-trigger.sql
│   │   ├── mimic-omop-enable-trigger.sql
│   │   ├── mimic-omop-primary.sql
│   │   ├── note.csv.gz
│   │   ├── note_nlp.csv.gz
│   │   ├── observation.csv.gz
│   │   ├── observation_period.csv.gz
│   │   ├── omop_cdm_comments.sql
│   │   ├── omop_vocab_load.sql
│   │   ├── payer_plan_period.csv.gz
│   │   ├── person.csv.gz
│   │   ├── procedure_occurrence.csv.gz
│   │   ├── provider.csv.gz
│   │   ├── relationship.csv.gz
│   │   ├── source_to_concept_map.csv.gz
│   │   ├── specimen.csv.gz
│   │   ├── visit_detail.csv.gz
│   │   ├── visit_occurrence.csv.gz
│   │   └── vocabulary.csv.gz
```
