
---- should be 0 for that code,
---- and units push inside source_concept_id
ALTER TABLE omop.concept DISABLE TRIGGER ALL;
DELETE FROM omop.concept WHERE concept_id >= 200000000;
ALTER TABLE omop.concept ENABLE TRIGGER ALL;

--MIMIC-OMOP
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) VALUES 
  (2000000000,'Stroke Volume Variation','Measurement','MIMIC Generated','Clinical Observation','','1979-01-01','2099-01-01')
, (2000000001,'L/min/m2','Unit','MIMIC Generated','','','1979-01-01','2099-01-01')
, (2000000002,'dynes.sec.cm-5/m2','Unit','MIMIC Generated','','','1979-01-01','2099-01-01')
, (2000000003,'Output Event','Type Concept','MIMIC Generated','Meas Type','','1979-01-01','2099-01-01')
, (2000000004,'Intravenous Bolus','Type Concept','MIMIC Generated','Drug Type','','1979-01-01','2099-01-01')
, (2000000005,'Intravenous Continous','Type Concept','MIMIC Generated','Drug Type','','1979-01-01','2099-01-01')
, (2000000006,'Ward and physical location','Type Concept','MIMIC Generated','Visit Type','','1979-01-01','2099-01-01')
, (2000000007,'Labs - Culture Organisms','Type Concept','MIMIC Generated','Meas Type','','1979-01-01','2099-01-01')
, (2000000008,'Labs - Culture Sensitivity','Type Concept','MIMIC Generated','Meas Type','','1979-01-01','2099-01-01')
, (2000000009,'Labs - Hemato','Type Concept','MIMIC Generated','Meas Type','','1979-01-01','2099-01-01')
, (2000000010,'Labs - Blood Gaz','Type Concept','MIMIC Generated','Meas Type','','1979-01-01','2099-01-01')
, (2000000011,'Labs - Chemistry','Type Concept','MIMIC Generated','Meas Type','','1979-01-01','2099-01-01')

;

-- INSERT INTO omop.concept_relationship()
-- VALUES
-- ();
--
-- abbreviation -> concept_synonym
-- hierarchie   -> part of
--

--ITEMS
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, coalesce(label, 'UNKNOWN') as concept_name
, 'Measurement'::text as domain_id
, 'MIMIC Generated' as vocabulary_id
, dbsource || ' ' ||coalesce(category, '') as concept_class_id
, itemid as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM d_items;

--LABS
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, coalesce(label || '[' || fluid || '][' || category || ']', 'UNKNOWN') as concept_name
, 'Measurement'::text as domain_id
, 'MIMIC Generated' as vocabulary_id
, 'Lab Test' as concept_class_id -- omop Lab Test
, itemid as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM d_labitems;

-- DRUGS
-- Generates LOCAL concepts for mimic drugs
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
distinct on (drug, prod_strength)
  nextval('mimic_id_concept_seq') as concept_id
, trim(drug || ' ' || prod_strength) as concept_name
, 'Drug'::text as domain_id
, 'MIMIC Generated' as vocabulary_id
, drug_type as concept_class_id
, coalesce(ndc,'') as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM prescriptions 
WHERE trim(drug || ' ' || prod_strength) IS NOT NULL;

-- PROCEDURE  -- CPT4
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, procedure_source_value as concept_name
, 'Procedure'::text as domain_id
, 'MIMIC Generated' as vocabulary_id
, 'CPT4' as concept_class_id -- omop Lab Test
, '' as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM gcpt_cpt4_to_concept;

-- PROCEDURE  -- ICD
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, coalesce(long_title,short_title) as concept_name
, 'Procedure'::text as domain_id
, 'MIMIC ICD9Proc' as vocabulary_id
, '4-dig billing code' as concept_class_id -- omop Lab Test
, icd9_code as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM d_icd_procedures;


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




--ACTUALLY NO NEED
-- categories are going to value_source_value; when mapped they will be in value_as_concept_id
-- itemid are in measurement_source_concept_id
-- label are in measurement_source_value
---- TEXTUAL BUT DISCRETE LABS 
--
--INSERT INTO omop.concept (
--concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
--) 
--SELECT 
--distinct on (c.value)
--  nextval('mimic_id_concept_seq') as concept_id
--, c.value as concept_name
--, 'Measurement'::text as domain_id
--, 'MIMIC d_items textual discrete' as vocabulary_id
--, label as concept_class_id -- omop Lab Test
--, itemid as concept_code
--, '1979-01-01' as valid_start_date
--, '2099-01-01' as valid_end_date
--FROM chartevents c
--join d_items using (itemid)
--where 
--c.value is not null
--and param_type= 'Text'
--and label IN 
--(
--  'Visual Disturbances'
--, 'Tremor (CIWA)'
--, 'Strength R Leg'
--, 'Strength R Arm'
--, 'Strength L Leg'
--, 'Strength L Arm'
--, 'Riker-SAS Scale'
--, 'Richmond-RAS Scale'
--, 'Pressure Ulcer Stage #2'
--, 'Pressure Ulcer Stage #1'
--, 'PAR-Respiration'
--, 'Paroxysmal Sweats'
--, 'PAR-Oxygen saturation'
--, 'PAR-Consciousness'
--, 'PAR-Circulation'
--, 'PAR-Activity'
--, 'Pain Level Response'
--, 'Pain Level'
--, 'Nausea and Vomiting (CIWA)'
--, 'Headache'
--, 'Goal Richmond-RAS Scale'
--, 'GCS - Verbal Response'
--, 'GCS - Motor Response'
--, 'GCS - Eye Opening'
--, 'Braden Sensory Perception'
--, 'Braden Nutrition'
--, 'Braden Moisture'
--, 'Braden Mobility'
--, 'Braden Friction/Shear'
--, 'Braden Activity'
--, 'Anxiety'
--, 'Agitation'
--);




