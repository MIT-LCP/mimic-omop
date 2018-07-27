-- This query pivots the most prevalent vital signs for the first 24 hours of a patient's stay
-- cf https://github.com/MIT-LCP/mimic-code/blob/master/concepts/firstday/vitals-first-day.sql

DROP MATERIALIZED VIEW IF EXISTS vitals_firstday CASCADE;
CREATE MATERIALIZED VIEW vitals_firstday AS

WITH tmp AS 
(
	SELECT person_id, visit_occurrence_id, visit_detail_id
	, measurement_concept_id
	, measurement_datetime
	, value_as_number
	FROM measurement
	WHERE TRUE
	AND measurement_type_concept_id = 44818701
	AND measurement_concept_id IN
	(
                3027018  -- concept_name : Heart rate
               	, 3004249 -- concept_name : BP systolic                                
                , 3012888 -- concept_name : BP diastolic                                
                , 3027598 -- concept_name : Mean blood pressure                         

		, 3024171 -- concept_name : Respiratory rate
                , 3016502 -- concept_name : Oxygen saturation in Arterial blood
                , 3016226 -- concept_name : PEEP Respiratory system                     
                , 21490854 -- concept_name : Tidal volume Ventilator --on ventilator    

                , 3025315 -- concept_name : Body weight                

                , 3020891 -- concept_name : Body temperature                            

                , 3016335 -- concept_name : Glasgow coma score eye opening              
                , 3009094 -- concept_name : Glasgow coma score verbal                   
                , 3008223 -- concept_name : Glasgow coma score motor                    
	)
)

SELECT tmp.person_id, tmp.visit_occurrence_id, tmp.visit_detail_id
, min(case when measurement_concept_id = 3027018 then value_as_number else null end) as HeartRate_Min
, max(case when measurement_concept_id = 3027018 then value_as_number else null end) as HeartRate_Max
, avg(case when measurement_concept_id = 3027018 then value_as_number else null end) as HeartRate_Mean
, min(case when measurement_concept_id = 3004249 then value_as_number else null end) as SysBP_Min
, max(case when measurement_concept_id = 3004249 then value_as_number else null end) as SysBP_Max
, avg(case when measurement_concept_id = 3004249 then value_as_number else null end) as SysBP_Mean
, min(case when measurement_concept_id = 3012888 then value_as_number else null end) as DiasBP_Min
, max(case when measurement_concept_id = 3012888 then value_as_number else null end) as DiasBP_Max
, avg(case when measurement_concept_id = 3012888 then value_as_number else null end) as DiasBP_Mean
, min(case when measurement_concept_id = 3027598 then value_as_number else null end) as MeanBP_Min
, max(case when measurement_concept_id = 3027598 then value_as_number else null end) as MeanBP_Max
, avg(case when measurement_concept_id = 3027598 then value_as_number else null end) as MeanBP_Mean

, min(case when measurement_concept_id = 3024171 then value_as_number else null end) as RespRate_Min
, max(case when measurement_concept_id = 3024171 then value_as_number else null end) as RespRate_Max
, avg(case when measurement_concept_id = 3024171 then value_as_number else null end) as RespRate_Mean
, min(case when measurement_concept_id = 3016502 then value_as_number else null end) as SpO2_Min
, max(case when measurement_concept_id = 3016502 then value_as_number else null end) as SpO2_Max
, avg(case when measurement_concept_id = 3016502 then value_as_number else null end) as SpO2_Mean
, avg(case when measurement_concept_id = 3016226 then value_as_number else null end) as PEP_Mean
, min(case when measurement_concept_id = 21490854 then value_as_number else null end) as Tidal_Min
, max(case when measurement_concept_id = 21490854 then value_as_number else null end) as Tidal_Max
, avg(case when measurement_concept_id = 21490854 then value_as_number else null end) as Tidal_Mean

, avg(case when measurement_concept_id = 3025315  then value_as_number else null end) as Weight_Mean

, min(case when measurement_concept_id = 3020891 then value_as_number else null end) as Temp_Min
, max(case when measurement_concept_id = 3020891 then value_as_number else null end) as Temp_Max
, avg(case when measurement_concept_id = 3020891 then value_as_number else null end) as Temp_Mean

, min(case when measurement_concept_id = 3016335 then value_as_number else null end) as GCSO_Min
, min(case when measurement_concept_id = 3009094 then value_as_number else null end) as GCSV_Min
, min(case when measurement_concept_id = 3008223 then value_as_number else null end) as GCSM_Min

FROM  tmp 
JOIN visit_detail vd ON 
(
	tmp.person_id = vd.person_id and tmp.visit_occurrence_id = vd.visit_occurrence_id and tmp.visit_detail_id = vd.visit_detail_id
	and vd.visit_detail_concept_id = 32037   -- concept.concept_name = 'Intensive Care'
	and vd.visit_type_concept_id = 2000000006 -- concept.concept_name = 'Ward and physical location'
	and tmp.measurement_datetime between vd.visit_start_datetime and vd.visit_start_datetime + interval '1' day
)
group by tmp.person_id, tmp.visit_occurrence_id, tmp.visit_detail_id
order by tmp.person_id, tmp.visit_occurrence_id, tmp.visit_detail_id;
