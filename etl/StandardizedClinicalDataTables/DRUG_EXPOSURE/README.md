# Link to CommonDataModel
- [DRUG_EXPOSURE](https://github.com/OHDSI/CommonDataModel/wiki/DRUG_EXPOSURE)

# Source Tables (mimic)

## [prescriptions](https://mimic.physionet.org/mimictables/prescriptions/)

- omitted, rows which not have any `enddate`. They are only 5K on 4M. Since `drug_exposure_end_date` cannot be null.
- mapped to RxNorm done by Paul Church 
- drug_type_concept_id` = 38000177
- sig contains informations of doses (workaround)
- visit_detail_id is not assigned; this is because there is no time information and therefore no sufficient precision

## [inputevents_cv](https://mimic.physionet.org/mimictables/inputevents_cv/)

- `drug_type_concept_id` = 38000180
- `drug_exposure_end_datetime` is always null (because there is no end charttime in inputevents_cv)
- `visit_detail_id` is assigned

## [inputevents_mv](https://mimic.physionet.org/mimictables/inputevents_cv/)

- `drug_type_concept_id` = 38000180
- row with cancelled have not been exported from mimic 
- `visit_detail_id` is assigned

# Mapping used

## [continue_unit_carevue](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/continuous_unit_carevue.csv)

- add good format to units

## [inputevents_drug](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/inputevents_drug_to_concept.csv)

- it maps common drugs from inputevents

## [route](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/map_route_to_concept.csv)

- it maps common route of drugs from inputevents

# Examples

## explanation of `drug_type_concept_id`

``` sql
SELECT concept_name, drug_type_concept_id, count(1)
FROM drug_exposure
JOIN concept ON drug_type_concept_id = concept_id
GROUP BY concept_name, drug_type_concept_id ORDER BY count(1) desc;
```
|       concept_name       | drug_type_concept_id | count |
|--------------------------|----------------------|-------|
| Inpatient administration |             38000180 | 53225|
| Prescription written     |             38000177 |  9715|

## explanation of the `route_concept_id`

``` sql
SELECT distinct(concept_name) 
FROM drug_exposure 
JOIN concept ON route_concept_id = concept_id;
```
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

## repartition of drug, with non omop mimic labels

``` sql
-- as used in prescriptions table (= prescribed medications)
SELECT drug_source_value, count(1)
FROM drug_exposure
WHERE drug_type_concept_id = 38000177                                  		-- concept.concept_name = 'Prescription written'
GROUP BY 1 ORDER BY count(1) desc limit 10;
```
|  drug_source_value   | count |
|----------------------|-------|
| Potassium Chloride   |   477|
| 0.9% Sodium Chloride |   378|
| D5W                  |   334|
| NS                   |   297|
| Insulin              |   274|
| Furosemide           |   253|
| Iso-Osmotic Dextrose |   238|
| Magnesium Sulfate    |   220|
| SW                   |   198|
| Acetaminophen        |   183|

## repartition of drug, with omop concept = RxNorm mapping

``` sql
-- as used in prescriptions table (= prescribed medications)
SELECT concept_id, concept_name, count(1)
FROM drug_exposure
JOIN CONCEPT  ON drug_concept_id = concept_id
WHERE drug_type_concept_id = 38000177 						-- concept.concept_name = 'Prescription written'
GROUP BY 1, 2 ORDER BY count(1) desc limit 10;
```
| concept_id |                 concept_name                  | count |
|------------|-----------------------------------------------|-------|
|   19096877 | Anhydrous Dextrose                            |   407|
|          0 | No matching concept                           |   385|
|     967823 | Sodium Chloride                               |   322|
|   19010309 | Water                                         |   260|
|   40220357 | 1000 ML Sodium Chloride 9 MG/ML Injection     |   205|
|   36249737 | 250 ML Glucose 50 MG/ML Injection             |   199|
|    1718752 | 50 ML Potassium Chloride 0.4 MEQ/ML Injection |   165|
|    1596977 | Regular Insulin, Human                        |   164|
|   40221385 | 100 ML Sodium Chloride 9 MG/ML Injection      |   152|
|   35603227 | 4 ML Furosemide 10 MG/ML Injection            |   139|

##  drugs are linked in fact_relationship table

```sql
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
                WHERE drug_type_concept_id = 38000180 				-- concept.concept_name = 'Inpatient administration'
 
	)
) as couple
JOIN drug_exposure drug_1 ON drug_1.drug_exposure_id = fact_id_1
JOIN drug_exposure drug_2 ON drug_2.drug_exposure_id = fact_id_2
WHERE drug_1 != drug_2
limit 10;
```
|         drug_1         |         drug_2|
|------------------------|------------------------|
| Nitroglycerin          | Nitroglycerin|
| Fentanyl (Concentrate) | Fentanyl (Concentrate)|
| Fentanyl (Concentrate) | Solution|
| Midazolam (Versed)     | Midazolam (Versed)|
| Calcium Gluconate      | Piggyback|
| Fentanyl (Concentrate) | Solution|
| Norepinephrine         | Norepinephrine|
| Vancomycin             | Dextrose 5%|
| Phenylephrine          | NaCl 0.9%|
| Propofol               | Solution|

##  to extract only the non omop mimic id from inputevents_cv

``` sql
-- warning : when the drug is IV, with a rate record, drug_exposure_end_datetime is always null
-- warning : when the drug is IV, whis an amount recorded drug_exposure_start_datetime is always null
SELECT *
FROM drug_exposure
WHERE drug_source_concept_id IN 
(
	SELECT concept_id 
	FROM concept  
	WHERE concept_name ILIKE '%carevue%'
)
AND drug_type_concept_id = 38000180; 						-- concept.concept_name = 'Inpatient administration'
```

##  to extract only the non omop mimic id from inputevents_cv

``` sql
SELECT *
FROM drug_exposure
WHERE drug_source_concept_id IN 
(
	SELECT concept_id 
	FROM concept  
	WHERE concept_name ILIKE '%metavision%'
)
AND drug_type_concept_id = 38000180; 						-- concept.concept_name = 'Inpatient administration'
```

##  to find drug IV, continuous in rate 

``` sql
SELECT distinct on (drug_source_value) quantity, dose_unit_source_value, drug_source_value, drug_source_concept_id, drug_exposure_start_datetime, drug_exposure_end_datetime
FROM drug_exposure
WHERE route_concept_id = 45879918                                                 -- concept.concept_name = 'Infusion, intravenous catheter, continuous'
AND dose_unit_source_value ILIKE '%/%'
ORDER BY drug_source_value, drug_exposure_start_datetime
LIMIT 10;
```
|   quantity   | dose_unit_source_value |     drug_source_value      | drug_source_concept_id | drug_exposure_start_datetime | drug_exposure_end_datetime |
|--------------|------------------------|----------------------------|------------------------|------------------------------|----------------------------|
|          300 | mL/hour                | Albumin 25%                |             2001030521 | 2135-05-17 18:22:00          | 2135-05-17 17:22:00|
|    499.99998 | mL/hour                | Albumin 5%                 |             2001030523 | 2130-11-14 19:19:00          | 2130-11-14 18:49:00|
|    1.0016694 | mg/min                 | Amiodarone                 |             2001027331 | 2101-06-06 23:44:00          | 2101-06-06 17:00:00|
|          0.5 | mg/hour                | Ativan                     |             2001024300 | 2110-06-18 11:00:00          | |
| 0.1000033297 | mg/kg/hour             | Cisatracurium              |             2001027337 | 2181-05-20 22:06:00          | 2181-05-20 21:57:00|
|   49.9999986 | mL/hour                | D5 1/2NS                   |             2001028689 | 2130-08-13 09:00:00          | 2130-08-13 04:00:00|
|   49.9999986 | mL/hour                | D5LR                       |             2001028691 | 2181-05-23 19:56:00          | 2181-05-23 11:10:00|
|   249.991524 | mL/hour                | D5NS                       |             2001028690 | 2185-08-14 14:56:00          | 2185-08-14 11:00:00|
| 0.2001280807 | mcg/kg/hour            | Dexmedetomidine (Precedex) |             2001030569 | 2133-11-15 03:00:00          | 2133-11-14 20:25:00|
|          150 | mL/hour                | Dextrose 5%                |             2001030526 | 2101-06-02 02:49:00          | 2101-06-01 20:10:00|

##  to find drug IV, continuous in amount

``` sql
SELECT distinct on (drug_source_value) quantity, dose_unit_source_value, drug_source_value, drug_source_concept_id, drug_exposure_start_datetime, drug_exposure_end_datetime
FROM drug_exposure
WHERE route_concept_id = 45879918                                                 -- concept.concept_name = 'Infusion, intravenous catheter, continuous'
AND dose_unit_source_value NOT ILIKE '%/%'
ORDER BY drug_source_value, drug_exposure_start_datetime 
LIMIT 10;
```
|  quantity  | dose_unit_source_value | drug_source_value  | drug_source_concept_id | drug_exposure_start_datetime | drug_exposure_end_datetime |
|------------|------------------------|--------------------|------------------------|------------------------------|----------------------------|
|        100 | ml                     | .45% Normal Saline |             2001024228 |                              | 2193-02-08 22:00:00|
|        125 | ml                     | .9% Normal Saline  |             2001024227 |                              | 2115-09-10 23:00:00|
|  2.0000001 | grams                  | Calcium Gluconate  |             2001027335 | 2101-06-02 02:30:00          | 2101-06-02 01:30:00|
|        200 | ml                     | D5/.45NS           |             2001024225 |                              | 2160-12-23 20:00:00|
|         10 | ml                     | D5W                |             2001023343 |                              | 2177-08-21 08:00:00|
|        0.1 | mg                     | Folate             |             2001024257 |                              | 2132-07-17 02:00:00|
| 1.00000004 | mg                     | Folic Acid         |             2001028694 | 2130-08-14 17:36:00          | 2130-08-14 17:16:00|
|        2.5 | mEq                    | KCL                |             2001023347 |                              | 2131-08-05 15:00:00|
| 10.0000008 | mmol                   | K Phos             |             2001028696 | 2119-05-27 16:00:00          | 2119-05-27 15:00:00|
|        250 | ml                     | Lactated Ringers   |             2001023345 |                              | 2140-03-18 00:00:00|
