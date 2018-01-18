# Link to CommonDataModel
- [MEASUREMENT](https://github.com/OHDSI/CommonDataModel/wiki/MEASUREMENT)

# Source Tables

- when measures are mapped to standard concepts (SMOMED) measurement_concept_id != 0
  you may use the non-omop mimic itemid
- else `measurement_concept_id` = 0
  you have to select measures with non-omop mimic itemid : `measurement_source_concept_id`

- when `visit_detail_id` is assigned, this is a calculated value!

## [charteevents](https://mimic.physionet.org/mimictables/chartevents/)

- rows in error have not been exported from mimic

## [labevents](https://mimic.physionet.org/mimictables/labevents/)

- when flag is abnormal then `value_as_concept_id` refers to LOINC code for " abnormal", else "non abnormal" and null when unknown
- logical Observation Identifiers Names and Codes (LOINC) = database and universal standard for identifying medical laboratory observations loinc.csv

## [microbiologyevents](https://mimic.physionet.org/mimictables/microbiologyevents/)

## [outputevents](https://mimic.physionet.org/mimictables/outputevents/)

## [inputevents_mv](https://mimic.physionet.org/mimictables/inputevents_mv/)

- the patient weigth has a `measurement_type_concept_id` = 44818701 (from physical examination) and a `concept_id` = 3025315 (body weight)
- this is similar to the weight comming from chartevents

# Mapping used for `measurement_concept_id`

## charteevents

- https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/chart_label_to_concept.csv

## labevents

- https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/lab_label_to_concept.csv
- https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/lab_unit_to_concept.csv
- https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/lab_value_to_concept.csv

# Examples

## Introduction

### different date types
-- that's better to filter your queries with data types !
SELECT concept_name, concept_id, COUNT(1)
FROM measurement
JOIN concept ON measurement_type_concept_id = concept_id
GROUP BY concept_name, concept_id ORDER BY COUNT(1) DESC;

## different operator types
SELECT distinct operator_concept_id, concept_name
FROM omop.measurement
JOIN omop.concept on operator_concept_id = concept_id;

## From physical examination

### the most frequent items, by using omop concept_id
SELECT concept_name, concept_id, count (1)
FROM omop.measurement
JOIN omop.concept ON measurement_concept_id = concept_id
WHERE measurement_type_concept_id = 44818701                      		-- concept_name = 'From physical examination'
GROUP BY concept_name, concept_id ORDER BY count(concept_name) DESC
LIMIT 10;

### the most frequent items, by using non omop mimic itemid
SELECT concept_name, concept_code, count (1)
FROM omop.measurement
JOIN omop.concept ON measurement_source_concept_id = concept_id
WHERE measurement_type_concept_id = 44818701                      		-- concept_name = 'From physical examination'
GROUP BY concept_name, concept_code ORDER BY count(concept_name) DESC
LIMIT 10;

### weights, by using omop `measurement_concept_id`
SELECT MIN(value_as_number), AVG(value_as_number), MAX(value_as_number)
FROM measurement 
WHERE measurement_concept_id = 3025315;             				-- concept.concept_name = 'Body weight'

### weights, by using non omop mimic items
-- to see all the items mapped, see above (mapping usee section) 
SELECT MIN(value_as_number), AVG(value_as_number), MAX(value_as_number) 
FROM measurement JOIN concept ON measurement_source_concept_id = concept_id 
WHERE concept_code = '762' or concept_code = '226531' or concept_code = '226512';

## From labs

### the most frequent items, by using omop `measurement_concept_id`
SELECT concept_name, concept_code, count (1)
FROM omop.measurement
JOIN omop.concept ON measurement_source_concept_id = concept_id
WHERE measurement_type_concept_id = 44818702                      		-- concept_name = 'Lab results'
GROUP BY concept_name, concept_code ORDER BY count(concept_name) DESC
LIMIT 10;
 
### white blood cells values by using LOINC classification, ie 804-5 or 26464-8
SELECT MIN(value_as_number), AVG(value_as_number), MAX(value_as_number)
FROM measurement 
WHERE measurement_source_value = '804-5' OR measurement_source_value = '26464-8';

### white blood cells value by non omop mimic items
SELECT MIN(value_as_number), AVG(value_as_number), MAX(value_as_number)
FROM measurement JOIN concept on measurement_source_concept_id = concept_id
WHERE concept_code = '51300' or concept_code = '51301';


## From cultures

### Nb of negative blood cultures
SELECT count(1)
FROM omop.measurement
where measurement_type_concept_id = 2000000007   				-- concept.concept_name = 'Labs - Culture Organisms'
and value_as_concept_id = 9189;                  				-- concept.concept_name = 'Negative'

### Main place of collection
SELECT concept_name, concept_id 
FROM concept 
WHERE concept_id IN
	 (SELECT distinct measurement_concept_id 
         FROM omop.measurement WHERE
          measurement_type_concept_id = 2000000007);     -- concept.concept_name = 'Labs - Culture Organisms'

###  most frequent microorganisms in blood culture
SELECT concept_name, value_as_concept_id, count(1)
FROM omop.measurement m
JOIN omop.concept c on c.concept_id = m.value_as_concept_id
WHERE measurement_type_concept_id = 2000000007        				-- concept.concept_name = 'Labs - Culture Organisms'
And value_as_concept_id != 9189                       				-- concept.concept_name = 'Negative'
AND measurement_concept_id = 46235217                 				-- concept.concept_name = 'Bacteria identified in Blood product unit.autologous by Culture'
GROUP BY concept_name, value_as_concept_id order by count(1) desc;
-- resistance profile resitance for staoh. aureus
SELECT measurement_source_value, value_as_concept_id, concept_name
FROM measurement
JOIN concept resistance ON value_as_concept_id = concept_id
JOIN fact_relationship ON measurement_id =  fact_id_2
JOIN
(
	SELECT measurement_id AS id_is_staph
	FROM omop.measurement m
	WHERE measurement_type_concept_id = 2000000007        			-- concept.concept_name = 'Labs - Culture Organisms'
	AND value_as_concept_id = 4149419                     			-- concept.concept_name = 'staph aureus coag +'
	AND measurement_concept_id = 46235217               			-- concept.concept_name = 'Bacteria identified in Blood product unit.autologous by Culture';
) staph ON id_is_staph = fact_id_1;

### %  of MRSA
WITH tmp as
(
  SELECT COUNT(DISTINCT sarm.measurement_id) AS SARM
	, COUNT(DISTINCT m.measurement_id) AS total
  FROM omop.measurement m
  LEFT JOIN
  (
	SELECT measurement_id
	FROM measurement
	JOIN concept resistance ON value_as_concept_id = concept_id
	JOIN fact_relationship ON measurement_id =  fact_id_2
	JOIN
	(
		SELECT measurement_id AS id_is_staph
		FROM omop.measurement m
		WHERE measurement_type_concept_id = 2000000007        		-- concept.concept_name = 'Labs - Culture Organisms'
		AND value_as_concept_id = 4149419                            	-- concept.concept_name = 'staph aureus coag +'
		AND measurement_concept_id = 46235217                         	-- concept.concept_name = 'Bacteria identified in Blood product unit.autologous by Culture';
	
	) staph ON id_is_staph = fact_id_1
	WHERE measurement_concept_id = 3008504    	                        -- concept.concept_name = 'Vancomycin [Susceptibility] by Disk diffusion (KB)'
	and value_as_concept_id = 4148441                                       -- concept.concept_name = 'Resistant'
  
  ) sarm USING (measurement_id)
  WHERE measurement_type_concept_id = 2000000007        			-- concept.concept_name = 'Labs - Culture Organisms'
  AND value_as_concept_id = 4149419                                  		-- concept.concept_name = 'staph aureus coag +'
  AND measurement_concept_id = 46235217                         		-- concept.concept_name = 'Bacteria identified in Blood product unit.autologous by Culture';

)
SELECT SARM, total, SARM * 100 / total as percentage from tmp;
