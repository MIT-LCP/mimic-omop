WITH
"drug_strength" AS (
	SELECT
  drug_concept_id
, ingredient_concept_id
, amount_value
, amount_unit_concept_id
, numerator_value
, numerator_unit_concept_id
, denominator_value
, denominator_unit_concept_id
, box_size
, valid_start_date
, valid_end_date
, invalid_reason
FROM omop.drug_strength
where amount_value is not null
),
"filter_on_drug_exposure" as (
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
, visit_occurrence_id
, visit_detail_id
, drug_source_value
, drug_source_concept_id
, route_source_value
, dose_unit_source_value
FROM omop.drug_exposure
WHERE TRUE
AND dose_unit_source_value IN ('TAB', 'mg', 'g', 'dose', 'SUPP', 'TAB', 'LOZ', 'TROC')
AND quantity IS NOT NULL
),
"insert_dose_era" as (
	SELECT
nextval('mimic_id_seq') as dose_era_id
, person_id
, drug_exposure.drug_concept_id
, coalesce(drug_strength.amount_unit_concept_id, 0) AS  unit_concept_id      -- some unit are null, that's odd
, case when dose_unit_source_value = 'mg' then quantity::double precision
       when dose_unit_source_value = 'g' then quantity::double precision
       when amount_value is not null then quantity * amount_value
       when denominator_value is null then quantity * numerator_value
       else numerator_value / denominator_value * quantity end as dose_value
, drug_exposure_start_date             AS dose_era_start_date
, drug_exposure_end_date               AS dose_era_end_date     --we removed not null constraint
FROM filter_on_drug_exposure drug_exposure
JOIN drug_strength USING (drug_concept_id)
)
INSERT INTO omop.dose_era
SELECT
  dose_era_id         
, person_id           
, drug_concept_id     
, unit_concept_id     
, dose_value          
, dose_era_start_date 
, dose_era_end_date   
from insert_dose_era;
