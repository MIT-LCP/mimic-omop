-- LABS FROM labevents
TRUNCATE omop.measurement;
TRUNCATE omop.fact_relationship;
WITH 
"labevents" AS (SELECT mimic_id as measurement_id, subject_id, charttime as measurement_datetime, hadm_id , itemid, valueuom as unit_source_value, value as value_source_value, substring(value,'^(<=|>=|<|>)') as operator_name,
	    CASE WHEN trim(value) ~ '^(>=|<=|>|<){0,1}[+-]*([.,]{1}[0-9]+|[0-9]+[,.]{0,1}[0-9]*)$' 
                THEN regexp_replace(regexp_replace(trim(value),'[^0-9+-.]*([+-]*[0-9.,]+)', E'\\1','g'),'([0-9]+)([,]+)([0-9]*)',E'\\1.\\3','g')::double precision 
        ELSE null::double precision END as value_as_number
	FROM mimic.labevents),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM mimic.patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM mimic.admissions),
"d_labitems" AS (SELECT itemid, label FROM mimic.d_labitems),
"gcpt_lab_label_to_concept" AS (SELECT label, concept_id as measurement_concept_id FROM mimic.gcpt_lab_label_to_concept),
"omop_loinc" AS (SELECT concept_id AS measurement_concept_id, concept_code as label FROM omop.concept WHERE vocabulary_id = 'LOINC' AND domain_id = 'Measurement'),
"omop_operator" AS (SELECT concept_name as operator_name, concept_id as operator_concept_id FROM omop.concept WHERE  domain_id ilike 'Meas Value Operator'),
"gcpt_lab_unit_to_concept" AS (SELECT unit as unit_source_value, concept_id as unit_concept_id FROM mimic.gcpt_lab_unit_to_concept)
INSERT INTO omop.measurement
SELECT
  labevents.measurement_id                 
, patients.person_id                     
, coalesce(omop_loinc.measurement_concept_id, gcpt_lab_label_to_concept.measurement_concept_id, 0) as measurement_concept_id     
, labevents.measurement_datetime::date AS measurement_date              
, labevents.measurement_datetime AS measurement_datetime          
, 44818702 AS measurement_type_concept_id -- Lab result
, operator_concept_id AS operator_concept_id -- = operator
, labevents.value_as_number AS value_as_number               
, null::bigint AS value_as_concept_id           
, gcpt_lab_unit_to_concept.unit_concept_id               
, null::double precision AS range_low                     
, null::double precision AS range_high                    
, null::bigint AS provider_id                   
, admissions.visit_occurrence_id AS visit_occurrence_id           
, null::bigint As visit_detail_id               
, d_labitems.label AS measurement_source_value      
, null::bigint AS measurement_source_concept_id 
, gcpt_lab_unit_to_concept.unit_source_value             
, labevents.value_source_value            
, null::bigint AS quality_concept_id            
FROM labevents
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN d_labitems USING (itemid)
LEFT JOIN omop_loinc USING (label)
LEFT JOIN omop_operator USING (operator_name)
LEFT JOIN gcpt_lab_label_to_concept USING (label)
LEFT JOIN gcpt_lab_unit_to_concept USING (unit_source_value);

-- LABS from chartevents
WITH
"chartevents_lab" AS ( SELECT chartevents.itemid, chartevents.mimic_id as measurement_id , subject_id , hadm_id ,charttime as measurement_datetime,  value as value_source_value , substring(value,'^(<=|>=|<|>)') as operator_name , CASE WHEN trim(value) ~ '^(>=|<=|>|<){0,1}[+-]*([.,]{1}[0-9]+|[0-9]+[,.]{0,1}[0-9]*)$' THEN regexp_replace(regexp_replace(trim(value),'[^0-9+-.]*([+-]*[0-9.,]+)', E'\\1','g'),'([0-9]+)([,]+)([0-9]*)',E'\\1.\\3','g')::double precision ELSE null::double precision END as value_as_number , valueuom AS unit_source_value FROM mimic.chartevents JOIN mimic.d_items ON (d_items.itemid=chartevents.itemid AND category = 'Labs')),
"d_items" AS (SELECT itemid, label FROM mimic.d_items),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM mimic.patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM mimic.admissions),
"omop_operator" AS (SELECT concept_name as operator_name, concept_id as operator_concept_id FROM omop.concept WHERE  domain_id ilike 'Meas Value Operator'),
"omop_loinc" AS (SELECT concept_id AS measurement_concept_id, concept_code as label FROM omop.concept WHERE vocabulary_id = 'LOINC' AND domain_id = 'Measurement'),
"gcpt_lab_label_to_concept" AS (SELECT label, concept_id as measurement_concept_id FROM mimic.gcpt_lab_label_to_concept),
"gcpt_lab_unit_to_concept" AS (SELECT unit as unit_source_value, concept_id as unit_concept_id FROM mimic.gcpt_lab_unit_to_concept)
INSERT INTO omop.measurement
SELECT 
  chartevents_lab.measurement_id                 
, patients.person_id                     
, coalesce(omop_loinc.measurement_concept_id, gcpt_lab_label_to_concept.measurement_concept_id, 0) as measurement_concept_id     
, chartevents_lab.measurement_datetime::date AS measurement_date              
, chartevents_lab.measurement_datetime AS measurement_datetime          
, 44818702 AS measurement_type_concept_id -- Lab result
, operator_concept_id AS operator_concept_id -- = operator
, chartevents_lab.value_as_number AS value_as_number               
, null::bigint AS value_as_concept_id           
, gcpt_lab_unit_to_concept.unit_concept_id               
, null::double precision AS range_low                     
, null::double precision AS range_high                    
, null::bigint AS provider_id                   
, admissions.visit_occurrence_id AS visit_occurrence_id           
, null::bigint As visit_detail_id               
, d_items.label AS measurement_source_value      
, null::bigint AS measurement_source_concept_id 
, gcpt_lab_unit_to_concept.unit_source_value             
, chartevents_lab.value_source_value            
, null::bigint AS quality_concept_id            
  FROM chartevents_lab
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN d_items USING (itemid)
LEFT JOIN omop_loinc USING (label)
LEFT JOIN omop_operator USING (operator_name)
LEFT JOIN gcpt_lab_label_to_concept USING (label)
LEFT JOIN gcpt_lab_unit_to_concept USING (unit_source_value);

-- Microbiology
-- TODO: Map the culture & drug sensitivity
WITH 
"culture" AS (SELECT DISTINCT ON (subject_id, chartdate, spec_itemid, org_name) spec_itemid, mimic_id as measurement_id, chartdate as measurement_date , charttime as measurement_time , subject_id , hadm_id, org_name, spec_type_desc as measurement_source_value FROM mimic.microbiologyevents ),
"resistance" AS (SELECT spec_itemid, nextval('mimic.mimic_id_seq') as measurement_id, chartdate as measurement_date , charttime as measurement_time , subject_id , hadm_id , CASE WHEN dilution_comparison = '=>' THEN '>=' ELSE dilution_comparison END as operator_name , dilution_value as value_as_number , ab_name as measurement_source_value , interpretation , dilution_text as value_source_value, org_name FROM mimic.microbiologyevents WHERE dilution_text IS NOT NULL) , 
"fact_relationship" AS (SELECT culture.measurement_id as fact_id_1, resistance.measurement_id AS fact_id_2 FROM resistance LEFT JOIN culture USING (subject_id, measurement_date, spec_itemid, org_name)),
"insert_fact_relationship" AS (
    INSERT INTO omop.fact_relationship
    SELECT 
      21 AS domain_concept_id_1 -- Measurement
    , fact_id_1
    , 21 AS domain_concept_id_2 -- Measurement
    , fact_id_2 
    , 44818757 as relationship_concept_id -- Has interpretation (SNOMED)
    FROM fact_relationship 
    RETURNING *),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM mimic.patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM mimic.admissions),
"omop_operator" AS (SELECT concept_name as operator_name, concept_id as operator_concept_id FROM omop.concept WHERE  domain_id ilike 'Meas Value Operator'),
"gcpt_resistance_to_concept" AS (SELECT * FROM mimic.gcpt_resistance_to_concept),
"gcpt_org_name_to_concept" AS (SELECT org_name, concept_id AS value_as_concept_id FROM mimic.gcpt_org_name_to_concept JOIN omop.concept ON (concept_code = snomed::text AND vocabulary_id = 'SNOMED'))
INSERT INTO omop.measurement
SELECT
  culture.measurement_id AS measurement_id
, patients.person_id
, 4098207  as measurement_concept_id      -- --30088009 -- Blood Culture but not done yet
, measurement_date AS measurement_date
, measurement_time AS measurement_datetime
, 44818702 AS measurement_type_concept_id -- Lab result
, null AS operator_concept_id
, null value_as_number
, CASE WHEN org_name IS NULL THEN 9189 ELSE coalesce(gcpt_org_name_to_concept.value_as_concept_id, 0) END AS value_as_concept_id           -- staphiloccocus OR negative in case nothing
, null::bigint AS unit_concept_id
, null::double precision AS range_low
, null::double precision AS range_high
, null::bigint AS provider_id
, admissions.visit_occurrence_id AS visit_occurrence_id
, null::bigint As visit_detail_id
, culture.measurement_source_value AS measurement_source_value -- BLOOD ...
, null::bigint AS measurement_source_concept_id
, null::text AS unit_source_value
, culture.org_name AS value_source_value -- Staph...
, null::bigint AS quality_concept_id
FROM culture
LEFT JOIN gcpt_org_name_to_concept USING (org_name)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
UNION ALL
SELECT
  measurement_id AS measurement_id                 
, patients.person_id                     
, 4170475  as measurement_concept_id      -- Culture Sensitivity
, measurement_date AS measurement_date              
, measurement_time AS measurement_datetime          
, 44818702 AS measurement_type_concept_id -- Lab result
, operator_concept_id AS operator_concept_id -- = operator
, value_as_number AS value_as_number               
, gcpt_resistance_to_concept.value_as_concept_id AS value_as_concept_id           
, null::bigint AS unit_concept_id               
, null::double precision AS range_low                     
, null::double precision AS range_high                    
, null::bigint AS provider_id                   
, admissions.visit_occurrence_id AS visit_occurrence_id           
, null::bigint As visit_detail_id               
, resistance.measurement_source_value AS measurement_source_value      
, null::bigint AS measurement_source_concept_id 
, null::text AS unit_source_value             
, value_source_value AS  value_source_value            
, null::bigint AS quality_concept_id            
FROM resistance
LEFT JOIN gcpt_resistance_to_concept USING (interpretation)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN omop_operator USING (operator_name);
