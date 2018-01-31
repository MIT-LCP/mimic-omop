-- visit occurrence

-- WITH

-- PRINCIPLE:
-- =========
-- TRANSFERS:
-- 
-- visit_start_datetime | visit_end_datetime  
-- ----------------------+---------------------
--  2130-07-05 00:16:17  | 2130-07-05 17:41:52
--  2130-07-05 17:41:52  | 2130-07-05 19:32:40
--  2130-07-05 19:32:40  | 2130-07-06 20:51:50
--  2130-07-06 20:51:50  | 2130-07-07 12:10:06
-- 
-- SERVICES:
-- 
--   visit_start_datetime | visit_end_datetime  
-- -----------------------+---------------------
--   2130-07-05 00:16:17  | 2130-07-05 19:32:40
--   2130-07-05 19:32:40  | 2130-07-06 20:51:50
--   2130-07-06 20:51:50  | 2130-07-07 12:09:00
-- 
-- VISIT_DETAIL:
-- 		TRANSFERS		     |               SERVICES
-- | visit_start_datetime | visit_end_datetime  | visit_start_datetime | visit_end_datetime  
-- +----------------------+---------------------+----------------------+---------------------
-- | 2130-07-05 00:16:17  | 2130-07-05 17:41:52 | 2130-07-05 00:16:17  | 2130-07-05 17:41:52
-- | 2130-07-05 17:41:52  | 2130-07-05 19:32:40 | 2130-07-05 17:41:52  | 2130-07-05 19:32:40
-- | 2130-07-05 19:32:40  | 2130-07-06 20:51:50 | 2130-07-05 19:32:40  | 2130-07-06 20:51:50
-- | 2130-07-06 20:51:50  | 2130-07-07 12:10:06 | 2130-07-06 20:51:50  | 2130-07-07 12:09:00


WITH
"patients" AS (SELECT subject_id, mimic_id as person_id FROM patients),
"gcpt_care_site" AS (
       SELECT care_site.care_site_name
            , care_site.care_site_id
            , visit_detail_concept_id
       FROM omop.care_site
       left join gcpt_care_site on gcpt_care_site.care_site_name = care_site.care_site_source_value
                      )
                    , 
"gcpt_admission_location_to_concept" AS (SELECT concept_id as admitting_source_concept_id, admission_location FROM gcpt_admission_location_to_concept),
"gcpt_discharge_location_to_concept" AS (SELECT concept_id as discharge_to_concept_id, discharge_location FROM gcpt_discharge_location_to_concept),
"admissions" AS (SELECT hadm_id, admission_location, discharge_location, mimic_id as visit_occurrence_id, admittime, dischtime FROM admissions),
"transfers_chained" AS (
                              select t1.*
                                   , sum(group_flag) over ( partition by hadm_id order by intime) as grp
                                from (
                                              select  transfers.row_id , transfers.subject_id , transfers.hadm_id , transfers.icustay_id , transfers.dbsource , transfers.eventtype , transfers.prev_careunit , transfers.curr_careunit , transfers.prev_wardid , transfers.curr_wardid , transfers.intime , coalesce(transfers.outtime,dischtime) as outtime , transfers.los , transfers.mimic_id 
                                                   , case when lag(curr_wardid) over ( partition by hadm_id order by intime) = curr_wardid
						then null 
					        else 1 end as group_flag
                                from transfers
				left join admissions USING (hadm_id)
                                where eventtype!= 'discharge'
                     ) t1
),
"transfers_no_bed" as(
                                SELECT distinct
                                    on (hadm_id, grp) transfers_chained.*
                                     , min(intime) OVER ( PARTITION BY hadm_id , grp) as intime_real
                                     , max(outtime) OVER ( PARTITION BY hadm_id , grp) as outtime_real
                                  FROM transfers_chained
                                 ORDER BY hadm_id, grp, intime
),
"visit_detail_ward" AS (
	 SELECT 
	
		 mimic_id as visit_detail_id
	       , patients.person_id
	       , admissions.visit_occurrence_id
	       , hadm_id
	       , eventtype
	       , curr_wardid
	       , coalesce(curr_careunit,'UNKNOWN') as curr_careunit -- most of ward are unknown
	       --, CASE 
	--	    WHEN curr_careunit = 'EMERGENCY' THEN 9203 
	--	    WHEN curr_careunit != 'UNKNOWN' THEN 4148981 -- intensive care unit
	--	    ELSE 9201 
	--	 END as visit_detail_concept_id
	       , transfers_no_bed.intime_real::date as visit_start_date
	       , intime_real as visit_start_datetime
	       , outtime_real::date as visit_end_date
	       , outtime_real as visit_end_datetime
	       , 2000000006 as visit_type_concept_id  -- [MIMIC Generated] ward and physical
	       , mimic_id = first_value(mimic_id) OVER(PARTITION BY visit_occurrence_id ORDER BY intime_real ASC ) AS  is_first
	       , mimic_id = last_value(mimic_id) OVER(PARTITION BY visit_occurrence_id ORDER BY intime_real ASC range between current row and unbounded following) AS is_last
	       , LAG(mimic_id) OVER ( PARTITION BY hadm_id ORDER BY transfers_no_bed.intime_real ASC) as preceding_visit_detail_id
	       , admitting_source_concept_id
	       , discharge_to_concept_id
	       , admission_location
	       , discharge_location
	FROM transfers_no_bed
	LEFT JOIN patients USING (subject_id)
	LEFT JOIN admissions USING (hadm_id) 
	LEFT JOIN gcpt_admission_location_to_concept USING (admission_location)
	LEFT JOIN gcpt_discharge_location_to_concept USING (discharge_location)
),
"insert_visit_detail_ward" AS (
INSERT INTO omop.visit_detail
SELECT
  visit_detail_id
, person_id
, coalesce(gcpt_care_site.visit_detail_concept_id, 2000000013) as visit_detail_concept_id --unknown
, visit_start_date
, visit_start_datetime
, visit_end_date
, visit_end_datetime
, visit_type_concept_id
, null::integer provider_id
, care_site_id
, null::text visit_source_value
, null::integer visit_source_concept_id
, CASE 
    WHEN is_first IS FALSE THEN 4030023
    ELSE admitting_source_concept_id
  END AS admitting_concept_id
, CASE 
    WHEN is_first IS FALSE THEN 'transfer'
    ELSE admission_location
  END AS admitting_source_value
, CASE 
    WHEN is_last IS FALSE THEN 4030023
ELSE discharge_to_concept_id
  END AS discharge_to_concept_id
, CASE 
    WHEN is_last IS FALSE THEN 'transfer'
    ELSE discharge_location
  END AS discharge_to_source_value
, preceding_visit_detail_id
, null::integer visit_detail_parent_id
, visit_occurrence_id
FROM visit_detail_ward
LEFT JOIN gcpt_care_site ON (care_site_name = curr_careunit ||' ward #' || coalesce(curr_wardid::text,'?'))
),
"callout_delay" as (
	SELECT 
         visit_detail_id as subject_id
	, visit_start_datetime as cohort_start_date
	, visit_end_datetime as cohort_end_date
	, extract(
		epoch
		from outcometime - createtime
	)/3600/24 as discharge_delay
	, (outcometime - createtime) / 2 + createtime as mean_time
	FROM callout
	LEFT JOIN  visit_detail_ward v 
	ON v.hadm_id = callout.hadm_id
	AND callout.curr_careunit = v.curr_careunit
	AND ((outcometime - createtime) / 2 + createtime) between v.visit_start_datetime and v.visit_end_datetime
	WHERE callout_outcome not ilike 'cancel%' AND visit_detail_id IS NOT NULL
),
"insert_callout_delay" AS (
	INSERT INTO omop.cohort_attribute
	SELECT
	0 AS cohort_definition_id    
	, cohort_start_date       
	, cohort_end_date         
	, subject_id              
	, 1 AS  attribute_definition_id -- callout delay
	, discharge_delay as value_as_number
	, 0 value_as_concept_id     
	FROM callout_delay
),
"insert_visit_detail_delay" AS (
	INSERT INTO omop.cohort_attribute
	SELECT
	0 AS cohort_definition_id    
	, visit_start_datetime as  cohort_start_date       
	, visit_end_datetime as cohort_end_date         
	, visit_detail_id as subject_id              
	,  2  as  attribute_definition_id  -- visit delay
	, extract(
		epoch
		from visit_end_datetime - visit_start_datetime
	)/3600/24 AS  value_as_number
	, 0 value_as_concept_id     
	FROM visit_detail_ward
),
"serv_tmp" as (
       SELECT services.*
	    , visit_occurrence_id
            , lead(services.row_id) OVER ( PARTITION BY services.hadm_id ORDER BY transfertime) as next
            , lag(services.row_id) OVER ( PARTITION BY services.hadm_id ORDER BY transfertime) as prev
            , admittime
            , dischtime
         FROM services
         LEFT JOIN admissions USING (hadm_id)
), 
"serv" as (
     SELECT 
	    serv_tmp.visit_occurrence_id
	  , serv_tmp.mimic_id as visit_detail_id
          , serv_tmp.subject_id
          , serv_tmp.hadm_id
          , serv_tmp.curr_service
          , serv_adm_prev.mimic_id as preceding_visit_detail_id
          , serv_tmp.transfertime as visit_start_datetime
          , CASE 
                WHEN serv_tmp.prev IS NULL AND serv_tmp.next IS NOT NULL THEN serv_adm_next.transfertime 
                WHEN serv_tmp.prev IS NULL AND serv_tmp.next IS NULL THEN serv_tmp.dischtime 
                WHEN serv_tmp.prev IS NOT NULL AND serv_tmp.next IS NULL THEN serv_tmp.dischtime 
                WHEN serv_tmp.prev IS NOT NULL AND serv_tmp.next IS NOT NULL THEN serv_adm_next.transfertime 
            END as visit_end_datetime 
	FROM serv_tmp
       LEFT JOIN serv_tmp as serv_adm_prev ON (serv_tmp.prev = serv_adm_prev.row_id)
       LEFT JOIN serv_tmp as serv_adm_next ON (serv_tmp.next = serv_adm_next.row_id)
            ),
"serv_linked_ward" AS (
	SELECT 
	  visit_detail_ward.visit_detail_id as visit_detail_parent_id
	, serv.visit_detail_id
	, visit_detail_ward.visit_occurrence_id
	, visit_detail_ward.person_id
	, serv.curr_service
	, serv.preceding_visit_detail_id
        , 4204503 as discharge_to_concept_id -- transfer of care
	, CASE WHEN visit_detail_ward.visit_start_datetime >= serv.visit_start_datetime THEN visit_detail_ward.visit_start_datetime
	      WHEN visit_detail_ward.visit_start_datetime <= serv.visit_start_datetime THEN serv.visit_start_datetime 
	  END as visit_start_datetime
	, CASE WHEN visit_detail_ward.visit_end_datetime <= serv.visit_end_datetime THEN visit_detail_ward.visit_end_datetime
	      WHEN visit_detail_ward.visit_end_datetime >= serv.visit_end_datetime THEN serv.visit_end_datetime 
	  END as visit_end_datetime
	FROM visit_detail_ward 
	LEFT JOIN serv
	ON serv.hadm_id = visit_detail_ward.hadm_id 
	AND (
	   serv.visit_start_datetime >= visit_detail_ward.visit_start_datetime AND serv.visit_end_datetime <= visit_detail_ward.visit_end_datetime  -- service covered or equal
	   OR visit_detail_ward.visit_start_datetime > serv.visit_start_datetime AND visit_detail_ward.visit_start_datetime < serv.visit_end_datetime  -- ward begin covered
 	OR visit_detail_ward.visit_end_datetime > serv.visit_start_datetime AND visit_detail_ward.visit_end_datetime < serv.visit_end_datetime  -- ward end covered
) 
        ORDER BY visit_start_datetime
),
"visit_detail_service" AS (
	SELECT
       nextval('mimic_id_seq') as visit_detail_id
      , person_id
      , coalesce(gcpt_care_site.visit_detail_concept_id, 0) as visit_detail_concept_id -- [athena] 
      , serv_linked_ward.visit_start_datetime::date as visit_start_date
      , serv_linked_ward.visit_start_datetime
      , serv_linked_ward.visit_end_datetime::date as visit_end_date
      , serv_linked_ward.visit_end_datetime
      , 45770670 as visit_type_concept_id -- [Athena] Service of care 
      , gcpt_care_site.care_site_id
      , null::integer preceding_visit_detail_id
      , visit_detail_parent_id
	FROM serv_linked_ward
	LEFT JOIN gcpt_care_site ON (care_site_name = curr_service)
),
"insert_visit_detail_service" AS (
INSERT INTO omop.visit_detail
SELECT
  visit_detail_id
, person_id
, visit_detail_concept_id
, visit_start_date
, visit_start_datetime
, visit_end_date
, visit_end_datetime
, visit_type_concept_id
, null::integer provider_id
, care_site_id
, null::text visit_source_value
, null::integer visit_source_concept_id
, null::integer admitting_concept_id
, null::text admitting_source_value
, null::integer discharge_to_concept_id
, null::text discharge_to_source_value
, null::integer preceding_visit_detail_id
, visit_detail_parent_id
, null::integer visit_occurrence_id
FROM visit_detail_service
WHERE visit_end_date IS NOT NULL  -- trick to remove emergency services that does not actually exist
)
SELECT 1;

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
 , visit_detail_concept_id = 581382 AS is_icu
 , visit_detail_concept_id = 581381 AS is_emergency
 FROM  omop.visit_detail 
 WHERE visit_type_concept_id = 2000000006 -- only ward kind 
 ;
 
