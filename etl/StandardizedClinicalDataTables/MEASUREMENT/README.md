# URL to CommonDataModel
- https://github.com/OHDSI/CommonDataModel/wiki/MEASUREMENT

# Source Tables

- when measures are mapped to standard concepts (SMOMED) measurement_concept_id != 0
  you may use the non-omop mimic itemid
- else measurement_concept_id = 0 and you have to select measures with non-omop mimic itemid

## charteevents

- rows in error have not been exported from mimic
- visit_detail_id is assigned

## labevents

- when flag is abnormal then this is described in the value_as_concept_id field

## microbiologyevents

## outputevents

- visit_detail_id is assigned

# Help

## charteevents

- csv files used for mapping:
  https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/chart_label_to_concept.csv

## labevents

- csv files used for mapping:
  https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/lab_label_to_concept.csv
  https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/lab_unit_to_concept.csv
  https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/lab_value_to_concept.csv
- Logical Observation Identifiers Names and Codes (LOINC) = database and universal standard for identifying medical laboratory observations loinc.csv
- when flag is abnormal then value_as_concept_id refers to LOINC code for " abnormal", else "non abnormal" and null when unknown

# Example

## Introduction
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

## From physical examination

``` sql
-- the most frequent items, from physical examination
-- -- with mimic itemid
SELECT concept_name, concept_code, count (1)
FROM omop.measurement
JOIN omop.concept ON measurement_source_concept_id = concept_id
WHERE measurement_type_concept_id = 44818701                      		-- concept_name = 'From physical examination'
GROUP BY concept_name, concept_code ORDER BY count(concept_name) DESC
LIMIT 10;
```

``` sql
-- the most frequent items, from physical examination
-- -- with omop concept_id
SELECT concept_name, concept_id, count (1)
FROM omop.measurement
JOIN omop.concept ON measurement_concept_id = concept_id
WHERE measurement_type_concept_id = 44818701                      		-- concept_name = 'From physical examination'
GROUP BY concept_name, concept_id ORDER BY count(concept_name) DESC
LIMIT 10;
```
            concept_name             | concept_id | count
-------------------------------------+------------+--------
 No matching concept                 |          0 | 395843
 Respiratory rate                    |    3024171 |  19056
 Heart rate                          |    3027018 |  16496
 Oxygen saturation in Arterial blood |    3016502 |  16233
 BP systolic                         |    3004249 |  14443
 BP diastolic                        |    3012888 |  14402
 Mean blood pressure                 |    3027598 |  14360
 Body temperature                    |    3020891 |   8612
 Heart rate rhythm                   |    3022318 |   7896
 Oxygen concentration breathed       |    3020716 |   3842

``` sql
-- all the weight items of mimic carevue and metavision linked by chart_label_to_concept.csv, itemid of non omop mimic database IN (762, 226531, 226512)
SELECT MIN(value_as_number), AVG(value_as_number), MAX(value_as_number)
FROM measurement 
WHERE measurement_concept_id = 3025315;             				-- concept.concept_name = 'Body weight'
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

## From labs

``` sql
-- the most frequent items, from lab results
-- -- don't use measurement_concept_id because too many are not matched
SELECT concept_name, concept_code, count (1)
FROM omop.measurement
JOIN omop.concept ON measurement_source_concept_id = concept_id
WHERE measurement_type_concept_id = 44818702                      		-- concept_name = 'Lab results'
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


## From cultures
```sql
-- Nb of negative blood cultures
SELECT count(*)
FROM omop.measurement
where measurement_type_concept_id = 2000000007   				-- concept.concept_name = 'Labs - Culture Organisms'
and value_as_concept_id = 9189;                  				-- concept.concept_name = 'Negative'
```

```sql 
SELECT concept_name, concept_id 
FROM concept 
WHERE concept_id IN
	 (SELECT distinct measurement_concept_id 
         FROM omop.measurement WHERE
          measurement_type_concept_id = 2000000007);     -- concept.concept_name = 'Labs - Culture Organisms'
```
                                                            concept_name                                                            | concept_id
------------------------------------------------------------------------------------------------------------------------------------+------------
 Bacteria identified in Unspecified specimen by Culture                                                                             |    3002619
 Virus identified in Unspecified specimen by Immunofluorescence                                                                     |    3006753
 Bacteria identified in Synovial fluid by Culture                                                                                   |    3006761
 Fungus identified in Blood by Culture                                                                                              |    3009171
 Bacteria identified in Catheter tip by Culture                                                                                     |    3009986
 Toxoplasma gondii Ab [Presence] in Serum                                                                                           |    3011392
 Bacteria identified in Bronchial specimen by Aerobe culture                                                                        |    3015532
 Bacteria identified in Body fluid by Culture                                                                                       |    3016727
 Cytomegalovirus IgG Ab [Presence] in Serum                                                                                         |    3016816
 Bacteria identified in Cerebral spinal fluid by Culture                                                                            |    3016914
 Bacteria identified in Sputum by Culture                                                                                           |    3023419
 Bacteria identified in Pleural fluid by Culture                                                                                    |    3024194
 Epstein Barr virus capsid IgG and IgM panel - Serum                                                                                |    3024836
 Influenza virus A+B Ag [Presence] in Unspecified specimen                                                                          |    3024891
 Bacteria identified in Peritoneal fluid by Culture                                                                                 |    3025037
 Bacteria identified in Stool by Culture                                                                                            |    3025941
 Bacteria identified in Urine by Culture                                                                                            |    3026008
 Methicillin resistant Staphylococcus aureus (MRSA) DNA [Presence] in Unspecified specimen by Probe and target amplification method |    3033966
 Bacteria identified in Aspirate by Culture                                                                                         |    3043614
 Bacteria identified in Tissue by Culture                                                                                           |    3044495
 Bacteria identified in Bronchoalveolar lavage by Aerobe culture                                                                    |    3045360
 Respiratory pathogens DNA and RNA identified in Respiratory specimen by Probe and target amplification method                      |   21493881
 Chromosome analysis.interphase [Interpretation] in Blood or Marrow by FISH Narrative                                               |   40760911
 Bacteria identified in Blood product unit.autologous by Culture                                                                    |   46235217

``` sql
-- most frequent microorganisms in blood culture
SELECT concept_name, value_as_concept_id, count(1)
FROM omop.measurement m
JOIN omop.concept c on c.concept_id = m.value_as_concept_id
WHERE measurement_type_concept_id = 2000000007        				-- concept.concept_name = 'Labs - Culture Organisms'
And value_as_concept_id != 9189                       				-- concept.concept_name = 'Negative'
AND measurement_concept_id = 46235217                 				-- concept.concept_name = 'Bacteria identified in Blood product unit.autologous by Culture'
GROUP BY concept_name, value_as_concept_id order by count(1) desc;
```

``` sql
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
```

``` sql
-- %  of MRSA
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
