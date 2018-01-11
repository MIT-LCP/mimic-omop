# URL to CommonDataModel
- https://github.com/OHDSI/CommonDataModel/wiki/MEASUREMENT

# Source Tables
- when measures are mapped to standard concepts (SMOMED) measurement_concept_id != 0
  you may use the non-omop mimic itemid
- else measurement_concept_id = 0 and you have to select measures with non-omop mimic itemid

## charteevents

## labevents

# Help

## charteevents

- csv files used for mapping:
  https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/chart_label_to_concept.csv

## labevents

- csv files used for mapping:
  https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/lab_label_to_concept.csv
  https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/lab_unit_to_concept.csv
  https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/lab_value_to_concept.csv
- Logical Observation Identifiers Names and Codes (LOINC) = database and universal standard for identifying medical laboratory observations
  loinc.csv

# Example
``` sql
-- different data types 
SELECT concept_name, concept_id, COUNT(1)
FROM measurement
JOIN concept ON measurement_type_concept_id = concept_id
GROUP BY concept_name, concept_id ORDER BY COUNT(1) DESC;
```
       concept_name        | concept_id | count
---------------------------+------------+-------
 Lab result                |   44818702 | 71884
 From physical examination |   44818701 | 40291
 Output Event              | 2000000003 | 10784

```sql 
-- !! different operator types
SELECT distinct operator_concept_id, concept_name
FROM omop.measurement
JOIN omop.concept on operator_concept_id = concept_id;
```
 operator_concept_id | concept_name
---------------------+--------------
             4171754 | <=
             4171756 | <
             4172704 | >
             4172703 | =
             4171755 | >=

``` sql
-- the most frequent items, from physical examination
SELECT concept_name, concept_code, count (1)
FROM omop.measurement
JOIN omop.concept ON measurement_source_concept_id = concept_id
WHERE measurement_type_concept_id = 44818701                      -- concept_name = 'From physical examination'
GROUP BY concept_name, concept_code ORDER BY count(concept_name) DESC
LIMIT 10;
```
            concept_name              | concept_code | count
---------------------------------------+--------------+-------
 Heart Rate                            | 220045       |  5262
 Respiratory Rate                      | 220210       |  5229
 O2 saturation pulseoxymetry           | 220277       |  5098
 Non Invasive Blood Pressure diastolic | 220180       |  2839
 Non Invasive Blood Pressure systolic  | 220179       |  2838
 Non Invasive Blood Pressure mean      | 220181       |  2825
 Arterial Blood Pressure diastolic     | 220051       |  2430
 Arterial Blood Pressure systolic      | 220050       |  2430
 Arterial Blood Pressure mean          | 220052       |  2429
 Temperature Fahrenheit                | 223761       |  1209

``` sql
-- the most frequent items, from lab results
SELECT concept_name, concept_code, count (1)
FROM omop.measurement
JOIN omop.concept ON measurement_source_concept_id = concept_id
WHERE measurement_type_concept_id = 44818702                      -- concept_name = 'Lab results'
GROUP BY concept_name, concept_code ORDER BY count(concept_name) DESC
LIMIT 10;
```
             concept_name             | concept_code | count
--------------------------------------+--------------+-------
 Hematocrit[Blood][Hematology]        | 51221        |  2055
 Potassium[Blood][Chemistry]          | 50971        |  1857
 Sodium[Blood][Chemistry]             | 50983        |  1782
 Platelet Count[Blood][Hematology]    | 51265        |  1777
 Creatinine[Blood][Chemistry]         | 50912        |  1774
 Urea Nitrogen[Blood][Chemistry]      | 51006        |  1770
 Chloride[Blood][Chemistry]           | 50902        |  1755
 Hemoglobin[Blood][Hematology]        | 51222        |  1741
 White Blood Cells[Blood][Hematology] | 51301        |  1736
 MCHC[Blood][Hematology]              | 51249        |  1728
 

``` sql
-- all the weight items of mimic carevue and metavision linked by chart_label_to_concept.csv, itemid of non omop mimic database IN (762, 226531, 226512)
SELECT MIN(value_as_number), AVG(value_as_number), MAX(value_as_number)
FROM measurement 
WHERE measurement_concept_id = 3025315;             -- concept.concept_name = 'Body weight'
```
    min     |         avg         |  max
------------+---------------------+-------
 44.1798608 | 79.6892679260869565 | 118.9

``` sql
-- same requests by using itemid of non omop mimic database, ie itemid IN (762, 226531, 226512)
-- to see all the items mapped, see above (help section)
SELECT MIN(value_as_number), AVG(value_as_number), MAX(value_as_number) 
FROM measurement JOIN concept ON measurement_source_concept_id = concept_id 
WHERE concept_code = '762' or concept_code = '226531' or concept_code = '226512';
```
    min     |         avg         |  max
------------+---------------------+-------
 44.1798608 | 79.6892679260869565 | 118.9

``` sql
-- distribution of white blood cells values by using LOINC classification, ie 804-5 or 26464-8
SELECT MIN(value_as_number), AVG(value_as_number), MAX(value_as_number)
FROM measurement 
WHERE measurement_source_value = '804-5' OR measurement_source_value = '26464-8';
```
 min |         avg         |  max
-----+---------------------+-------
 1.4 | 10.7514744693057946 | 116.5

``` sql
-- same request by using itemid of non omop mimic database, ie itemid IN (51300, 51301)
SELECT MIN(value_as_number), AVG(value_as_number), MAX(value_as_number)
FROM measurement JOIN concept on measurement_source_concept_id = concept_id
WHERE concept_code = '51300' or concept_code = '51301';
```
 min |         avg         |  max
-----+---------------------+-------
 1.4 | 10.7514744693057946 | 116.5
