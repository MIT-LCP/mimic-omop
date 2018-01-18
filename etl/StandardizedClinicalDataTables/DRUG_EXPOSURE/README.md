# Link to CommonDataModel
- [DRUG_EXPOSURE](https://github.com/OHDSI/CommonDataModel/wiki/DRUG_EXPOSURE)

# Source Tables

## [prescriptions](https://mimic.physionet.org/mimictables/prescriptions/)

- omitted, rows which not have any `enddate`. They are only 5K on 4M. Since `drug_exposure_end_date` cannot be null.
- mapped to RxNorm done by Paul Church Paul 
- drug_type_concept_id` = 38000177
- sig contains informations of doses (workaround)
- visit_detail_id is not assigned; this is because there is no time information and therefore no sufficient precision

## [inputevents_cv](https://mimic.physionet.org/mimictables/inputevents_cv/)

- `drug_type_concept_id` = 38000180
- `drug_exposure_end_datetime` is always null (because there is no end charttime in inputevents_cv)
- visit_detail_id is assigned

## [inputevents_mv](https://mimic.physionet.org/mimictables/inputevents_cv/)

- `drug_type_concept_id` = 38000180
- row with cancelled have not been exported from mimic 
- visit_detail_id is assigned

# Example

## explanation of `drug_type_concept_id`
SELECT concept_name, drug_type_concept_id, count(1) 
FROM drug_exposure 
JOIN concept ON drug_type_concept_id = concept_id 
GROUP BY concept_name, drug_type_concept_id ORDER BY count(1) desc;

## explanation of the `route_concept_id`
SELECT distinct(concept_name) 
FROM drug_exposure 
JOIN concept ON route_concept_id = concept_id;
```
;
                    concept_name
----------------------------------------------------
 Intraocular
 Infusion, intravenous catheter, continuous
 Subcutaneous
 Injection, intravenous, rapid push
 Nasal
 No matching concept
 Sublingual
 Buccal
 Oral
 Intrathecal
 Intraperitoneal
 Rectal
 Endotracheopulmonary
 Intracerebroventricular
 Genitourinary therapy
 Auricular
 Administration of substance via oral route
 Intramuscular
 Administration of substance via subcutaneous route
 Intravenous injection
 Regional perfusion
 Intraarticular
 Intravaginal
 Inhalation
 Haemodialysis
 Intraventricular cardiac
 Transdermal
 Epidural
 Topical
 Intravenous
 Intrapleural

``` sql
-- repartition of drug 
-- as used in prescriptions table (= prescribed medications), with non omop mimic labels
-- = prescribed medications
SELECT drug_source_value, count(1)
FROM drug_exposure
WHERE drug_type_concept_id = 38000177                                  		concept.concept_name = 'Prescription written'
GROUP BY 1 ORDER BY count(1) desc;
```

``` sql
-- repartition of drug 
-- as used in prescriptions table (= prescribed medications), with omop concept = RxNorm mapping
SELECT concept_id, concept_name, count(1)
FROM drug_exposure
JOIN CONCEPT  ON drug_concept_id = concept_id
WHERE drug_type_concept_id = 38000177 						concept.concept_name = 'Prescription written'
GROUP BY 1, 2 ORDER BY count(1) desc;
```

``` sql 
-- drugs are linked in fact_relationship table
-- two levels of links to represent linkorderid and orderid in mimic
SELECT drug_1.drug_source_value as drug_1, drug_2.drug_source_value as drug_2
FROM
(
        SELECT fact_id_1, fact_id_2
        FROM fact_relationship
        WHERE fact_id_1 IN
	(
                SELECT drug_exposure_id
                FROM drug_exposure
                WHERE drug_type_concept_id = 38000180 				concept.concept_name = 'Inpatient administration'
 
	)

) as couple
JOIN drug_exposure drug_1 ON drug_1.drug_exposure_id = fact_id_1
JOIN drug_exposure drug_2 ON drug_2.drug_exposure_id = fact_id_2
WHERE drug_1 != drug_2
limit 10;
```
         drug_1         |         drug_2
------------------------+------------------------
 Nitroglycerin          | Nitroglycerin
 Fentanyl (Concentrate) | Fentanyl (Concentrate)
 Fentanyl (Concentrate) | Solution
 Midazolam (Versed)     | Midazolam (Versed)
 Calcium Gluconate      | Piggyback
 Fentanyl (Concentrate) | Solution
 Norepinephrine         | Norepinephrine
 Vancomycin             | Dextrose 5%
 Phenylephrine          | NaCl 0.9%
 Propofol               | Solution

``` sql
-- to extract only the non omop mimic id from inputevents_cv
-- warning : when the drug is IV, continuous, drug_exposure_end_datetime is always null
-- warning : when the drug is IV, bolus drug_exposure_start_datetime is always null
SELECT * 
FROM concept 
WHERE concept_class_id ILIKE '%carevue%'
AND drug_type_concept_id = 3800080; 						concept.concept_name = 'Inpatient administration'
```

``` sql
-- to extract only the non omop mimic id from inputevents_mv
SELECT * 
FROM concept 
WHERE concept_class_id ILIKE '%metavision%'
AND drug_type_concept_id = 3800080; 						concept.concept_name = 'Inpatient administration'
```

```sql
-- to find drug IV, continuous in amount 
SELECT distinct on (drug_source_value) quantity, dose_unit_source_value, drug_source_value, drug_source_concept_id, drug_exposure_start_datetime, drug_exposure_end_datetime
FROM drug_exposure
AND route_concept_id = 45879918                                                 concept.concept_name = 'Infusion, intravenous catheter, continuous'
AND dose_unit_source_value NOT ILIKE '%/%' order by drug_source_value, 6 ;
```

```sql
-- to find drug IV, continuous in rate
SELECT distinct on (drug_source_value) quantity, dose_unit_source_value, drug_source_value, drug_source_concept_id, drug_exposure_start_datetime, drug_exposure_end_datetime
FROM drug_exposure
AND route_concept_id = 45879918                                                 concept.concept_name = 'Infusion, intravenous catheter, continuous'
AND dose_unit_source_value ILIKE '%/%' order by drug_source_value, 6 ;
```
