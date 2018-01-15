# URL to CommonDataModel
- https://github.com/OHDSI/CommonDataModel/wiki/DRUG_EXPOSURE

# Source Tables

## prescriptions

- omitted, rows which not have any `enddate`. They are only 5K on 4M. Since `drug_exposure_end_date` cannot be null.
- mapped to RxNorm done by Paul Church Paul 
- drug_type_concept_id` = 38000177
- quantity is the number of doses
- visit_detail_id is not assigned; this is because there is no time information and therefore no sufficient precision

## inputevents_cv

- `drug_type_concept_id` = 38000180
- `drug_exposure_end_datetime` is always null (because there is no end charttime in inputevents_cv)
- visit_detail_id is assigned

## inputevents_mv

- `drug_type_concept_id` = 38000180
- row with cancelled have not been exported from mimic 
- visit_detail_id is assigned

# Example
``` sql
-- explanation of the drug_type_concept_id
SELECT concept_name, drug_type_concept_id, count(1) 
FROM drug_exposure 
JOIN concept ON drug_type_concept_id = concept_id 
GROUP BY concept_name, drug_type_concept_id ORDER BY count(1) desc;
```
       concept_name       | drug_type_concept_id |  count
--------------------------+----------------------+----------
 Inpatient administration |             38000180 | 21146926
 Prescription written     |             38000177 |  4151052

``` sql
-- explanation of the drug_type_concept_id
SELECT distinct(concept_name) 
FROM drug_exposure 
JOIN concept ON route_concept_id = concept_id;
```
SELECT distinct(concept_name) from drug_exposure JOIN concept ON route_concept_id = concept_id
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
-- as used in prescriptions table (= prescribed medications), with mimic labels
-- = prescribed medications
SELECT drug_source_value, count(1)
FROM drug_exposure
WHERE drug_type_concept_id = 38000177
GROUP BY 1 ORDER BY count(1) desc;
```

``` sql
-- repartition of drug 
-- as used in prescriptions table (= prescribed medications), with RxNorm mapping
SELECT concept_id, concept_name, count(1)
FROM drug_exposure
JOIN CONCEPT  ON drug_concept_id = concept_id
WHERE drug_type_concept_id = 38000177
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
                WHERE drug_type_concept_id = 38000180
 
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
