 WITH
"callout_delay" as (SELECT callout_service as callout_discharge_to_source_value, hadm_id, curr_careunit, createtime, outcometime, extract(epoch from outcometime - createtime)/3600/24 as discharge_delay, (outcometime - createtime) / 2 + createtime as mean_time FROM callout WHERE callout_outcome not ilike 'cancel%'), 
"transfers_call" AS (SELECT transfers.*, CASE WHEN transfers.icustay_id IS NULL THEN NULL ELSE discharge_delay END AS discharge_delay, callout_discharge_to_source_value FROM transfers LEFT JOIN callout_delay ON (transfers.hadm_id = callout_delay.hadm_id AND mean_time between intime and outtime AND callout_delay.curr_careunit = transfers.curr_careunit)),
"bed_tmp" as (SELECT *, CASE WHEN prev_wardid = curr_wardid THEN curr_wardid ELSE curr_wardid END as value, curr_wardid, prev_wardid FROM transfers_call WHERE outtime IS NOT NULL),
"transfers_bed" AS (select t1.*, sum(group_flag) over (partition by hadm_id order by intime) as grp from ( select *, case when lag(value) over (partition by hadm_id order by intime) = value then null else 1 end as group_flag from bed_tmp) t1),
"transfers_no_bed" as(SELECT  distinct on (hadm_id, grp) transfers_bed.*,  min(intime) OVER(PARTITION BY hadm_id, grp) as intime_real, max(outtime) OVER(PARTITION BY hadm_id, grp) as outtime_real FROM transfers_bed ORDER BY hadm_id, grp, intime),
"transfers" AS (
                          SELECT subject_id
                               , hadm_id
                               , coalesce(curr_careunit,'UNKNOWN') as curr_careunit
                               , mimic_id as visit_detail_id
			       , CASE WHEN curr_careunit = 'EMERGENCY' THEN 9203 WHEN curr_careunit != 'UNKNOWN' THEN 9204 ELSE 9201 END as visit_detail_concept_id
                               , transfers_no_bed.intime_real::date as visit_start_date
                               , intime_real as visit_start_datetime
                               , outtime_real::date as visit_end_date
                               , outtime_real as visit_end_datetime
                               , 44818518 as visit_type_concept_id -- [athena] Visit derived from EHR record
                               , LAG(mimic_id) OVER ( PARTITION BY hadm_id ORDER BY transfers_no_bed.intime_real ASC) as preceding_visit_detail_id
                               , discharge_delay
            FROM transfers_no_bed
                 )
               , 
"patients" AS (SELECT subject_id, mimic_id as person_id FROM patients),
"gcpt_care_site" AS (SELECT care_site_name, mimic_id as care_site_id FROM gcpt_care_site),
"admissions" AS (SELECT hadm_id, admission_location, discharge_location, mimic_id as visit_occurrence_id, admittime, dischtime FROM admissions),
"serv_tmp" as (SELECT services.*, lead(services.row_id) OVER(PARTITION BY services.hadm_id ORDER BY transfertime) as next, lag(services.row_id) OVER(PARTITION BY services.hadm_id ORDER BY transfertime) as prev , admittime, dischtime FROM services LEFT JOIN admissions USING (hadm_id)),
"serv" as (SELECT serv_tmp.mimic_id as visit_detail_id, serv_tmp.subject_id, serv_tmp.hadm_id, serv_tmp.curr_service, serv_adm_prev.mimic_id as preceding_visit_detail_id, serv_tmp.transfertime as visit_start_datetime, CASE WHEN serv_tmp.prev IS NULL AND serv_tmp.next IS NOT NULL THEN serv_adm_next.transfertime WHEN serv_tmp.prev IS NULL AND serv_tmp.next IS NULL THEN serv_tmp.dischtime WHEN serv_tmp.prev IS NOT NULL AND serv_tmp.next IS NULL THEN serv_tmp.dischtime WHEN serv_tmp.prev IS NOT NULL AND serv_tmp.next IS NOT NULL THEN serv_adm_next.transfertime END as visit_end_datetime FROM serv_tmp LEFT JOIN serv_tmp as serv_adm_prev ON (serv_tmp.prev = serv_adm_prev.row_id) LEFT JOIN serv_tmp as serv_adm_next ON (serv_tmp.next = serv_adm_next.row_id))
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
	, preceding_visit_detail_id
	, visit_occurrence_id
	, discharge_delay
)
 SELECT 
        patients.person_id
      , transfers.visit_detail_id
      , transfers.visit_detail_concept_id
      , transfers.visit_start_date
      , to_datetime(transfers.visit_start_datetime)
      , transfers.visit_end_date
      , to_datetime(transfers.visit_end_datetime)

      , transfers.visit_type_concept_id
      , gcpt_care_site.care_site_id
      , transfers.preceding_visit_detail_id
      , admissions.visit_occurrence_id
      , transfers.discharge_delay
   FROM transfers
 LEFT JOIN patients USING (subject_id)
 LEFT JOIN admissions USING (hadm_id) 
 LEFT JOIN gcpt_care_site ON (care_site_name = curr_careunit)
UNION ALL
SELECT
        patients.person_id
      , serv.visit_detail_id
      , 9201 as visit_detail_concept_id -- [athena] Emergency Room and Inpatient Visit
      , serv.visit_start_datetime::date as visit_start_date
      , to_datetime(serv.visit_start_datetime)
      , serv.visit_end_datetime::date as visit_end_date
      , to_datetime(serv.visit_end_datetime)
      , 45770670 as visit_type_concept_id -- [athena] services and care
      , gcpt_care_site.care_site_id
      , serv.preceding_visit_detail_id
      , admissions.visit_occurrence_id
      , null::double precision as discharge_delay
FROM serv
 LEFT JOIN patients USING (subject_id)
 LEFT JOIN admissions USING (hadm_id) 
 LEFT JOIN gcpt_care_site ON (care_site_name = curr_service);


-- first draft of icustay assignation table 
DROP TABLE IF EXISTS omop.visit_detail_assign;
CREATE TABLE omop.visit_detail_assign AS 
SELECT
  visit_detail_id
, visit_occurrence_id
, visit_start_datetime
, visit_end_datetime
, visit_detail_id = first_value(visit_detail_id) OVER(PARTITION BY visit_occurrence_id ORDER BY visit_start_datetime ASC ) AS  is_first
, visit_detail_id = last_value(visit_detail_id) OVER(PARTITION BY visit_occurrence_id ORDER BY visit_start_datetime ASC range between current row and unbounded following) AS is_last
, visit_detail_concept_id = 9204 AS is_icu
, visit_detail_concept_id = 9203 AS is_emergency
FROM  omop.visit_detail 
WHERE visit_type_concept_id = 44818518 -- only ward kind 
;
