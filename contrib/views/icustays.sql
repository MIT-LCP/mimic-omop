DROP MATERIALIZED VIEW IF EXISTS icustays CASCADE;
CREATE MATERIALIZED VIEW icustays 	AS

SELECT person_id, visit_occurrence_id, visit_detail_id
, visit_start_date, visit_start_datetime
, visit_end_date, visit_end_datetime

-- care_site
, vd.care_site_id
, care_site.care_site_name

-- admitting, discharge
, admitting_concept_id
, admitting.concept_name AS admitting_concept_name
, admitting_source_value
, discharge_to_concept_id
, discharge.concept_name AS discharge_to_concept_name
, discharge_to_source_value
FROM visit_detail vd
	JOIN care_site ON care_site.care_site_id = vd.care_site_id
	JOIN concept admitting ON admitting.concept_id = admitting_concept_id
	JOIN concept discharge ON discharge.concept_id = discharge_to_concept_id
WHERE visit_detail_concept_id = 581382  	-- concept.concept_name = 'Inpatient Intensive Care Facility'
AND visit_type_concept_id = 2000000006;  	-- concept.concept_name = 'Ward and physical location'
