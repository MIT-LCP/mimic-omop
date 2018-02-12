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
, (2000000013,'Unwkown Ward','Visit Detail','Visit Detail','Visit_detail','MIMIC Generated','1979-01-01','2099-01-01')
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
, CASE WHEN itemid IN 
(
  225175 --See chart for initial patient assessment
, 225209 --Cash amount
, 225811 --CV - past medical history
, 225813 --Baseline pain level
, 226179 --No wallet / money
, 226180 --Sexuality / reproductive problems
, 227687 --Tobacco Use History
, 227688 --Smoking Cessation Info Offered through BIDMC Inpatient Guide
, 228236 --Insulin pump
, 225067 --Is the spokesperson the Health Care Proxy
, 225070 --Unable to assess psychological
, 225072 --Living situation
, 225074 --Any fear in relationships
, 225076 --Emotional / physical / sexual harm by partner or close relation
, 225078 --Social work consult
, 225082 --Pregnant
, 225083 --Pregnancy due date
, 225085 --Post menopausal
, 225086 --Unable to assess cognitive / perceptual
, 225087 --Visual / hearing deficit
, 225090 --Interpreter
, 225091 --Unable to assess activity / mobility
, 225092 --Self ADL
, 225094 --History of slips / falls
, 225097 --Balance
, 225099 --Judgement
, 225101 --Use of assistive devices
, 225103 --Intravenous  / IV access prior to admission
, 225105 --Unable to assess habits
, 225106 --ETOH
, 225108 --Tobacco use
, 225110 --Recreational drug use
, 225112 --Unable to assess pain
, 225113 --Currently experiencing pain
, 225117 --Unable to assess nutrition / education
, 225118 --Difficulty swallowing
, 225120 --Appetite
, 225122 --Special diet
, 225124 --Unintentional weight loss >10 lbs.
, 225126 --Dialysis patient
, 225128 --Last dialysis
, 225129 --Unable to assess teaching / learning needs
, 225131 --Teaching directed toward
, 225133 --Discharge needs
, 225135 --Consults
, 225137 --Patient valuables
, 225142 --Money given to hospital cashier
, 226719 --Last menses
, 225279 --Date of Admission to Hospital
, 225059 --Past medical history
, 916    --Allergy 1
, 927    --Allergy 2
, 935    --Allergy 3
, 925    --Marital Status
, 226381 --Marital Status
, 926    --Religion
, 226543 --Religion
) THEN 'Observation'::Text 
  ELSE 'Measurement'::Text END as domain_id
, 'MIMIC d_items' as vocabulary_id
, coalesce(category, '') as concept_class_id
, itemid::Text as concept_code
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


--	(
--		  'Visual Disturbances'
--		, 'Tremor (CIWA)'
--		, 'Strength R Leg'
--		, 'Strength R Arm'
--		, 'Strength L Leg'
--		, 'Strength L Arm'
--		, 'Riker-SAS Scale'
--		, 'Richmond-RAS Scale'
--		, 'Pressure Ulcer Stage #2'
--		, 'Pressure Ulcer Stage #1'
--		, 'PAR-Respiration'
--		, 'Paroxysmal Sweats'
--		, 'PAR-Oxygen saturation'
--		, 'PAR-Consciousness'
--		, 'PAR-Circulation'
--		, 'PAR-Activity'
--		, 'Pain Level Response'
--		, 'Pain Level'
--		, 'Nausea and Vomiting (CIWA)'
--		, 'Headache'
--		, 'Goal Richmond-RAS Scale'
--		, 'GCS - Verbal Response'
--		, 'GCS - Motor Response'
--		, 'GCS - Eye Opening'
--		, 'Braden Sensory Perception'
--		, 'Braden Nutrition'
--		, 'Braden Moisture'
--		, 'Braden Mobility'
--	)

--LABS
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id -- the d_items mimic_id
, 'label:[' || coalesce(label,'') || ']fluid:[' || coalesce(fluid,'') || ']loinc:[' || coalesce(loinc_code,'') || ']' as concept_name
, 'Measurement'::text as domain_id
, 'MIMIC d_labitems' as vocabulary_id
, coalesce(category,'') as concept_class_id -- omop Lab Test
, itemid::Text as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM d_labitems;


-- DRUGS
-- Generates LOCAL concepts for mimic drugs
WITH tmp as 
(
select 
 'drug:['||coalesce(drug,'')||']'||  'prod_strength:['||coalesce(prod_strength,'')||']'|| 'drug_type:['||coalesce(drug_type,'')||']'|| 'formulary_drug_cd:['||coalesce(formulary_drug_cd,'')||']'  as concept_name --this will be joined to the drug_exposure table
, 'prescriptions'::text as domain_id
, 'MIMIC Local Codes' as vocabulary_id
, '' as concept_class_id
, 'gsn:['||coalesce(gsn,'')||']'|| 'ndc:['||coalesce(ndc,'')||']' as concept_code
, drug_name_poe
, drug_name_generic
, drug
from prescriptions
),
"row_to_insert" as (
SELECT 
distinct on (concept_name)
  nextval('mimic_id_concept_seq') as concept_id
, concept_name
, domain_id
, vocabulary_id
, concept_class_id
, concept_code
, drug_name_poe
, drug_name_generic
, drug
FROM tmp
), 
"insert_synonym" as  (
INSERT INTO omop.concept_synonym 
(
  concept_id           
, concept_synonym_name 
, language_concept_id  
)
select
  concept_id
, drug_name_poe
, 0 
from row_to_insert
WHERE drug_name_poe is distinct from drug
and drug_name_poe is not null
UNION ALL
select
  concept_id
, drug_name_generic
, 0 
from row_to_insert
WHERE drug_name_generic is distinct from drug
and drug_name_generic is not null
)
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  concept_id
, concept_name
, domain_id
, vocabulary_id
, concept_class_id
, concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM row_to_insert;

--d_icd_procedures

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

-- NOTE_NLP mapped sections
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  nextval('mimic_id_concept_seq') as concept_id
, label_mapped as concept_name
, 'Note Nlp'::text as domain_id
,  category as vocabulary_id
, 'Section' as concept_class_id -- omop Lab Test
, 'MIMIC Generated' as concept_code
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
,  itemid as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM gcpt_derived_to_concept;

--visit_occurrence_admitting
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, admission_location as concept_name
, 'Place of Service'::text as domain_id
, 'MIMIC admissions' as vocabulary_id
, 'Place of Service' as concept_class_id 
, '' as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM gcpt_admission_location_to_concept;


--visit_occurrence_discharge
INSERT INTO omop.concept  (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
)
SELECT 
  mimic_id as concept_id
, discharge_location as concept_name
, 'Place of Service'::text as domain_id
, 'MIMIC admissions' as vocabulary_id
, 'Place of Service' as concept_class_id 
, '' as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM gcpt_discharge_location_to_concept;
