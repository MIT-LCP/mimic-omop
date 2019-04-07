-- This query pivots the most prevalent laboratory exams for the first 24 hours of a patient's stay
-- cf https://github.com/MIT-LCP/mimic-code/blob/master/concepts/firstday/labs-first-day.sql

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
	AND measurement_type_concept_id IN (2000000009, 2000000010, 2000000011)
	AND measurement_concept_id IN
	(
    		3000963 -- concept_name : Hemoglobin                                                 
    		, 3023314 -- concept_name : Hematocrit [Volume Fraction] of Blood by Automated count   
    		, 3024929 -- concept_name : Platelets [#/volume] in Blood by Automated count           
    		, 3003282 -- concept_name : Leukocytes [#/volume] in Blood by Manual count             
   		, 3004327 -- concept_name : Lymphocytes [#/volume] in Blood by Automated count         
    		, 3014886 -- concept_name : Neutrophils [#/volume] in Urine by Automated count         

    		, 3034795 -- concept_name : Deprecated INR in Platelet poor plasma by Coagulation assay
    		, 3022217 -- concept_name : INR                                                        
    		, 3034426 -- concept_name : Prothrombin time - patient                                 
    		, 3013466 -- concept_name : aPTT in Blood by Coagulation assay                         

    		, 3023103 -- concept_name : Potassium serum/plasma                                     
    		, 3019550 -- concept_name : Sodium serum/plasma                                        
   		, 3016723 -- concept_name : Creatinine serum/plasma                                    
    		, 3013682 -- concept_name : Urea nitrogen serum/plasma                                 
    		, 3016293 -- concept_name : Bicarbonate [Moles/volume] in Serum                        
    		, 3037278 -- concept_name : Anion gap 4 in Serum or Plasma                             
   		, 3004501 -- concept_name : Glucose lab                                                
    		, 3015377 -- concept_name : Calcium [Moles/volume] in Serum or Plasma                  
    		, 3010421 -- concept_name : pH (acidity) in blood                                      
    		, 3027315 -- concept_name : Oxygen (O2) pressure in blood                              
    		, 3013290 -- concept_name : Carbon dioxide pressure in blood                           
    		, 3012501 -- concept_name : Base excess of blood                                       
    		, 3047181 -- concept_name : Lactate [Moles/volume] in Blood                            
    		, 3024128 -- concept_name : Total Bilirubin serum/plasma                               
    		, 3013721 -- concept_name : Aspartate aminotransferase serum/plasma                    
    		, 3006923 -- concept_name : Alanine aminotransferase serum/plasma                      
	)
)

SELECT tmp.person_id, tmp.visit_occurrence_id, tmp.visit_detail_id
, min(case when measurement_concept_id = 3000963 then value_as_number else null end) as Hemoglobin_Min
, min(case when measurement_concept_id = 3023314 then value_as_number else null end) as Hematocrit_Min
, min(case when measurement_concept_id = 3024929 then value_as_number else null end) as Platelet_Min
, min(case when measurement_concept_id = 3003282 then value_as_number else null end) as Leucocytes_Min
, max(case when measurement_concept_id = 3003282 then value_as_number else null end) as Leucocytes_Max
, min(case when measurement_concept_id = 3004327 then value_as_number else null end) as Lymphocytes_Min
, min(case when measurement_concept_id = 3014886 then value_as_number else null end) as Neutrophils_Min

, max(case when measurement_concept_id = 3034795 then value_as_number else null end) as DeprecatedINR_Max
, max(case when measurement_concept_id = 3022217 then value_as_number else null end) as INR_Max
, min(case when measurement_concept_id = 3034426 then value_as_number else null end) as PT_Min
, min(case when measurement_concept_id = 3013466 then value_as_number else null end) as aPTT_Min

, min(case when measurement_concept_id = 3023103 then value_as_number else null end) as Potassium_Min
, max(case when measurement_concept_id = 3023103 then value_as_number else null end) as Potassium_Max
, min(case when measurement_concept_id = 3019550 then value_as_number else null end) as Sodium_Min
, max(case when measurement_concept_id = 3019550 then value_as_number else null end) as Sodium_Max
, max(case when measurement_concept_id = 3016723 then value_as_number else null end) as Creat_Max
, max(case when measurement_concept_id = 3013682 then value_as_number else null end) as Urea_Max
, min(case when measurement_concept_id = 3016293 then value_as_number else null end) as Bicar_Min
, max(case when measurement_concept_id = 3016293 then value_as_number else null end) as Bicar_Max
, min(case when measurement_concept_id = 3037278 then value_as_number else null end) as Aniongap_Min
, max(case when measurement_concept_id = 3037278 then value_as_number else null end) as Aniongap_Max
, min(case when measurement_concept_id = 3004501 then value_as_number else null end) as Glucose_Min
, max(case when measurement_concept_id = 3004501 then value_as_number else null end) as Glucose_Max
, min(case when measurement_concept_id = 3015377 then value_as_number else null end) as Ca_Min
, max(case when measurement_concept_id = 3015377 then value_as_number else null end) as Ca_Max
, min(case when measurement_concept_id = 3010421 then value_as_number else null end) as pH_Min
, max(case when measurement_concept_id = 3010421 then value_as_number else null end) as pH_Max
, min(case when measurement_concept_id = 3027315 then value_as_number else null end) as O2_Min
, min(case when measurement_concept_id = 3013290 then value_as_number else null end) as CO2_Min
, max(case when measurement_concept_id = 3013290 then value_as_number else null end) as CO2_Max
, min(case when measurement_concept_id = 3012501 then value_as_number else null end) as BE_Min
, max(case when measurement_concept_id = 3012501 then value_as_number else null end) as BE_Max
, max(case when measurement_concept_id = 3047181 then value_as_number else null end) as Lactate_Max
, max(case when measurement_concept_id = 3024128 then value_as_number else null end) as Bilirubin_Max
, max(case when measurement_concept_id = 3013721 then value_as_number else null end) as ASAT_Max
, max(case when measurement_concept_id = 3006923 then value_as_number else null end) as ALAT_Max

FROM  tmp 
JOIN visit_detail vd ON 
(
	tmp.person_id = vd.person_id and tmp.visit_occurrence_id = vd.visit_occurrence_id
	and vd.visit_detail_concept_id = 32037   -- concept.concept_name = 'Intensive Care'
	and vd.visit_type_concept_id = 2000000006 -- concept.concept_name = 'Ward and physical location'    
	and tmp.measurement_datetime between vd.visit_start_datetime and vd.visit_start_datetime + interval '1' day
)
group by tmp.person_id, tmp.visit_occurrence_id, tmp.visit_detail_id
order by tmp.person_id, tmp.visit_occurrence_id, tmp.visit_detail_id;
