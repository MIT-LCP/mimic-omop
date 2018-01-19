# Link to CommonDataModel
- [VISIT_OCCURRENCE](https://github.com/OHDSI/CommonDataModel/wiki/VISIT_OCCURRENCE)

# Source Tables (mimic)

## [admissions](https://mimic.physionet.org/mimictables/admissions/)

- some informations from admissions are populated elsewhere (religion, ethnicity, deathtime) respectiveley in (observation, person/observation, death)
- emergency information have been extracted
- when the admissions is emergency, then 
	- the admission start datetime becomes the emergency start datetime
	- that emergency stay is added to transfers (in the `visit_detail` table)
- `visit_type_concept_id` is always equals to 44818518 (visit derived from EHR)
- `visit_concept_id` is either equals to 9201 (inpatient visit) or 262 (emergency room and inpatient visit) when admitting by emergency
- in mimic when patient is organ donor, patient died twice. In omop format
        - a new admission category is created as Patient died (concept_id = 4216643)
        - a new discharge category is created as Organ donor (concept_id = 4022058)

# Mapping used

## [visit_source_concept_id](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/admission_type_to_concept.csv)

- it maps mimic admission type to omop admission type

## [admitting_source_concept_id](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/admission_location_to_concept.csv)

- it maps mimic location admission type to omop location admission type

## [discharge_type_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/discharge_location_to_concept.csv)

- it maps mimic location discharge type to omop location discharge type

# Examples

## Number of admissions

``` sql
SELECT COUNT(distinct visit_occurrence_id) AS num_admission_count
FROM visit_occurrence;
```
| num_admission_count |
|---------------------|
|               58976|

## Number of dead patients in hospital

``` sql
SELECT count(distinct visit_occurrence_id) AS dead_hospital_count
FROM visit_occurrence
WHERE discharge_to_concept_id = 4216643;                          -- concept.concept_name = 'Patient died'
```
| dead_hospital_count |
|---------------------|
|                5854|

## % of dead patients in hospital 

``` sql
WITH tmp AS
(
  SELECT COUNT(distinct d.visit_occurrence_id) AS dead
       , COUNT(distinct t.visit_occurrence_id) AS total
  FROM visit_occurrence t
  LEFT JOIN
  (
        SELECT visit_occurrence_id
        FROM visit_occurrence
        WHERE discharge_to_concept_id = 4216643                   -- concept.concept_name = 'Patient died'
  
  ) d USING (visit_occurrence_id)

)
SELECT dead, total, dead * 100 / total as percentage FROM tmp;
```
| dead | total | percentage |
|------|-------|------------|
| 5854 | 58976 |          9|

## explanation of the `visit_type_concept_id`

``` sql
-- one one type for visit_occurrence
SELECT distinct concept_name, visit_type_concept_id AS concept_id
FROM visit_occurrence v
JOIN concept c ON v.visit_type_concept_id = c.concept_id;
```
|         concept_name          | concept_id |
|-------------------------------|------------|
| Visit derived from EHR record |   44818518|

## explanation of `visit_source_concept_id`

``` sql
SELECT distinct visit_source_value, concept_name, visit_source_concept_id AS concept_id
FROM visit_occurrence v
JOIN concept c ON v.visit_source_concept_id = c.concept_id;
```
| visit_source_value |             concept_name             | concept_id |
|--------------------|--------------------------------------|------------|
| NEWBORN            | Newborn                              |     444104|
| EMERGENCY          | Emergency hospital admission         |    4079617|
| URGENT             | Hospital admission, urgent, 48 hours |    4331002|
| ELECTIVE           | Hospital admission, elective         |    4314435|

## explanation of `admitting_source_concept_id`

``` sql
SELECT distinct admitting_source_value, concept_name, admitting_source_concept_id AS concept_id
FROM visit_occurrence v
JOIN concept c ON v.admitting_source_concept_id = c.concept_id;
```
|  admitting_source_value   |       concept_name        | concept_id |
|---------------------------|---------------------------|------------|
| TRANSFER FROM HOSP/EXTRAM | Inpatient Hospital        |       8717|
| TRANSFER FROM SKILLED NUR | Skilled Nursing Facility  |       8863|
| EMERGENCY ROOM ADMIT      | Emergency Room - Hospital |       8870|
| DEAD/EXPIRED              | Patient died              |    4216643|    -- organ donor
| CLINIC REFERRAL/PREMATURE | Office                    |       8940|
| HMO REFERRAL/SICK         | Office                    |       8940|
| PHYS REFERRAL/NORMAL DELI | Office                    |       8940|
| TRSF WITHIN THIS FACILITY | Inpatient Hospital        |       8717|
| TRANSFER FROM OTHER HEALT | Other Inpatient Care      |       8892|
| DEAD/EXPIRED              | Patient died              |    4216643|

## explanation of the `discharge_to_concept_id`

``` sql
SELECT distinct discharge_to_source_value, concept_name, discharge_to_concept_id  as concept_id
FROM visit_occurrence v
JOIN concept c ON v.discharge_to_concept_id = c.concept_id;
```
| discharge_to_source_value |                 concept_name                  | concept_id |
|---------------------------|-----------------------------------------------|------------|
| HOME HEALTH CARE          | Home                                          |       8536|
| DISC-TRAN CANCER/CHLDRN H | Inpatient Hospital                            |       8717|
| HOSPICE-MEDICAL FACILITY  | Hospice                                       |       8546|
| LONG TERM CARE HOSPITAL   | Inpatient Long-term Care                      |       8970|
| HOME                      | Home                                          |       8536|
| ICF                       | Skilled Nursing Facility                      |       8863|
| SHORT TERM HOSPITAL       | Skilled Nursing Facility                      |       8863|
| REHAB/DISTINCT PART HOSP  | Skilled Nursing Facility                      |       8863|
| SNF                       | Skilled Nursing Facility                      |       8863|
| DEAD/EXPIRED              | Patient died                                  |    4216643|
| HOME WITH HOME IV PROVIDR | Home                                          |       8536|
| DISCH-TRAN TO PSYCH HOSP  | Psychiatric Facility-Partial Hospitalization  |       8913|
| SNF-MEDICAID ONLY CERTIF  | Skilled Nursing Facility                      |       8863|
| HOSPICE-HOME              | Hospice                                       |       8546|
| LEFT AGAINST MEDICAL ADVI | Patient self-discharge against medical advice |    4021968|
| ORGAN DONOR ACCOUNT       | Organ donor                                   |    4022058|

## Distribution of length of stay in hospital
``` sql
SELECT percentile_25
       , median
       , percentile_75
       , MIN( EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0    )    AS minimum
       , MAX( EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0  )    AS maximum
       , CAST(AVG(  EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0  ) AS INTEGER)   AS mean
       , STDDEV( EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0    ) AS stddev
  FROM
  (SELECT MAX( CASE WHEN( percentile = 1    ) THEN los END    ) AS percentile_25
        , MAX( CASE WHEN( percentile = 2    ) THEN los END    ) AS median
        , MAX( CASE WHEN( percentile = 3    ) THEN los END    ) AS percentile_75
    FROM
       ( SELECT counter.los, counter.nb_los
              , FLOOR( CAST( SUM( nb_los    ) OVER( ORDER BY los ROWS UNBOUNDED PRECEDING    ) AS DECIMAL    )
                     / CAST( SUM( nb_los   ) OVER( ORDER BY los ROWS BETWEEN UNBOUNDED PRECEDING
                                                                        AND UNBOUNDED FOLLOWING    )  AS DECIMAL    )
                     * 4
                        ) | 1
          as percentile
          FROM
             ( SELECT EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0 as los, count(*) AS nb_los
                FROM visit_occurrence
                GROUP BY EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0
               ) as counter
         ) as p
     WHERE percentile <= 3
  ) as percentile_table, visit_occurrence
  GROUP BY percentile_25, median, percentile_75;
```
| percentile_25 | median  |  percentile_75   |      minimum       |     maximum      | mean |      stddev      |
|---------------|---------|------------------|--------------------|------------------|------|------------------|
|       3.84375 | 6.59375 | 11.8868055555556 | -0.905555555555556 | 294.660416666667 |   10 | 12.4700360442866|
