 -- when first stay, then take admitting_source_value from visit_occurrence
 -- when last stay, then take discharge_to_value from visit_occurrence
 WITH 
"transfers_bed" as (SELECT *, CASE WHEN prev_wardid = curr_wardid THEN curr_wardid ELSE curr_wardid END as value, curr_wardid, prev_wardid FROM mimic.transfers), 
"callout_delay" as (SELECT callout_outcome,  hadm_id, curr_careunit, createtime, outcometime, extract(epoch from outcometime - createtime)/3600/24 as discharge_delay, (outcometime - createtime) / 2 + createtime as mean_time FROM mimic.callout WHERE callout_outcome not ilike 'cancel%'), 
"transfers_call" AS ( SELECT transfers_bed.*, discharge_delay FROM transfers_bed JOIN callout_delay ON (transfers_bed.hadm_id = callout_delay.hadm_id AND mean_time between intime and outtime) WHERE transfers_bed.curr_careunit IS NOT NULL),-- curr careunit is null for a row dedicated for discharge, does not contain meaningful informations
"transfers_no_bed" as(SELECT distinct on (hadm_id, value) transfers_call.*,  min(intime) OVER(PARTITION BY hadm_id, value) as intime_real, max(outtime) OVER(PARTITION BY hadm_id, value) as outtime_real FROM transfers_call ),
"transfers" AS (SELECT subject_id, hadm_id, curr_careunit, mimic_id as visit_detail_id, 9201 as visit_detail_concept_id, intime::date as visit_start_date, intime as visit_start_datetime, outtime::date as visit_end_date, outtime as visit_end_datetime, 44818518 as visit_type_concept_id, eventtype as discharge_to_source_value, LAG(mimic_id) OVER (PARTITION BY hadm_id ORDER BY intime ASC) as preceding_visit_detail_id, discharge_delay FROM transfers_no_bed),
"patients" AS (SELECT subject_id, mimic_id as person_id FROM mimic.patients),
"gcpt_care_site" AS (SELECT care_site_name, mimic_id as care_site_id FROM mimic.gcpt_care_site),
"gcpt_admission_location_to_concept" AS (SELECT admission_location, concept_id as visit_source_concept_id FROM mimic.gcpt_admission_location_to_concept),
"gcpt_discharge_location_to_concept" AS (SELECT discharge_location, concept_id as discharge_to_concept_id FROM mimic.gcpt_discharge_location_to_concept),
"gcpt_visit_detail_source_to_concept" AS (SELECT * FROM mimic.gcpt_visit_detail_source_to_concept),
"admissions" AS (SELECT hadm_id, admission_location, discharge_location, mimic_id as visit_occurrence_id FROM mimic.admissions),
"visit_source" AS (SELECT hadm_id, transfertime, curr_service as visit_source_value FROM mimic.services)
 INSERT INTO omop.VISIT_DETAIL (
	  person_id
	, visit_detail_id
	, visit_detail_concept_id
	, visit_start_date
	, visit_start_datetime
	, visit_end_date
	, visit_end_datetime

	, visit_type_concept_id
	, care_site_id

	, visit_source_value
	, visit_source_concept_id

	, admitting_source_concept_id
	, admitting_source_value

	, discharge_to_concept_id
	, discharge_to_source_value

	, preceding_visit_detail_id
	, visit_occurrence_id
	, discharge_delay
)
 SELECT 
        patients.person_id
      , transfers.visit_detail_id
      , transfers.visit_detail_concept_id
      , transfers.visit_start_date
      , transfers.visit_start_datetime
      , transfers.visit_end_date
      , transfers.visit_end_datetime

      , transfers.visit_type_concept_id
      , gcpt_care_site.care_site_id

      , visit_source.visit_source_value
      , gcpt_visit_detail_source_to_concept.visit_source_concept_id

      , null::bigint
      , null::text 

      , null::bigint
      , null::text 

      , null::bigint
      , admissions.visit_occurrence_id
      , transfers.discharge_delay
   FROM transfers
 LEFT JOIN patients USING (subject_id)
 LEFT JOIN admissions USING (hadm_id) 
 LEFT JOIN visit_source ON (transfers.hadm_id = visit_source.hadm_id AND transfers.visit_start_datetime = visit_source.transfertime) 
 LEFT JOIN gcpt_visit_detail_source_to_concept USING (visit_source_value)
 LEFT JOIN gcpt_care_site ON (care_site_name = curr_careunit)
 LEFT JOIN gcpt_admission_location_to_concept USING (admission_location)
 LEFT JOIN gcpt_discharge_location_to_concept USING (discharge_location)
