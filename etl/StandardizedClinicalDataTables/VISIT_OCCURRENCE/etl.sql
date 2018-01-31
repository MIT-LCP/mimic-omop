WITH 
"admissions_emerged" AS (SELECT subject_id, admission_location, discharge_location, mimic_id, coalesce(edregtime, admittime) AS admittime, dischtime, admission_type, edregtime, diagnosis FROM admissions ),
"admissions" AS (
                           SELECT subject_id
                                , admission_location
                                , discharge_location
                                , mimic_id as visit_occurrence_id
                                , CASE WHEN edregtime IS NOT NULL THEN 262 ELSE 9201 END as visit_concept_id
                                , admittime::date as visit_start_date
                                , admittime as visit_start_datetime
                                , dischtime::date as visit_end_date
                                , dischtime as visit_end_datetime
                                , 44818518 as visit_type_concept_id
                                , admission_type as visit_source_value
                                , admission_location as admitting_source_value
                                , discharge_location as discharge_to_source_value
				, diagnosis
                                , LAG(mimic_id) OVER ( PARTITION BY subject_id ORDER BY admittime ASC) as preceding_visit_occurrence_id
             FROM admissions_emerged
                  ), 
"patients" AS (SELECT subject_id, mimic_id as person_id FROM patients),
"gcpt_admission_type_to_concept" AS (SELECT mimic_id as visit_source_concept_id, admission_type as visit_source_value FROM gcpt_admission_type_to_concept),
"gcpt_admission_location_to_concept" AS (SELECT concept_id as admitting_concept_id, mimic_id as admitting_source_concept_id, admission_location FROM gcpt_admission_location_to_concept),
"gcpt_discharge_location_to_concept" AS (SELECT concept_id as discharge_to_concept_id, mimic_id as discharge_to_source_concept_id, discharge_location FROM gcpt_discharge_location_to_concept),
"care_site" as (select care_site_id from omop.care_site where care_site_name = 'BIDMC') -- Beth Israel hospital for all 
 INSERT INTO omop.VISIT_OCCURRENCE
 SELECT
   admissions.visit_occurrence_id
 , patients.person_id
 , admissions.visit_concept_id
 , admissions.visit_start_date
 , admissions.visit_start_datetime
 , admissions.visit_end_date
 , admissions.visit_end_datetime
 , admissions.visit_type_concept_id
 , null::integer as provider_id                    
 , care_site.care_site_id
 , gcpt_admission_type_to_concept.visit_source_value
 , gcpt_admission_type_to_concept.visit_source_concept_id
 , CASE WHEN diagnosis ~* 'organ donor' THEN  4216643 -- DEAD/EXPIRED
        ELSE gcpt_admission_location_to_concept.admitting_concept_id END AS admitting_concept_id --
 , CASE WHEN diagnosis ~* 'organ donor' THEN 'DEAD/EXPIRED'
        ELSE gcpt_admission_location_to_concept.admission_location END AS admitting_source_value
 , gcpt_admission_location_to_concept.admitting_source_concept_id
 , CASE WHEN diagnosis ~* 'organ donor' THEN 4022058 --ORGAN DONOR
        ELSE gcpt_discharge_location_to_concept.discharge_to_concept_id END AS discharge_to_concept_id --
 ,CASE WHEN diagnosis ~* 'organ donor' THEN diagnosis
       ELSE gcpt_discharge_location_to_concept.discharge_location END AS  discharge_to_source_value
 , gcpt_discharge_location_to_concept.discharge_to_source_concept_id
 , admissions.preceding_visit_occurrence_id
   FROM admissions
 LEFT JOIN gcpt_admission_location_to_concept USING (admission_location)
 LEFT JOIN gcpt_discharge_location_to_concept USING (discharge_location) 
 LEFT JOIN gcpt_admission_type_to_concept USING (visit_source_value) 
 LEFT JOIN patients USING (subject_id)
 left join care_site ON (1=1) 
;
