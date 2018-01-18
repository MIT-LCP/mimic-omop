# Link to CommonDataModel
- [VISIT_OCCURRENCE(https://github.com/OHDSI/CommonDataModel/wiki/VISIT_OCCURRENCE)

# Source Tables

## [admissions](https://mimic.physionet.org/mimictables/admissions/)

- some informations from admissions are populated elsewhere (religion, ethnicity, deathtime) respectiveley in (observation, person/observation, death)
- emergency information have been extracted
- when the admissions is emergency, then 
	- the admission start datetime becomes the emergency start datetime
	- that emergency stay is added to transfers (in the `visit_detail` table)
- `visit_type_concept_id` is always equals to 44818518 (visit derived from EHR)
- `visit_concept_id` is either equals to 9201 (inpatient visit) or 262 (emergency room and inpatient visit) when admitting by emergency

# Mapping used

## [visit_source_concept_id](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/admission_type_to_concept.csv)

## [admitting_source_concept_id](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/admission_location_to_concept.csv)

## [discharge_type_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/discharge_location_to_concept.csv)

# Examples

## Number of patients in the visit_occurrence
``` sql
SELECT COUNT(distinct person_id) AS num_admission_count
FROM visit_occurrence;
```

## Number of dead patients in hospital
``` sql
SELECT count(person_id) AS dead_hospital_count
FROM visit_occurrence
WHERE discharge_to_concept_id = 4216643;                          -- concept.concept_name = 'Patient died'
```

## % of dead patients in hospital 
``` sql
WITH tmp AS
(
  SELECT COUNT(distinct d.person_id) AS dead
       , COUNT(t.person_id) AS total
  FROM visit_occurrence t
  LEFT JOIN
  (
        SELECT person_id
        FROM visit_occurrence
        WHERE discharge_to_concept_id = 4216643                   -- concept.concept_name = 'Dead'
  ) d USING (person_id)
)
SELECT dead, total, dead * 100 / total as percentage FROM tmp;
```

## explanation of the `visit_type_concept_id`

``` sql
SELECT distinct concept_name, visit_type_concept_id  as concept_id
From visit_occurrence v
JOIN concept c on v.visit_type_concept_id = c.concept_id;
```
         concept_name          | concept_id
-------------------------------+------------
 Visit derived from EHR record |   44818518

## explanation of `visit_source_concept_id`

``` sql
SELECT distinct visit_source_value, concept_name, visit_source_concept_id  as concept_id
From visit_occurrence v
JOIN concept c on v.visit_source_concept_id = c.concept_id;
```
visit_source_value |             concept_name             | concept_id
--------------------|--------------------------------------|------------
 ELECTIVE           | Hospital admission, elective         |    4314435
 EMERGENCY          | Emergency hospital admission         |    4079617
 NEWBORN            | Newborn                              |     444104
 URGENT             | Hospital admission, urgent, 48 hours |    4331002

## explanation of `admitting_source_concept_id`

``` sql
SELECT distinct admitting_source_value, concept_name, admitting_source_concept_id  as concept_id
From visit_occurrence v
JOIN concept c on v.admitting_source_concept_id = c.concept_id;
```
admitting_source_value   |       concept_name        | concept_id
---------------------------|---------------------------|------------
 EMERGENCY ROOM ADMIT      | Emergency Room - Hospital |       8870
 CLINIC REFERRAL/PREMATURE | Office                    |       8940
 TRANSFER FROM SKILLED NUR | Skilled Nursing Facility  |       8863
 PHYS REFERRAL/NORMAL DELI | Office                    |       8940
 TRANSFER FROM HOSP/EXTRAM | Inpatient Hospital        |       8717

## explanation of the `discharge_to_concept_id`

``` sql
SELECT distinct discharge_to_source_value, concept_name, discharge_to_concept_id  as concept_id
From visit_occurrence v
JOIN concept c on v.discharge_to_concept_id = c.concept_id;
```
 discharge_to_source_value |                 concept_name                  | concept_id
---------------------------|-----------------------------------------------|------------
 DEAD/EXPIRED              | Dead                                          |     434489
 DISC-TRAN CANCER/CHLDRN H | Inpatient Hospital                            |       8717
 HOME                      | Home                                          |       8536
 HOME HEALTH CARE          | Home                                          |       8536
 HOSPICE-HOME              | Hospice                                       |       8546
 LEFT AGAINST MEDICAL ADVI | Patient self-discharge against medical advice |    4021968
 LONG TERM CARE HOSPITAL   | Inpatient Long-term Care                      |       8970
 REHAB/DISTINCT PART HOSP  | Skilled Nursing Facility                      |       8863
 SHORT TERM HOSPITAL       | Skilled Nursing Facility                      |       8863
 SNF                       | Skilled Nursing Facility                      |       8863

## Distribution of length of stay in hospital

``` sql
SELECT percentile_25
       , median
       , percentile_75
       , MIN( EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0   )    AS minimum
       , MAX( EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0 )    AS maximum
       , CAST(AVG(  EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0 ) AS INTEGER)   AS mean
       , STDDEV( EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0   ) AS stddev
  FROM
  (SELECT MAX( CASE WHEN( percentile = 1   ) THEN los END   ) AS percentile_25
        , MAX( CASE WHEN( percentile = 2   ) THEN los END   ) AS median
        , MAX( CASE WHEN( percentile = 3   ) THEN los END   ) AS percentile_75
    FROM
       ( SELECT counter.los, counter.nb_los
              , FLOOR( CAST( SUM( nb_los   ) OVER( ORDER BY los ROWS UNBOUNDED PRECEDING   ) AS DECIMAL   )
                     / CAST( SUM( nb_los  ) OVER( ORDER BY los ROWS BETWEEN UNBOUNDED PRECEDING
                                                                        AND UNBOUNDED FOLLOWING   )  AS DECIMAL   )
                     * 4
                       ) + 1
          as percentile
          FROM
             ( SELECT EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0 as los, count(*) AS nb_los
                FROM omop.visit_occurrence
                GROUP BY EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0
              ) as counter
        ) as p
     WHERE percentile <= 3
  ) as percentile_table, omop.visit_occurrence
  GROUP BY percentile_25, median, percentile_75;
```
