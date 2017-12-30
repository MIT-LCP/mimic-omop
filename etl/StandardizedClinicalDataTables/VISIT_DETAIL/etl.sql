 -- when first stay, then take admitting_source_value from visit_occurrence
 -- when last stay, then take discharge_to_value from visit_occurrence
 WITH
"callout_delay" as (SELECT callout_service as callout_discharge_to_source_value, hadm_id, curr_careunit, createtime, outcometime, extract(epoch from outcometime - createtime)/3600/24 as discharge_delay, (outcometime - createtime) / 2 + createtime as mean_time FROM mimic.callout WHERE callout_outcome not ilike 'cancel%'), 
"transfers_call" AS (SELECT transfers.*, CASE WHEN transfers.icustay_id IS NULL THEN NULL ELSE discharge_delay END AS discharge_delay, callout_discharge_to_source_value FROM mimic.transfers LEFT JOIN callout_delay ON (transfers.hadm_id = callout_delay.hadm_id AND mean_time between intime and outtime AND callout_delay.curr_careunit = transfers.curr_careunit)),
"bed_tmp" as (SELECT *, CASE WHEN prev_wardid = curr_wardid THEN curr_wardid ELSE curr_wardid END as value, curr_wardid, prev_wardid FROM transfers_call WHERE outtime IS NOT NULL),
"transfers_bed" AS ( select t1.*, sum(group_flag) over (partition by hadm_id order by intime) as grp from ( select *, case when lag(value) over (partition by hadm_id order by intime) = value then null else 1 end as group_flag from bed_tmp) t1),
"transfers_no_bed" as(SELECT  distinct on (hadm_id, grp) transfers_bed.*,  min(intime) OVER(PARTITION BY hadm_id, grp) as intime_real, max(outtime) OVER(PARTITION BY hadm_id, grp) as outtime_real FROM transfers_bed ORDER BY hadm_id, grp, intime),
"transfers_light" AS (SELECT subject_id, hadm_id, curr_careunit, mimic_id as visit_detail_id, 9201 as visit_detail_concept_id, transfers_no_bed.intime_real::date as visit_start_date, intime_real as visit_start_datetime, outtime_real::date as visit_end_date, outtime_real as visit_end_datetime, 44818518 as visit_type_concept_id, callout_discharge_to_source_value  as discharge_to_source_value, prev_careunit as admitting_source_value, LEAD(mimic_id) OVER (PARTITION BY hadm_id ORDER BY transfers_no_bed.intime_real ASC) as later_visit_detail_id, LAG(mimic_id) OVER (PARTITION BY hadm_id ORDER BY transfers_no_bed.intime_real ASC) as preceding_visit_detail_id, discharge_delay FROM transfers_no_bed),
"transfers" AS (
                          SELECT t10.subject_id
                               , t10.hadm_id
                               , t10.visit_detail_id
                               , t10.visit_detail_concept_id
                               , t10.visit_start_date
                               , t10.visit_start_datetime
                               , t10.visit_end_date
                               , t10.visit_end_datetime
                               , t10.visit_type_concept_id
                               , CASE WHEN t10.preceding_visit_detail_id IS NULL THEN NULL ELSE coalesce(t9.curr_careunit,'UNKNOWN') END as admitting_source_value
                               , coalesce( t10.curr_careunit, t9.discharge_to_source_value,t10bis.curr_careunit,'UNKNOWN') as curr_careunit
                               , CASE WHEN t10.later_visit_detail_id IS NULL THEN NULL ELSE coalesce(t11.curr_careunit, t10.discharge_to_source_value,'UNKNOWN') END as discharge_to_source_value
                               , t10.later_visit_detail_id
                               , t10.preceding_visit_detail_id
                               , t10.discharge_delay
                            FROM transfers_light as t10
                          LEFT 
                          JOIN (
                                        SELECT hadm_id
                                             , transfertime
                                             , curr_service as curr_careunit
                          FROM mimic.services
                               ) as t10bis
                            ON (
                                       t10bis.hadm_id      = t10.hadm_id
                           AND t10bis.transfertime = t10.visit_start_datetime
                               )
                            LEFT 
                            JOIN transfers_light as t9
                              ON (t10.preceding_visit_detail_id = t9.visit_detail_id)
                            LEFT 
                            JOIN transfers_light as t11
              ON (t10.later_visit_detail_id     = t11.visit_detail_id)
                 )
               , 
"patients" AS (SELECT subject_id, mimic_id as person_id FROM mimic.patients),
"gcpt_care_site" AS (SELECT care_site_name, mimic_id as care_site_id FROM mimic.gcpt_care_site),
"gcpt_visit_detail_source_to_concept" AS (SELECT visit_source_value, visit_source_concept_id FROM mimic.gcpt_visit_detail_source_to_concept UNION ALL SELECT care_site_name as visit_source_value, place_of_service_concept_id as visit_source_concept_id FROM mimic.gcpt_care_site),
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

      , transfers.curr_careunit
      , gcpt_visit_detail_source_to_concept.visit_source_concept_id

      , gcpt_visit_detail_admitting.visit_source_concept_id
     -- , gcpt_visit_detail_admitting.visit_source_value
, transfers.admitting_source_value

      , gcpt_visit_detail_discharge.visit_source_concept_id
     -- , gcpt_visit_detail_discharge.visit_source_value
     , transfers.discharge_to_source_value

      , transfers.preceding_visit_detail_id
      , admissions.visit_occurrence_id
      , transfers.discharge_delay
   FROM transfers
 LEFT JOIN patients USING (subject_id)
 LEFT JOIN admissions USING (hadm_id) 
 LEFT JOIN gcpt_visit_detail_source_to_concept  ON (transfers.curr_careunit = visit_source_value)
 LEFT JOIN gcpt_visit_detail_source_to_concept gcpt_visit_detail_admitting ON (gcpt_visit_detail_admitting.visit_source_value = transfers.admitting_source_value)
 LEFT JOIN gcpt_visit_detail_source_to_concept gcpt_visit_detail_discharge ON (gcpt_visit_detail_discharge.visit_source_value = transfers.discharge_to_source_value)
 LEFT JOIN visit_source ON (transfers.hadm_id = visit_source.hadm_id AND transfers.visit_start_datetime = visit_source.transfertime) 
 LEFT JOIN gcpt_care_site ON (care_site_name = curr_careunit)
