
---- should be 0 for that code,
---- and units push inside source_concept_id
-- DELETE FROM omop.concept WHERE concept_id >= 500000000;
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) VALUES 
  (2000000000,'Stroke Volume Variation','Measurement','','Clinical Observation','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000001,'L/min/m2','Unit','Unit','','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000002,'dynes.sec.cm-5/m2','Unit','','Unit','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000003,'Output Event','Type Concept','Meas Type','Meas Type','MIMIC Generated','1979-01-01','2099-01-01')
;

INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, coalesce(label, 'UNKNOWN') as concept_name
, 'Measurement'::text as domain_id
, '' as vocabulary_id
, '' as concept_class_id
, itemid as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM d_items;

INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) 
SELECT 
  mimic_id as concept_id
, coalesce(label || '[' || fluid || '][' || category || ']', 'UNKNOWN') as concept_name
, 'Measurement'::text as domain_id
, '' as vocabulary_id
, '' as concept_class_id
, itemid as concept_code
, '1979-01-01' as valid_start_date
, '2099-01-01' as valid_end_date
FROM d_labitems;
