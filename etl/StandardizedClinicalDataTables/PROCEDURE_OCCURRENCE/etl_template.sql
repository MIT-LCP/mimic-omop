 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.PROCEDURE_OCCURRENCE ()
 SELECT NA.procedure_occurrence_id, NA.person_id, NA.procedure_concept_id, NA.procedure_date, NA.procedure_datetime, NA.procedure_type_concept_id, NA.modifier_concept_id, NA.quantity, NA.provider_id, NA.visit_occurrence_id, NA.procedure_source_value, NA.procedure_source_concept_id, NA.qualifier_source_value, NA.visit_detail_id 
FROM NA 