-- from drug_exposure
WITH
"google_drug_table" AS (SELECT drug_exposure_id as row_id, drug_concept_id::text as concept_code, route_concept_id, route_source_value, effective_drug_dose, dose_unit_concept_id, dose_unit_source_value FROM mimic.gcpt_gdata_drug_exposure JOIN prescriptions ON (drug_exposure_id = row_id)),
"omop_rxnorm" AS (SELECT concept_id as drug_concept_id, concept_code FROM  omop.concept WHERE domain_id = 'Drug' AND vocabulary_id = 'RxNorm'),
"drug_exposure" AS (
                              SELECT drug as drug_source_value
                                   , 'drug_type:['||coalesce(drug_type,'')||']'|| 'drug:['||coalesce(drug,'')||']'|| 'drug_name_poe:['||coalesce(drug_name_poe,'')||']'|| 'drug_name_generic:['||coalesce(drug_name_generic,'')||']'|| 'formulary_drug_cd:['||coalesce(formulary_drug_cd,'')||']'|| 'gsn:['||coalesce(gsn,'')||']'|| 'ndc:['||coalesce(ndc,'')||']' as concept_name
                                   , subject_id
                                   , hadm_id
                                   , row_id
                                   , form_val_disp
                                   , mimic_id as drug_exposure_id
                                   , startdate as drug_exposure_start_datetime
                                   , enddate as drug_exposure_end_datetime
                FROM prescriptions
                     )
                   , 
"patients" AS (SELECT subject_id, mimic_id as person_id from patients),
"admissions" AS (SELECT hadm_id, mimic_id as visit_occurrence_id FROM admissions),
"omop_local_drug" AS (SELECT concept_name, concept_id as drug_source_concept_id FROM omop.concept WHERE domain_id = 'prescriptions' AND concept_cod,e = 'MIMIC Generated'),
"row_to_insert" AS (
	SELECT 
  drug_exposure_id
, person_id
, coalesce(drug_concept_id, 0) as drug_concept_id
, drug_exposure_start_datetime::date as drug_exposure_start_date
, (drug_exposure_start_datetime) AS drug_exposure_start_datetime
, drug_exposure_end_datetime::date as drug_exposure_end_date
, (drug_exposure_end_datetime) AS drug_exposure_end_datetime
, null::date as verbatim_end_date
, 38000177 as drug_type_concept_id
, null::text as stop_reason
, null::integer as refills
, CASE when form_val_disp ~'^[0-9,.]+$' then regexp_replace(form_val_disp, '([0-9]*)([,]+)([0-9]*)', E'\\1.\\3','g')::numeric 
 ELSE null::numeric END as quantity --extract quantity from pure numeric
, null::integer as days_supply
, null::text  as sig 
, route_concept_id
, null::text as lot_number
, null::integer as provider_id
, visit_occurrence_id
, null::integer as visit_detail_id
, drug_exposure.drug_source_value
, drug_source_concept_id
, route_source_value
, dose_unit_source_value
FROM drug_exposure
LEFT JOIN omop_local_drug USING (concept_name)
LEFT JOIN google_drug_table USING (row_id)
LEFT JOIN omop_rxnorm USING (concept_code)
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
)
INSERT INTO omop.drug_exposure
SELECT
  row_to_insert.drug_exposure_id
, row_to_insert.person_id
, row_to_insert.drug_concept_id
, row_to_insert.drug_exposure_start_date
, row_to_insert.drug_exposure_start_datetime
, row_to_insert.drug_exposure_end_date
, row_to_insert.drug_exposure_end_datetime
, row_to_insert.verbatim_end_date
, row_to_insert.drug_type_concept_id
, row_to_insert.stop_reason
, row_to_insert.refills
, row_to_insert.quantity
, row_to_insert.days_supply
, row_to_insert.sig
, row_to_insert.route_concept_id
, row_to_insert.lot_number
, row_to_insert.provider_id
, row_to_insert.visit_occurrence_id
, row_to_insert.visit_detail_id
, row_to_insert.drug_source_value
, row_to_insert.drug_source_concept_id
, row_to_insert.route_source_value
, row_to_insert.dose_unit_source_value
FROM row_to_insert;

-- MEASUREMENT / inputevent
-- ajouter champs unit_concept_id
-- type =  38000180 -- Inpatient administration
-- route = 4112421 -- intravenous ()

-- inputevent_mv
-- route_concept_source = ordercategorydescription (ordercategoryname)
-- -> CREER les deux concepts
-- cgid provider
-- privilegie rate
-- stop reason: statusdescription
-- quality_concept_id : when 1 then cancel else ok. --> infered from data.
-- when orderid then fact_relationship with 44818791 -- Has temporal context [SNOMED]
-- weight into observation/measurement
WITH 
"inputevents_mv" AS (
SELECT 
  mimic_id AS drug_exposure_id
, subject_id
, hadm_id
, itemid
, cgid
, starttime as drug_exposure_end_datetime
, endtime as drug_exposure_start_datetime
, CASE WHEN rate IS NOT NULL THEN rate WHEN amount IS NOT NULL THEN amount ELSE NULL END AS quantity
, CASE WHEN rate IS NOT NULL THEN rateuom WHEN amount IS NOT NULL THEN amountuom ELSE NULL END AS dose_unit_source_value
, 38000180 AS drug_type_concept_id -- Inpatient administration
--, 4112421 as route_concept_id -- intraveous
, orderid = linkorderid as is_leader -- other input are linked to it/them
, first_value(mimic_id) over(partition by orderid order by starttime ASC) = mimic_id as is_orderid_leader -- other input are linked to it/them
, linkorderid
, orderid
, ordercategorydescription || ' (' || ordercategoryname || ')' AS route_source_value
, statusdescription as stop_reason
, ordercategoryname
, cancelreason
FROM inputevents_mv
WHERE cancelreason = 0
),
"rxnorm_map" AS (SELECT distinct on (drug_source_value) concept_id as drug_concept_id, drug_source_value FROM mimic.gcpt_gdata_drug_exposure LEFT JOIN omop.concept ON drug_concept_id::text = concept_code AND domain_id = 'Drug' WHERE drug_concept_id IS NOT NULL),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"gcpt_inputevents_drug_to_concept" AS (SELECT itemid, concept_id as drug_concept_id FROM gcpt_inputevents_drug_to_concept),
"gcpt_mv_input_label_to_concept" AS (SELECT DISTINCT ON (item_id) item_id as itemid, concept_id as drug_concept_id FROM gcpt_mv_input_label_to_concept),
"gcpt_map_route_to_concept" AS (SELECT concept_id as route_concept_id, ordercategoryname FROM gcpt_map_route_to_concept),
"caregivers" AS (SELECT mimic_id AS provider_id, cgid FROM caregivers),
"d_items" AS (SELECT itemid, label as drug_source_value, mimic_id as drug_source_concept_id FROM d_items),
"fact_relationship" AS (
INSERT INTO omop.fact_relationship 
(
  domain_concept_id_1     
, fact_id_1               
, domain_concept_id_2     
, fact_id_2               
, relationship_concept_id 

)
SELECT
DISTINCT 
  13 As fact_id_1 --Drug
,  mv2.drug_exposure_id AS domain_concept_id_1
, 13 As fact_id_2 --Drug
, mv1.drug_exposure_id AS domain_concept_id_2
, 44818791 AS relationship_concept_id -- Has temporal context [SNOMED]
FROM inputevents_mv mv1
LEFT JOIN inputevents_mv mv2 ON (mv2.orderid = mv1.linkorderid AND mv2.is_leader IS TRUE)
),
"fact_relationship_order" AS (
INSERT INTO omop.fact_relationship 
(
  domain_concept_id_1     
, fact_id_1               
, domain_concept_id_2     
, fact_id_2               
, relationship_concept_id 

)
SELECT
DISTINCT 
  13 As fact_id_1 --Drug
,  mv2.drug_exposure_id AS domain_concept_id_1
, 13 As fact_id_2 --Drug
, mv1.drug_exposure_id AS domain_concept_id_2
, 44818784 AS relationship_concept_id -- Has associated procedure [SNOMED]
FROM inputevents_mv mv1
LEFT JOIN inputevents_mv mv2 ON (mv2.orderid = mv1.orderid AND mv2.is_orderid_leader IS TRUE)
),
"row_to_insert" AS (
SELECT
  drug_exposure_id
, person_id
, coalesce(rxnorm_map.drug_concept_id, gcpt_inputevents_drug_to_concept.drug_concept_id, gcpt_mv_input_label_to_concept.drug_concept_id, 0) AS drug_concept_id
, drug_exposure_start_datetime::date AS drug_exposure_start_date
, drug_exposure_start_datetime
, drug_exposure_end_datetime::date AS drug_exposure_end_date
, drug_exposure_end_datetime
, null::date as verbatim_end_date
, drug_type_concept_id
, stop_reason
, null::integer as refills
, quantity
, null::integer as days_supply
, null::text as sig
, coalesce(route_concept_id, 0) as route_concept_id
, null::integer as lot_number
, provider_id
, visit_occurrence_id
, null::integer AS visit_detail_id
, drug_source_value
, d_items.drug_source_concept_id
, route_source_value
, dose_unit_source_value
FROM inputevents_mv
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN caregivers USING (cgid)
LEFT JOIN gcpt_inputevents_drug_to_concept USING (itemid)
LEFT JOIN gcpt_mv_input_label_to_concept USING (itemid)
LEFT JOIN gcpt_map_route_to_concept USING (ordercategoryname)
LEFT JOIN d_items USING (itemid)
LEFT JOIN rxnorm_map USING (drug_source_value)
)
INSERT INTO omop.drug_exposure
SELECT 
  drug_exposure_id
, person_id
, drug_concept_id
, drug_exposure_start_date
, drug_exposure_start_datetime
, drug_exposure_end_date
, drug_exposure_end_datetime
, verbatim_end_date
, drug_type_concept_id
, stop_reason
, refills
, quantity
, days_supply
, sig
, route_concept_id
, lot_number
, provider_id
, row_to_insert.visit_occurrence_id
, visit_detail_assign.visit_detail_id
, drug_source_value
, drug_source_concept_id
, route_source_value
, dose_unit_source_value
FROM row_to_insert
LEFT JOIN omop.visit_detail_assign 
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND row_to_insert.drug_exposure_start_datetime IS NOT NULL
AND
(--only one visit_detail
(is_first IS TRUE AND is_last IS TRUE)
OR -- first
(is_first IS TRUE AND is_last IS FALSE AND row_to_insert.drug_exposure_start_datetime <= visit_detail_assign.visit_end_datetime)
OR -- last
(is_last IS TRUE AND is_first IS FALSE AND row_to_insert.drug_exposure_start_datetime > visit_detail_assign.visit_start_datetime)
OR -- middle
(is_last IS FALSE AND is_first IS FALSE AND row_to_insert.drug_exposure_start_datetime > visit_detail_assign.visit_start_datetime AND row_to_insert.drug_exposure_start_datetime <= visit_detail_assign.visit_end_datetime)
);

-- inputevent_cv
-- when rate chattime -> start 
-- when amount charttime  -> end
-- stopped as is -> stop_reason
-- concept_id gcpt_inputevents_drug_to_concept, gcpt_mv_input_label_to_concept, gcpt_cv_input_label_to_concept
-- route = NULL  (!= originalroute, original* never considered)
WITH
"inputevents_cv" AS  (
SELECT
  mimic_id AS drug_exposure_id
, subject_id
, hadm_id
, cgid
, itemid
 --when rate then start date, when amount then end date (from mimic docuemntaiton)
, CASE WHEN rate IS NOT NULL THEN charttime WHEN  amount IS NULL THEN charttime END as drug_exposure_start_datetime
, CASE WHEN rate IS NULL AND amount IS NOT NULL THEN charttime ELSE NULL END as drug_exposure_end_datetime
, CASE WHEN rate IS NOT NULL THEN rate WHEN amount IS NOT NULL THEN amount ELSE NULL END as quantity
, CASE WHEN rate IS NOT NULL THEN rateuom WHEN amount IS NOT NULL THEN amountuom ELSE NULL END as dose_unit_source_value
, 38000180 AS drug_type_concept_id -- Inpatient administration
--, 4112421 as route_concept_id -- intraveous
, orderid = linkorderid as is_leader -- other input are linked to it/them
, orderid 
, linkorderid
, originalroute
, stopped as stop_reason
FROM inputevents_cv
),
"patients" AS (SELECT mimic_id AS person_id, subject_id FROM patients),
"admissions" AS (SELECT mimic_id AS visit_occurrence_id, hadm_id FROM admissions),
"rxnorm_map" AS (SELECT DISTINCT ON (drug_source_value) concept_id as drug_concept_id, drug_source_value FROM mimic.gcpt_gdata_drug_exposure LEFT JOIN omop.concept ON drug_concept_id::text = concept_code AND domain_id = 'Drug' WHERE drug_concept_id IS NOT NULL),
"gcpt_inputevents_drug_to_concept" AS (SELECT itemid, concept_id as drug_concept_id FROM gcpt_inputevents_drug_to_concept),
"gcpt_cv_input_label_to_concept" AS (SELECT DISTINCT ON (item_id) item_id as itemid, concept_id as drug_concept_id FROM gcpt_mv_input_label_to_concept),
"caregivers" AS (SELECT mimic_id AS provider_id, cgid FROM caregivers),
"gcpt_map_route_to_concept" AS (SELECT concept_id as route_concept_id, ordercategoryname as originalroute FROM gcpt_map_route_to_concept),
"d_items" AS (SELECT itemid, label as drug_source_value, mimic_id as drug_source_concept_id FROM d_items),
"gcpt_continuous_unit_carevue.csv" as (
	select dose_unit_source_value, dose_unit_source_value_new
 from gcpt_continuous_unit_carevue),
"fact_relationship" AS (
INSERT INTO omop.fact_relationship 
(
  domain_concept_id_1     
, fact_id_1               
, domain_concept_id_2     
, fact_id_2               
, relationship_concept_id 
)
SELECT
DISTINCT
  13 As fact_id_1 --Drug
,  cv2.drug_exposure_id AS domain_concept_id_1
, 13 As fact_id_2 --Drug
, cv1.drug_exposure_id AS domain_concept_id_2
, 44818791 AS relationship_concept_id -- Has temporal context [SNOMED]
FROM inputevents_cv cv1
LEFT JOIN inputevents_cv cv2 ON (cv2.orderid = cv1.linkorderid AND cv2.is_leader IS TRUE)
WHERE cv2.drug_exposure_id IS NOT NULL
RETURNING *
),
"row_to_insert" AS (
SELECT
  drug_exposure_id
, person_id
, coalesce(rxnorm_map.drug_concept_id, gcpt_inputevents_drug_to_concept.drug_concept_id, gcpt_cv_input_label_to_concept.drug_concept_id, 0) AS drug_concept_id
, drug_exposure_start_datetime::date AS drug_exposure_start_date
, drug_exposure_start_datetime
, drug_exposure_end_datetime::date AS drug_exposure_end_date
, drug_exposure_end_datetime
, null::date as verbatim_end_date
, drug_type_concept_id
, stop_reason
, null::integer as refills
, quantity
, null::integer as days_supply
, null::text as sig
, coalesce(route_concept_id,0) as route_concept_id
, null::integer as lot_number
, provider_id
, visit_occurrence_id
, null::integer AS visit_detail_id
, drug_source_value
, d_items.drug_source_concept_id
, null::text route_source_value
, coalesce(gcpt_continuous_unit_carevue.dose_unit_source_value_new, dose_unit_source_value) as dose_unit_source_value
FROM inputevents_cv
LEFT JOIN patients USING (subject_id)
LEFT JOIN admissions USING (hadm_id)
LEFT JOIN caregivers USING (cgid)
LEFT JOIN gcpt_inputevents_drug_to_concept USING (itemid)
LEFT JOIN gcpt_cv_input_label_to_concept USING (itemid)
LEFT JOIN d_items USING (itemid)
LEFT JOIN rxnorm_map USING (drug_source_value)
LEFT JOIN gcpt_map_route_to_concept USING (originalroute)
LEFT JOIN gcpt_continuous_unit_carevue USING (dose_unit_source_value)
)
INSERT INTO omop.drug_exposure
SELECT 
  drug_exposure_id
, person_id
, drug_concept_id
, drug_exposure_start_date
, drug_exposure_start_datetime
, drug_exposure_end_date
, drug_exposure_end_datetime
, verbatim_end_date
, drug_type_concept_id
, stop_reason
, refills
, quantity
, days_supply
, sig
, route_concept_id
, lot_number
, provider_id
, row_to_insert.visit_occurrence_id
, visit_detail_assign.visit_detail_id
, drug_source_value
, drug_source_concept_id
, route_source_value
, dose_unit_source_value
FROM row_to_insert
LEFT JOIN omop.visit_detail_assign 
ON row_to_insert.visit_occurrence_id = visit_detail_assign.visit_occurrence_id
AND row_to_insert.drug_exposure_start_datetime IS NOT NULL
AND
(--only one visit_detail
(is_first IS TRUE AND is_last IS TRUE)
OR -- first
(is_first IS TRUE AND is_last IS FALSE AND row_to_insert.drug_exposure_start_datetime <= visit_detail_assign.visit_end_datetime)
OR -- last
(is_last IS TRUE AND is_first IS FALSE AND row_to_insert.drug_exposure_start_datetime > visit_detail_assign.visit_start_datetime)
OR -- middle
(is_last IS FALSE AND is_first IS FALSE AND row_to_insert.drug_exposure_start_datetime > visit_detail_assign.visit_start_datetime AND row_to_insert.drug_exposure_start_datetime <= visit_detail_assign.visit_end_datetime)
);

