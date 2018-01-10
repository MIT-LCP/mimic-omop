# URL to CommonDataModel
- https://github.com/OHDSI/CommonDataModel/wiki/VISIT_DETAIL

# Source Tables

## transfers

- the room or bed movement have been removed so that only ward change are logged in the table
- the emergency stays have been added in has conventional stays (may introduce strange gap in times)
- `visit_detail_concept_id` is equal to 9201  (Inpatient visit) for a non emergency stay
- `visit_detail_concept_id` is equal to 9203  (Emergency room) for a emergency  stay
- `visit_detail_concept_id` is equal to 9204  (Intensive Care Unit) for an ICU  stay
- `visit_type_concept_id` is equal to 44818518  (Visit derived from EHR record)
- the callout delay has been added in the table has an omop contrib derived variable

## services

- the services table populates the `visit_detail` too
- `visit_detail_concept_id` is always equal to 9201  (Inpatient visit) because service information does not cover emergency stays
- `visit_type_concept_id` is equal to 45770670  (services and care)
- it is then possible to know both where the patient is (from transfers) and whose take care of him (from services)

# Contrib

Those fields have been added:
- `discharge_delay`
- `visit_detail_length`
- omop concept 9204 has been introduced for ICU stays, it should be proposed to the OHSDI community

# Lookup Tables

## visit_source_concept_id
- https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/admission_type_to_concept.csv

## admitting_source_concept_id
- made by google : https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/admission_location_to_concept.csv

## discharge_type_to_concept
- made by google : https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/discharge_location_to_concept.csv

# Example
``` sql
-- the distribution of ward types
SELECT concept_name, concept_id, count(1)
FROM visit_detail
JOIN concept ON visit_detail_concept_id = concept_id
GROUP BY 1, 2 ORDER BY 3 desc;
```
       concept_name        | concept_id | count
---------------------------+------------+-------
 Inpatient Visit           |       9201 |   351
 Intensive Care Unit Visit |       9204 |   185
 Emergency Room Visit      |       9203 |    72

``` sql
-- explanation of the visit_type_concept_id
SELECT distinct concept_name, visit_type_concept_id  as concept_id
From visit_detail v
JOIN concept c on v.visit_type_concept_id = c.concept_id;
```
         concept_name          | concept_id
-------------------------------+------------
 Services and care             |   45770670
 Visit derived from EHR record |   44818518

``` sql
-- explanation of care_site_id
-- -- transfers table (mimic)
SELECT place_of_service_source_value, count (1)
FROM visit_detail JOIN care_site c USING (care_site_id) 
WHERE visit_type_concept_id = 44818518                   -- concept.concept_name = 'Visit derived from EHR record'
GROUP BY 1 ORDER BY count(1) DESC;
```
     place_of_service_source_value     | count
---------------------------------------+-------
 Unknown service                       |   187
 Emergency Room Critical Care Facility |    72
 Medical intensive care unit           |    67
 Neonatal ward                         |    25
 Surgical intensive care unit          |    22
 Cardiac surgery recovery unit         |    21
 Neonatal intensive care unit          |    19
 Coronary care unit                    |    16
 Trauma/surgical intensive care unit   |    15

``` sql
-- explanation of care_site_id
-- -- service table (mimic) 
-- -- `visit_detail_concept_id` is always equal to 9201 i
SELECT place_of_service_source_value, count (1)
FROM visit_detail JOIN care_site c USING (care_site_id) 
WHERE visit_type_concept_id = 45770670                      -- concept.concept_name = 'Services and care'
GROUP BY 1 ORDER BY count(1) DESC;
```
                               place_of_service_source_value                               | count
-------------------------------------------------------------------------------------------+-------
 Medical - general service for internal medicine                                           |    62
 Plastic - restortation/reconstruction of the human body (including cosmetic or aesthetic) |     1
 Newborn - infants born at the hospital                                                    |    15
 Thoracic Surgical - surgery on the thorax, located between the neck and the abdomen       |     4
 Orthopaedic medicine - non-surgical, relating to musculoskeletal system                   |     9
 Newborn baby - infants born at the hospital                                               |     2
 Surgical - general surgical service not classified elsewhere                              |     8
 Cardiac Surgery - for surgical cardiac admissions                                         |    19
 Neurologic Surgical - surgical, relating to the brain                                     |    11
 Cardiac Medical - for non-surgical cardiac related admissions                             |    16
 Trauma - injury or damage caused by physical harm from an external source                 |    12
 Neurologic Medical - non-surgical, relating to the brain                                  |     4
 Orthopaedic - surgical, relating to the musculoskeletal system                            |     1


``` sql
-- Number of patients in ICU
SELECT COUNT(person_id) AS num_totalstays_count
FROM visit_detail
WHERE visit_detail_concept_id = 9204                 -- concept.concept_name = 'Intensive Care Unit Visit'
and visit_type_concept_id = 44818518;                -- concept.concept_name = 'Visit derived from EHR record'
```

/* Todo
``` sql
-- nb of dead patients in ICU
SELECT count(person_id) AS dead_hospital_count
FROM visit_detail
JOIN concept ON visit_detail_concept_id = concept_id
WHERE visit_detail_concept_id = 9204            --concept,concept_name = 'Intensive Care Unit Visit'
and discharge_to_concept_id = 4216643;          --concept.concept_name = 'Patient died';
```

``` sql
-- % of dead patients in icu
WITH tmp AS
(
  SELECT COUNT(distinct d.person_id) AS dead
       , COUNT(t.person_id) AS total
  FROM visit_occurrence t
  LEFT JOIN
  (
        SELECT person_id
        FROM visit_occurrence
        WHERE visit_detail_concept_id = 9204            -- concept.concept_name = 'Intensive Care Unit Visit'
        and discharge_to_concept_id = 44216643          -- concept.concept_name = 'Patient died'
  ) d USING (person_id)
)
SELECT dead, total, dead * 100 / total as percentage FROM tmp;
```
*/

``` sql
-- Distribution of length of stay in icu
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
                FROM omop.visit_detail
                WHERE visit_detail_concept_id = 9204                                                    
                GROUP BY EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0
              ) as counter
        ) as p
     WHERE percentile <= 3
  ) as percentile_table, omop.visit_detail
  WHERE visit_detail_concept_id = 9204     
  GROUP BY percentile_25, median, percentile_75;
```
