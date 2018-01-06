
---- should be 0 for that code,
---- and units push inside source_concept_id
DELETE FROM omop.concept WHERE concept_id > 2000000000;
INSERT INTO omop.concept (
concept_id,concept_name,domain_id,vocabulary_id,concept_class_id,concept_code,valid_start_date,valid_end_date
) VALUES 
  (2000000000,'Stroke Volume Variation','Measurement','','Clinical Observation','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000001,'L/min/m2','Unit','Unit','','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000002,'dynes.sec.cm-5/m2','Unit','','Unit','MIMIC Generated','1979-01-01','2099-01-01')
, (2000000003,'Output Event','Type Concept','Meas Type','Meas Type','MIMIC Generated','1979-01-01','2099-01-01')
