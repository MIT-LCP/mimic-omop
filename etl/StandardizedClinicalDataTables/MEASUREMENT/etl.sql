--TODO lab is the reference data source for lab (duplicates lab/measurement) -> remove them from measurment
TRUNCATE omop.measurement;
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
--"chartevents_lab" AS (SELECT mimic_id as measurement_id, subject_id, hadm_id, valueuom as value_as_number FROM mimic.chartevents JOIN mimic.d_items USING (itemid) WHERE category = 'Labs')
--"d_items" AS (SELECT label as measurement_source_value FROM mimic.d_items) 
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
