DROP VIEW IF EXISTS measurement_denorm;
CREATE OR REPLACE VIEW omop.measurement_denorm AS
 SELECT measurement.measurement_id,
    measurement.person_id,
    measurement.measurement_concept_id,
    cpt_meas.concept_name AS measurement_concept_name,
    measurement.measurement_date,
    measurement.measurement_datetime,
    measurement.measurement_type_concept_id,
    cpt_type.concept_name AS measurement_type_concept_name,
    measurement.operator_concept_id,
    cpt_op.concept_name AS operator_concept_name,
    measurement.value_as_number,
    measurement.value_as_concept_id,
    measurement.unit_concept_id,
    cpt_unit.concept_name AS unit_concept_name,
    measurement.range_low,
    measurement.range_high,
    measurement.provider_id,
    measurement.visit_occurrence_id,
    measurement.visit_detail_id,
    measurement.measurement_source_value,
    measurement.measurement_source_concept_id,
    measurement.unit_source_value,
    measurement.value_source_value
   FROM measurement
     LEFT JOIN concept cpt_meas ON measurement.measurement_concept_id = cpt_meas.concept_id
     LEFT JOIN concept cpt_type ON measurement.measurement_type_concept_id = cpt_type.concept_id
     LEFT JOIN concept cpt_op ON measurement.operator_concept_id = cpt_op.concept_id
     LEFT JOIN concept cpt_unit ON measurement.unit_concept_id = cpt_unit.concept_id;
