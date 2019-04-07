-- ------------------------------------------------------------------
-- Simplified Acute Physiology Score II (SAPS II)
-- ------------------------------------------------------------------

-- -----------------------------------------------------------------------------
-- Reference for SAPS II:
--    Le Gall, Jean-Roger, Stanley Lemeshow, and Fabienne Saulnier.
--    "A new simplified acute physiology score (SAPS II) based on a European/North American multicenter study."
--    JAMA 270, no. 24 (1993): 2957-2963.

-- Methodology:
--      The score is calculated on the first day for each ICU patients' stay even if some variables are missing. 
--      If some variables are missing, data_missing_warning is equal to 1
--      If the patient is intubated, the glasgow could be wrong, ETT_warning is equal to 1

-- Variables used in SAPS II:
--  * Age
--  * Comorbidity / Chronic diseases (OMOP standard concept):
--   	HIV/AIDS (AIDS): 439727 (Human immunodeficiency virus infection)
-- 	Metastatic cancer (METAS): 4032806 (Neoplasm, metastatic)
-- 	Hematologic malignancy (HEMATO): 4189640 (Neoplasm of hematopoietic cell type)
--  * Clinical variables (OMOP standard concept):
--  	Glasgow Coma Scale (GCS): 3009094 (Glasgow coma score verbal), 3016335 (Glasgow coma score eye opening), 3008223 (Glasgow coma score motor)
-- 	Systolic blood pressure: 3004249 (Systolic blood pressure)
--    	Heart rate: 3027018 (Heart rate)
-- 	PaO2/FiO2 ratio (PF) 4233883 (Ratio of arterial oxygen tension to inspired oxygen)
--  	Urine output: 3014315 (Urine output)
-- 	Temperature: 3020891 (Body temperature)
--  * Biological variables (OMOP standard concept): 
-- 	White blood cells (WBC): 3003282 (Leukocytes [#/volume] in Blood by Manual count)
-- 	Potassium: 3023103 (Potassium serum/plasma)
-- 	Sodium: 3019550(Sodium serum/plasma)
-- 	Blood urea nitrogen (urea): 3013682(Urea nitrogen serum/plasma)
-- 	HCO3: 3016293 (Bicarbonate [Moles/volume] in Serum)
-- 	Bilirubine: 3024128 (Total Bilirubin serum/plasma)
 
-- Note:
-- The score is also calculated for neonates, but it is likely inappropriate to actually use the score values for these patients.

DROP MATERIALIZED VIEW IF EXISTS SAPSII CASCADE;
CREATE MATERIALIZED VIEW SAPSII AS

-- -----------------------------------------------------------------------------
-- DEMOGRAPHICS
-- -----------------------------------------------------------------------------

WITH AGE AS 
(
	SELECT person_id, visit_occurrence_id
	, EXTRACT(EPOCH FROM visit_start_datetime  - birth_datetime)/60.0/60.0/24.0/365.25 AS age
        FROM omop.visit_occurrence
        LEFT JOIN omop.person USING (person_id)
),

-- Distinct visit_concept_id 
-- 	9201, inpatient visit
-- 	262, emergency room and inpatient visit to unplanned medical care (urgent care)
ADMISSION_TYPE AS
(
	SELECT person_id, visit_occurrence_id
	, visit_concept_id AS admission_concept_id
	FROM visit_occurrence v
	JOIN concept c ON c.concept_id = v.visit_concept_id
),

first_services AS
(
        SELECT visit_occurrence_id, min(visit_start_datetime) AS visit_start_datetime
        FROM visit_detail
        WHERE visit_type_concept_id = 45770670
        GROUP BY visit_occurrence_id

),

-- Distinct visit_detail_concept_id 
-- 	45763735, General medical service
--     	4149152, Surgical service
--     	4237225, Newborn care service
SURGICAL_MEDICAL_PATIENTS AS
(
        SELECT vd.person_id, vd.visit_occurrence_id
	, vd.visit_detail_concept_id AS surgical_medical_concept_id
        FROM visit_detail vd
        JOIN first_services fs
        ON fs.visit_occurrence_id = vd.visit_occurrence_id
        AND vd.visit_start_datetime = fs.visit_start_datetime
        AND vd.visit_type_concept_id = 45770670
),

ADMISSION_TYPE_FOR_SAPS AS 
(
	SELECT at.person_id, at.visit_occurrence_id
	, CASE WHEN smp.surgical_medical_concept_id = 45763735 THEN 'medical'
	       WHEN smp.surgical_medical_concept_id = 4149152 AND
		at.admission_concept_id = 262 THEN 'urgent_surgery'
	       WHEN smp.surgical_medical_concept_id = 4149152 AND
		at.admission_concept_id = 9201 THEN 'elective_surgery'
	END AS admision_type_saps
	FROM ADMISSION_TYPE at
	JOIN SURGICAL_MEDICAL_PATIENTS smp USING (visit_occurrence_id)
),

COMORBIDITY AS
(
        SELECT co.person_id, co.visit_occurrence_id
        , MAX(CASE WHEN co.condition_concept_id = 439727 THEN 1 END) AS aids 	-- Human immunodeficiency virus infection
        , MAX(CASE WHEN a.ancestor_concept_id = 4189640 THEN 1 END) AS hemato 	-- Neoplasm of hematopoietic cell type
        , MAX(CASE WHEN a.ancestor_concept_id = 4032806 THEN 1 END) AS metas  	-- Neoplasm, metastatic
        FROM condition_occurrence co
        JOIN concept_ancestor a ON a.descENDant_concept_id = co.condition_concept_id
        WHERE co.condition_type_concept_id BETWEEN 38000184 			-- Inpatient detail - 1st position
                                     AND 38000198 				-- Inpatient detail - 15th position
           OR co.condition_type_concept_id BETWEEN 44818709 			-- Inpatient detail - 16th position
                                      AND 44818713 				-- Inpatient detail - 20th position
        AND co.person_id = 886234
        GROUP BY co.person_id, co.visit_occurrence_id
),

-- -----------------------------------------------------------------------------
-- ICU Stays
-- -----------------------------------------------------------------------------

ICUSTAYS AS
(
	SELECT person_id, visit_occurrence_id, visit_detail_id
	, visit_start_datetime, visit_start_datetime + interval '1 day' AS visit_start_one_day
	FROM visit_detail
	WHERE visit_detail_concept_id = 32037                             	-- concept.concept_name = 'Intensive Care'
	AND visit_type_concept_id = 2000000006                            	-- concept.concept_name = 'Ward and physical location'
),

-- -----------------------------------------------------------------------------
-- NEUROLOGICAL ORGAN FAILURE
-- -----------------------------------------------------------------------------

standardisation AS
(
        SELECT icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
        , m.measurement_date
        , m.measurement_concept_id
        , CASE
	-- endotrach/vent is assigned a value of 0
                WHEN m.measurement_concept_id = 3009094 AND m.value_source_value IN ('1.0 ET/Trach', 'No Response-ETT') THEN 0
                ELSE m.value_as_number
                END AS value_as_number
        FROM measurement m
	JOIN icustays icu USING (visit_occurrence_id)
        WHERE TRUE
        AND m.measurement_type_concept_id = 44818701 				-- concept_name :    From physical examination
        AND m.measurement_concept_id IN
        (
                3009094         						-- concept_name :       Glasgow coma score verbal
                , 3016335       						-- concept_name :       Glasgow coma score eye opening
                , 3008223       						-- concept_name :       Glasgow coma score motor
        )
	AND m.measurement_datetime BETWEEN icu.visit_start_datetime and icu.visit_start_one_day
),
glasgows_first_day AS
(
        SELECT icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
        , MIN(CASE WHEN measurement_concept_id = 3008223 THEN value_as_number ELSE null END) AS GCS_Motor
        , MIN(CASE WHEN measurement_concept_id = 3009094 THEN value_as_number ELSE null END) AS GCS_Verbal
        , MIN(CASE WHEN measurement_concept_id = 3016335 THEN value_as_number ELSE null END) AS GCS_Eye

        -- If verbal was set to 0 in the below SELECT, THEN this is an intubated patient
        , CASE
                WHEN MAX(CASE WHEN measurement_concept_id = 3009094 THEN value_as_number ELSE null END) = 0 THEN 1
                ELSE 0
                END AS ETT_flag
        FROM standardisation
	JOIN icustays icu USING (visit_occurrence_id)
        GROUP BY  icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
),
GLASGOW_FIRST_DAY AS
(
        SELECT person_id, visit_occurrence_id, visit_detail_id
        , GCS_Motor
        , GCS_Verbal
        , GCS_Eye
        , CASE WHEN GCS_Motor is not null and GCS_Verbal is not Null and GCS_Eye is not Null
        THEN GCS_Motor + GCS_Verbal + GCS_Eye ELSE null END AS GCS
        , ETT_flag
        FROM glasgows_first_day
),

-- -----------------------------------------------------------------------------
-- CARDIOLOGIC ORGAN FAILURE
-- -----------------------------------------------------------------------------
PRESSURE_FIRST_DAY AS
(
        SELECT icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
        , MIN(m.value_as_number) AS SAP_min
        , MAX(m.value_as_number) AS SAP_max
        FROM measurement m
	JOIN icustays icu USING (visit_occurrence_id) 
        WHERE TRUE
        AND m.measurement_type_concept_id = 44818701 				-- concept_name :    From physical examination
        AND m.measurement_concept_id = 3004249 					-- concept_name :    Systolic blood pressure
        AND m.value_as_number IS NOT null AND m.value_as_number > 0 and m.value_as_number <= 400
	AND m.measurement_datetime BETWEEN icu.visit_start_datetime and icu.visit_start_one_day
        GROUP BY  icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
),

HEART_RATE_FIRST_DAY AS
(
        SELECT icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
        , MIN(m.value_as_number) AS heart_rate_min
        , MAX(m.value_as_number) AS heart_rate_max
        FROM measurement m
	JOIN icustays icu USING (visit_occurrence_id) 
        WHERE TRUE
        AND m.measurement_type_concept_id = 44818701 				-- concept_name :   From physical examination
        AND m.measurement_concept_id = 3027018 					-- concept_name :   Heart rate
        AND m.value_as_number IS NOT null AND m.value_as_number > 0 and m.value_as_number <= 300
	AND m.measurement_datetime BETWEEN icu.visit_start_datetime and icu.visit_start_one_day
        GROUP BY  icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
),

-- -----------------------------------------------------------------------------
-- RESPIRATORY ORGAN FAILURE
-- -----------------------------------------------------------------------------

PAO2FIO2 AS
(
        SELECT icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
        , MIN(m.value_as_number) AS PF_min
        FROM measurement m
	JOIN icustays icu USING (visit_occurrence_id) 
        WHERE TRUE
        AND m.measurement_type_concept_id = 45754907 				-- concept_name :    From physical examination
        AND m.measurement_concept_id = 4233883 					-- concept_name :    Ratio of arterial oxygen tension to inspired oxygen
        AND m.value_as_number IS NOT null AND m.value_as_number > 0
	AND m.measurement_datetime BETWEEN icu.visit_start_datetime and icu.visit_start_one_day
        GROUP BY  icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
),

-- -----------------------------------------------------------------------------
-- RENAL ORGAN FAILURE
-- -----------------------------------------------------------------------------

UO AS
(
        SELECT icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
        , SUM(m.value_as_number) AS urine_output
        FROM measurement m
	JOIN icustays icu USING (visit_occurrence_id) 
        WHERE TRUE
        AND m.measurement_type_concept_id = 2000000003 				-- concept_name    Output Event
        AND m.measurement_concept_id = 3014315 					-- concept_name    Urine output
        AND m.value_as_number IS NOT null
	AND m.measurement_datetime BETWEEN icu.visit_start_datetime and icu.visit_start_one_day
        GROUP BY  icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
),

-- -----------------------------------------------------------------------------
-- TEMPERATURE
-- -----------------------------------------------------------------------------

TEMPERATURE AS
(
        SELECT icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
        , MIN(m.value_as_number) AS temperature_min
        , MAX(m.value_as_number) AS temperature_max
        FROM measurement m
	JOIN icustays icu USING (visit_occurrence_id) 
        WHERE TRUE
        AND m.measurement_type_concept_id = 44818701 				-- concept_name :    From physical examination
        AND m.measurement_concept_id = 3020891 					-- concept_name :    Body temperature
        AND m.value_as_number IS NOT null AND m.value_as_number > 0
	AND m.measurement_datetime BETWEEN icu.visit_start_datetime and icu.visit_start_one_day
        GROUP BY  icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
),


-- -----------------------------------------------------------------------------
-- BIOLOGICAL EXAMS
-- -----------------------------------------------------------------------------

LABORATORY AS
(
        SELECT icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
        , MIN(CASE WHEN m.measurement_concept_id = 3003282 THEN value_as_number ELSE NULL END) AS wbc_min
        , MAX(CASE WHEN m.measurement_concept_id = 3003282 THEN value_as_number ELSE NULL END) AS wbc_max
        , MIN(CASE WHEN m.measurement_concept_id = 3023103 THEN value_as_number ELSE NULL END) AS potassium_min
        , MAX(CASE WHEN m.measurement_concept_id = 3023103 THEN value_as_number ELSE NULL END) AS potassium_max
	, MIN(CASE WHEN m.measurement_concept_id = 3019550 THEN value_as_number ELSE NULL END) AS sodium_min
        , MAX(CASE WHEN m.measurement_concept_id = 3019550 THEN value_as_number ELSE NULL END) AS sodium_max
        , MAX(CASE WHEN m.measurement_concept_id = 3013682 THEN value_as_number ELSE NULL END) AS urea_max
	, MIN(CASE WHEN m.measurement_concept_id = 3016293 THEN value_as_number ELSE NULL END) AS bicarbonate_min
	, MAX(CASE WHEN m.measurement_concept_id = 3024128 THEN value_as_number ELSE NULL END) AS bilirubin_max
        FROM measurement m
	JOIN icustays icu USING (visit_occurrence_id) 
        WHERE TRUE
        AND m.measurement_type_concept_id IN
        (
                2000000009 							-- concept_name : Labs - Hemato
                , 2000000010 							-- concept_name : Labs - Blood Gaz
		, 2000000011 							--concept_name  : Labs - Chemistry
        )
        AND m.measurement_concept_id IN
        (        
		3003282 							-- concept_name : Leukocytes [#/volume] in Blood by Manual count
                , 3023103 							-- concept_name : Potassium serum/plASma
                , 3019550 							-- concept_name : Sodium serum/plASma
                , 3013682 							-- concept_name : Urea nitrogen serum/plASma
                , 3016293 							-- concept_name : Bicarbonate [Moles/volume] in Serum
                , 3024128 							-- concept_name : Total Bilirubin serum/plASma
        )
        AND m.value_as_number IS NOT null AND m.value_as_number > 0
	AND m.measurement_datetime BETWEEN icu.visit_start_datetime and icu.visit_start_one_day
        GROUP BY  icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
),

-- -----------------------------------------------------------------------------
-- Finally compute score
-- -----------------------------------------------------------------------------
TOTAL AS
(
	SELECT
	icu.person_id, icu.visit_occurrence_id, icu.visit_detail_id
	, age
	, admision_type_saps
	, aids
	, hemato
	, metas
	, g.GCS
	, g.ETT_flag
	, pressure.SAP_min
	, pressure.SAP_max
	, hr.heart_rate_min
	, hr.heart_rate_max
	, pf.PF_min
	, temp.temperature_min
	, temp.temperature_max
	, UO.urine_output
	, lab.wbc_min
	, lab.wbc_max
	, lab.potassium_min
	, lab.potassium_max
	, lab.sodium_min
	, lab.sodium_max
	, lab.urea_max
	, lab.bicarbonate_min
	, lab.bilirubin_max
	FROM ICUSTAYS icu
	LEFT JOIN AGE USING (visit_occurrence_id)
	LEFT JOIN ADMISSION_TYPE USING (visit_occurrence_id)
	LEFT JOIN SURGICAL_MEDICAL_PATIENTS USING (visit_occurrence_id)
	LEFT JOIN ADMISSION_TYPE_FOR_SAPS USING (visit_occurrence_id)  
	LEFT JOIN COMORBIDITY USING (visit_occurrence_id)
	LEFT JOIN GLASGOW_FIRST_DAY g using (visit_detail_id)
	LEFT JOIN PRESSURE_FIRST_DAY pressure USING (visit_detail_id)
	LEFT JOIN HEART_RATE_FIRST_DAY hr USING (visit_detail_id)
	LEFT JOIN PAO2FIO2 pf USING (visit_detail_id)
	LEFT JOIN UO USING (visit_detail_id)
	LEFT JOIN LABORATORY lab USING (visit_detail_id)
	LEFT JOIN TEMPERATURE temp USING (visit_detail_id)
),

SCORE_PARAMS AS
(
	SELECT total.*
  	, CASE
      		WHEN age is null THEN null
      		WHEN age <  40 THEN 0
      		WHEN age <  60 THEN 7
      		WHEN age <  70 THEN 12
      		WHEN age <  75 THEN 15
      		WHEN age <  80 THEN 16
      		WHEN age >= 80 THEN 18
    	END AS age_score

    	, CASE
        	WHEN admision_type_saps = 'elective_surgery' THEN 0
        	WHEN admision_type_saps = 'medical' THEN 6
        	WHEN admision_type_saps = 'urgent_surgery' THEN 8
        	ELSE null
      	END AS admissiontype_score
	
	, CASE
        	WHEN aids = 1 THEN 17
        	WHEN hemato  = 1 THEN 10
        	WHEN metas = 1 THEN 9
        	ELSE 0
      	END AS comorbidity_score

	, CASE
      		WHEN GCS is null THEN null
       	 	WHEN GCS <  3 THEN null -- erroneous value/on trach
        	WHEN GCS <  6 THEN 26
        	WHEN GCS <  9 THEN 13
        	WHEN GCS < 11 THEN 7
        	WHEN GCS < 14 THEN 5
        	WHEN GCS = 14 or GCS = 15
          	THEN 0
        END AS gcs_score

    	, CASE
      		WHEN heart_rate_min is null or heart_rate_max is null THEN null
      		WHEN heart_rate_min <   40 THEN 11
      		WHEN heart_rate_max >= 160 THEN 7
      		WHEN heart_rate_max >= 120 THEN 4
      		WHEN heart_rate_min  <  70 THEN 2
      		ELSE 0
    	END AS heart_rate_score

  	, CASE
      		WHEN SAP_min is null or SAP_max is null THEN null
      		WHEN SAP_min <   70 THEN 13
      		WHEN SAP_min <  100 THEN 5
      		WHEN SAP_max >= 200 THEN 2
      		ELSE 0
    	END AS SAP_score

  	, CASE
      		WHEN temperature_min is null or temperature_max is null THEN null
      		WHEN temperature_max <  39.0 THEN 0
      		WHEN temperature_max >= 39.0 THEN 3
    	END AS temp_score

  	, CASE
      		WHEN PF_min is null THEN null
      		WHEN PF_min <  100 THEN 11
      		WHEN PF_min <  200 THEN 9
      		WHEN PF_min >= 200 THEN 6
    	END AS PF_score

  	, CASE
      		WHEN urine_output is null THEN null
      		WHEN urine_output < 500.0 THEN 11
      		WHEN urine_output <  1000.0 THEN 4
      		WHEN urine_output >= 1000.0 THEN 0
    	END AS uo_score

  	, CASE
      		WHEN urea_max is null THEN null
      		WHEN urea_max <  60.0 THEN 0
      		WHEN urea_max <  180.0 THEN 6
      		WHEN urea_max >= 180.0 THEN 10
    	END AS urea_score

  	, CASE
      		WHEN wbc_min is null or wbc_max is null THEN null
      		WHEN wbc_min <   1.0 THEN 12
      		WHEN wbc_max >= 20.0 THEN 3
      		ELSE 0
    	END AS wbc_score

	, CASE
      		WHEN potassium_max is null or wbc_min is null THEN null
		WHEN potassium_min <  3.0 then 3
      		WHEN potassium_max >= 5.0 then 3
		ELSE 0
      END AS potassium_score

  	, CASE
      		WHEN sodium_max is null then null
      		WHEN sodium_min  < 125 then 5
      		WHEN sodium_max >= 145 then 1
		ELSE 0
      	END AS sodium_score

  	, CASE
		WHEN bicarbonate_min is null then null
      		WHEN bicarbonate_min <  15.0 then 5
      		WHEN bicarbonate_min <  20.0 then 3
		ELSE 0
      	END AS bicarbonate_score

  	, CASE
      		WHEN bilirubin_max is null THEN null
      		WHEN bilirubin_max  < 4.0 THEN 0
      		WHEN bilirubin_max  < 6.0 THEN 4
      		WHEN bilirubin_max >= 6.0 THEN 9
      	END AS bilirubin_score

FROM TOTAL
),
-- Calculate SAPS II here so we can use it in the probability calculation below
SCORE as
(
	SELECT s.*

  	, CASE WHEN age_score IS null THEN 1
         	WHEN admissiontype_score IS null THEN 1
         	WHEN comorbidity_score IS null THEN 1
         	WHEN gcs_score IS null THEN 1
       	  	WHEN heart_rate_score IS null THEN 1
         	WHEN SAP_score IS null THEN 1
         	WHEN temp_score IS null THEN 1
         	WHEN PF_score IS null THEN 1
         	WHEN uo_score IS null THEN 1
         	WHEN urea_score IS null THEN 1
         	WHEN wbc_score IS null THEN 1
         	WHEN potassium_score IS null THEN 1
         	WHEN sodium_score IS null THEN 1
         	WHEN bicarbonate_score IS null THEN 1
         	WHEN bilirubin_score IS null THEN 1
		ELSE 0 
	END AS missing_data_warning -- SAPSII could be false because one or more datas are missing

  	, ETT_flag as ETT_warning -- glasgow score could be false because the patient is intubated and can't speak or is sedated

  	, COALESCE(age_score,0)
  		+ COALESCE(admissiontype_score,0)
  		+ COALESCE(comorbidity_score,0)
  		+ COALESCE(gcs_score,0)
  		+ COALESCE(heart_rate_score,0)
  		+ COALESCE(SAP_score,0)
  		+ COALESCE(temp_score,0)
  		+ COALESCE(PF_score,0)
  		+ COALESCE(uo_score,0)
  		+ COALESCE(urea_score,0)
  		+ COALESCE(wbc_score,0)
  		+ COALESCE(potassium_score,0)
  		+ COALESCE(sodium_score,0)
  		+ COALESCE(bicarbonate_score,0)
  		+ COALESCE(bilirubin_score,0)
    	AS SAPSII
  	FROM SCORE_PARAMS s
)

SELECT person_id, visit_occurrence_id, visit_detail_id
, SAPSII
, 1 / (1 + exp(- (-7.7631 + 0.0737*(SAPSII) + 0.9971*(ln(SAPSII + 1))) )) as SAPSII_PROB
, missing_data_warning
, ETT_warning
, age_score
, admissiontype_score
, comorbidity_score
, gcs_score
, heart_rate_score
, SAP_score
, temp_score
, PF_score
, uo_score
, urea_score
, wbc_score
, potassium_score
, sodium_score
, bicarbonate_score
, bilirubin_score
FROM SCORE;
