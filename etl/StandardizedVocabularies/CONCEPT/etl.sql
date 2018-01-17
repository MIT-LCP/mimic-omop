
ALTER TABLE omop.concept DISABLE TRIGGER ALL;
DELETE FROM omop.concept WHERE concept_id >= 200000000;
DELETE FROM omop.concept_synonym WHERE concept_id >= 200000000;
ALTER TABLE omop.concept ENABLE TRIGGER ALL;

--MIMIC-OMOP
--concept_
INSERT INTO omop.concept (
concept_id, concept_name, domain_id, vocabulary_id, concept_class_id, concept_code, valid_start_date, valid_end_date
) VALUES 
  (2000000000,'Stroke Volume Variation','Measurement','','Clinical Observation','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000001,'L/min/m2','Unit','','','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000002,'dynes.sec.cm-5/m2','Unit','','','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000003,'Output Event','Type Concept','','Meas Type','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000004,'Intravenous Bolus','Type Concept','','Drug Type','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000005,'Intravenous Continous','Type Concept','','Drug Type','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000006,'Ward and physical location','Type Concept','','Visit Type','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000007,'Labs - Culture Organisms','Type Concept','','Meas Type','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000008,'Labs - Culture Sensitivity','Type Concept','','Meas Type','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000009,'Labs - Hemato','Type Concept','','Meas Type','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000010,'Labs - Blood Gaz','Type Concept','','Meas Type','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000011,'Labs - Chemistry','Type Concept','','Meas Type','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000012,'Visit Detail','Metadata','Domain','Domain','MIMIC Generated','1979-01-01','2099-01-01')
;

-- INSERT INTO omop.concept_relationship()
-- VALUES


-- abbreviation -> concept_synonym
-- hierarchie   -> part of


--ITEMS
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, 'label:[' || coalesce(label,'') ||']dbsource:[' || coalesce(dbsource,'') || ']linksto:[' || coalesce(linksto,'') ||']unitname:[' || coalesce(unitname,'') || ']param_type:[' || coalesce(param_type,'') || ']'  as concept_name
, 'd_items'::text as domain_id
, 'MIMIC Local Codes' as vocabulary_id
, coalesce(category, '') as concept_class_id
, itemid as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM d_items;
INSERT INTO omop.concept_synonym 
(
  concept_id           
, concept_synonym_name 
, language_concept_id  
)
select
  mimic_id
, abbreviation
, 0 
from d_items
where label != abbreviation
and abbreviation is not null;


--LABS
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id -- the d_items mimic_id
, 'label:[' || coalesce(label,'') || ']fluid:[' || coalesce(fluid,'') || ']loinc:[' || coalesce(loinc_code,'') || ']' as concept_name
, 'd_labitems'::text as domain_id
, 'MIMIC Local Codes' as vocabulary_id
, coalesce(category,'') as concept_class_id -- omop Lab Test
, itemid as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM d_labitems;


-- DRUGS
-- Generates LOCAL concepts for mimic drugs
WITH tmp as 
(
select distinct
 'drug_type:['||coalesce(drug_type,'')||']'|| 'drug:['||coalesce(drug,'')||']'|| 'drug_name_poe:['||coalesce(drug_name_poe,'')||']'|| 'drug_name_generic:['||coalesce(drug_name_generic,'')||']'|| 'formulary_drug_cd:['||coalesce(formulary_drug_cd,'')||']'|| 'gsn:['||coalesce(gsn,'')||']'|| 'ndc:['||coalesce(ndc,'')||']'  as concept_name --this will be joined to the drug_exposure table
, 'prescriptions'::text as domain_id
, 'MIMIC Local Codes' as vocabulary_id
, '' as concept_class_id
, 'MIMIC Generated' as concept_code
from prescriptions
)
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
distinct on (drug, prod_strength)
  nextval('mimic_id_concept_seq') as concept_id
, concept_name
, domain_id
, vocabulary_id
, concept_class_id
,  concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM tmp;

-- PROCEDURE  -- ICD
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, coalesce(long_title,short_title) as concept_name
, 'd_icd_procedures'::text as domain_id
, 'MIMIC Local Codes' as vocabulary_id
, '4-dig billing code' as concept_class_id 
, coalesce(icd9_code,'') as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM d_icd_procedures;
INSERT INTO omop.concept_synonym 
(
  concept_id           
, concept_synonym_name 
, language_concept_id  
)
select
  mimic_id
, short_title
, 0 
from d_icd_procedures
where short_title is not null 
and long_title IS NOT NULL;


-- NOTE_NLP sections
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, label as concept_name
, 'Note Nlp'::text as domain_id
, 'MIMIC Generated' as vocabulary_id
, 'Section' as concept_class_id -- omop Lab Test
, section_id as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM gcpt_note_section_to_concept;

-- Derived values
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, measurement_source_value as concept_name
, 'Meas Value'::text as domain_id
, 'MIMIC Generated' as vocabulary_id
, 'Derived Value' as concept_class_id -- omop Lab Test
, itemid as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM gcpt_derived_to_concept;

