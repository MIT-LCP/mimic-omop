 WITH labevents AS (SELECT row_id as measurement_id, subject_id as person_id, charttime::date as measurement_date, charttime as measurement_datetime, valuenum as value_as_number, hadm_id as visit_occurrence_id, itemid as measurement_source_concept_id, valueuom as unit_source_value, value as value_source_value FROM mimic.labevents),
d_items AS (SELECT label as measurement_source_value FROM mimic.d_items) 
 INSERT INTO omop.MEASUREMENT (measurement_id, person_id, measurement_date, measurement_datetime, value_as_number, visit_occurrence_id, measurement_source_concept_id, unit_source_value, value_source_value, measurement_source_value)
 SELECT labevents.measurement_id, labevents.person_id, labevents.measurement_date, labevents.measurement_datetime, labevents.value_as_number, labevents.visit_occurrence_id, d_items.measurement_source_value, labevents.measurement_source_concept_id, labevents.unit_source_value, labevents.value_source_value 
FROM labevents
 LEFT JOIN d_items USING () 