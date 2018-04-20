gzip -dck etl/Result/drug_exposure.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.drug_exposure  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - 
gzip -dck etl/Result/person.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.person  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/cohort.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.cohort  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/observation_period.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.observation_period  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/location.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.location  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/cohort_definition.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.cohort_definition  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/specimen.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.specimen  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/death.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.death  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/visit_detail.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.visit_detail  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/procedure_occurrence.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.procedure_occurrence  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/condition_occurrence.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.condition_occurrence  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/note.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.note  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/care_site.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.care_site  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/provider.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.provider  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/observation.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.observation  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/source_to_concept_map.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.source_to_concept_map  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/cohort_attribute.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.cohort_attribute  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/concept_class.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.concept_class  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/drug_era.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.drug_era  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/condition_era.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.condition_era  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/cost.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.cost  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/device_exposure.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.device_exposure FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/visit_occurrence.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.visit_occurrence  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/concept.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.concept  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " -  &&
gzip -dck etl/Result/attribute_definition.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.attribute_definition  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/cdm_source.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.cdm_source   FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/vocabulary.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.vocabulary  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/note_nlp.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.note_nlp  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - 
#gzip -dck etl/Result/dose_era.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.dose_era  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/payer_plan_period.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.payer_plan_period  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/domain.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.domain  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/concept_relationship.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.concept_relationship  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/fact_relationship.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.fact_relationship  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/relationship.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.relationship  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/concept_synonym.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.concept_synonym  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/concept_ancestor.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.concept_ancestor  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/drug_strength.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.drug_strength  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - &&
gzip -dck etl/Result/measurement.csv.gz | sed 1d | mclient -d mimic-omop -s "COPY INTO omop.measurement  FROM STDIN USING DELIMITERS '|','\n','\"' NULL AS '' " - 
