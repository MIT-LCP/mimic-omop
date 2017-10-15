 WITH transfers AS (SELECT icustay_id, subject_id, intime::date, intime, outtime::date, outtime, curr_wardid, eventtype, hadm_id FROM mimic.transfers) 
 INSERT INTO omop.VISIT_DETAIL (visit_detail_id, person_id, visit_start_date, visit_start_datetime, visit_end_date, visit_end_datetime, care_site_id, discharge_to_source_value, visit_occurrence_id)
 SELECT transfers.icustay_id, transfers.subject_id, transfers.intime::date, transfers.intime, transfers.outtime::date, transfers.outtime, transfers.curr_wardid, transfers.eventtype, transfers.hadm_id 
FROM transfers 