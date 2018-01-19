# Link to CommonDataModel
- [VISIT_DETAIL](https://github.com/OHDSI/CommonDataModel/wiki/VISIT_DETAIL)

# Source Tables(mimic)

## [transfers](https://mimic.physionet.org/mimictables/transfers/)

- the room or bed movement have been removed so that only ward change are logged in the table
- the emergency stays have been added in has conventional stays (may introduce strange gap in times)
- `visit_type_concept_id` is equal to 2000000006  (Ward and physical location) and localize the patient
- `visit_detail_concept_id` is equal to 8717 (Inpatient visit) for a non emergency stay
- `visit_detail_concept_id` is equal to 581381 (Emergency room) for a emergency  stay
- `visit_detail_concept_id` is equal to 581382  (Intensive Care Unit) for an ICU  stay
- the callout delay has been added in the table has an omop contrib derived variable

## [services](https://mimic.physionet.org/mimictables/services/)

- the services table populates the `visit_detail` too
- `visit_type_concept_id` is equal to  45770670 (Services and care) and lists services that a patient was admitted/transferred under
- `visit_detail_concept_id` is equal to 45763735 to identify medical patients
- `visit_detail_concept_id` is equal to 4149152 to identify surgical patients
- `visit_detail_concept_id` is equal to 4237225 to identify newborn patients
- `visit_detail_concept_id` is equal to 4150859 to identigy psychiatric patients (only one!)

- it is then possible to know both where the patient is (from transfers) and whose take care of him (from services)

## `visit_detail_id` assigning

- Be careful when joining patient data based on `visit_detail_id`, there is no guaranty the link is actual
- WARNING : any link to `visit_detail_id` in the database is calculated (measurement, observation, drug_exposure...)
- this is actually the case for mimiciii and icustays
- the algorith is below:
    - if the data has a visit_occurrence value
    - if the data has a precise timestamp
         - then assign to the visit_detail that cover that date and is linked to that visit_occurrence
    - if the timestamp is before/after the first/last visit_detail
         - then assign to the first/last visit_detail instance

# Mapping used

## [visit_source_concept_id](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/admission_type_to_concept.csv)

- it maps mimic admission type to omop admission type

## [admitting_source_concept_id](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/admission_location_to_concept.csv)

- it maps mimic location admission type to omop location admission type

## [discharge_type_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/google/concept/discharge_location_to_concept.csv)

- it maps mimic location discharge type to omop location discharge type

# Example

## explanation of `visit_type_concept_id`

``` sql
SELECT distinct concept_name, visit_type_concept_id  as concept_id
FROM visit_detail v
JOIN concept c ON v.visit_type_concept_id = c.concept_id;
```
|        concept_name        | concept_id |
|----------------------------|------------|
| Services and care          |   45770670|
| Ward and physical location | 2000000006|

## explanation of `visit_detail_concept_id`, distribution of type of care

``` sql
SELECT concept_name, concept_id, count(1)
FROM visit_detail
JOIN concept ON visit_detail_concept_id = concept_id
WHERE visit_type_concept_id = 45770670                          -- concept.concept_name = 'Services and care'
GROUP BY 1, 2 ORDER BY count(1) desc;
```
|      concept_name       | concept_id | count |
|-------------------------|------------|-------|
| General medical service |   45763735 | 88209|
| Surgical service        |    4149152 | 73729|
| Newborn care service    |    4237225 | 16718|
| Psychiatry service      |    4150859 |     1|

## explanation of `visit_detail_concept_id`, distribution of ward types (physical location)

``` sql
SELECT concept_name, concept_id, count(1)
FROM visit_detail
JOIN concept ON visit_detail_concept_id = concept_id
WHERE visit_type_concept_id = 2000000006                      -- concept.concept_name = 'Ward and physical location'
GROUP BY 1, 2 ORDER BY count(1) desc;
```
|             concept_name              | concept_id | count |
|---------------------------------------|------------|-------|
| No matching concept                   |          0 | 87766|
| Inpatient Intensive Care Facility     |     581382 | 71570|
| Emergency Room Critical Care Facility |     581381 | 30877|
| Inpatient Hospital                    |       8717 |  8237|

## explanation of `care_site_id`, `transfers` table in non omop mimic

``` sql
-- transfers table (mimic)
SELECT place_of_service_source_value, count (1)
FROM visit_detail JOIN care_site c USING (care_site_id)
WHERE visit_type_concept_id = 2000000006                        -- concept.concept_name = 'Ward and physical location'
GROUP BY 1 ORDER BY count(1) DESC;
```
|     place_of_service_source_value     | count |
|---------------------------------------|-------|
| Unknown Ward                          | 87766|
| Emergency Room Critical Care Facility | 30877|
| Medical intensive care unit           | 24289|
| Cardiac surgery recovery unit         | 11818|
| Surgical intensive care unit          | 10688|
| Coronary care unit                    |  9005|
| Neonatal intensive care unit          |  8472|
| Neonatal ward                         |  8237|
| Trauma/surgical intensive care unit   |  7298|

## explanation of `care_site_id`, `service` table in non omop table

``` sql
SELECT place_of_service_source_value, count (1)
FROM visit_detail JOIN care_site c USING (care_site_id)
WHERE visit_type_concept_id = 45770670                           -- concept.concept_name = 'Services and care'
GROUP BY 1 ORDER BY count(1) DESC;
```
|                               place_of_service_source_value                               | count |
|-------------------------------------------------------------------------------------------|-------|
| Medical - general service for internal medicine                                           | 57032|
| Cardiac Surgery - for surgical cardiac admissions                                         | 23775|
| Cardiac Medical - for non-surgical cardiac related admissions                             | 20663|
| Surgical - general surgical service not classified elsewhere                              | 16600|
| Newborn - infants born at the hospital                                                    | 16258|
| Neurologic Surgical - surgical, relating to the brain                                     | 10574|
| Trauma - injury or damage caused by physical harm from an external source                 |  7034|
| Neurologic Medical - non-surgical, relating to the brain                                  |  6395|
| Vascular Surgical - surgery relating to the circulatory system                            |  5422|
| Orthopaedic medicine - non-surgical, relating to musculoskeletal system                   |  4119|
| Thoracic Surgical - surgery on the thorax, located between the neck and the abdomen       |  3974|
| Orthopaedic - surgical, relating to the musculoskeletal system                            |  2911|
| Genitourinary - reproductive organs/urinary system                                        |  1144|
| Plastic - restortation/reconstruction of the human body (including cosmetic or aesthetic) |   775|
| Gynecological - female reproductive systems and breasts                                   |   674|
| Ear, nose, and throat - conditions primarily affecting these areas                        |   614|
| Newborn baby - infants born at the hospital                                               |   460|
| Obstetrics - conerned with childbirth and the care of women giving birth                  |   218|
| Dental - for dental/jaw related admissions                                                |    14|
| Psychiatric - mental disorders relating to mood, behaviour, cognition, or perceptions     |     1|

## Number of patients in ICU

``` sql
SELECT COUNT(distinct visit_detail_id) AS num_totalstays_count
FROM visit_detail
WHERE visit_detail_concept_id = 581382                             -- concept.concept_name = 'Inpatient Intensive Care Facility'
AND visit_type_concept_id = 2000000006;                            -- concept.concept_name = 'Ward and physical location'
```
| num_totalstays_count |
|----------------------|
|                71570|


## Number of dead patients in ICU

``` sql
SELECT count(distinct visit_detail_id) AS dead_hospital_count
FROM visit_detail
JOIN concept ON visit_detail_concept_id = concept_id
WHERE visit_detail_concept_id = 581382                             -- concept.concept_name = 'Inpatient Intensive Care Facility'
AND visit_type_concept_id = 2000000006                             -- concept.concept_name = 'Ward and physical location'
AND discharge_to_concept_id = 4216643;                             -- concept.concept_name = 'Patient died'
```
| dead_hospital_count |
|---------------------|
|                4559|

## % of dead patients in ICU

``` sql
WITH tmp AS
(
  SELECT COUNT(distinct d.visit_detail_id) AS dead
       , COUNT(distinct t.visit_detail_id) AS total
  FROM visit_detail t
  LEFT JOIN
  (
        SELECT visit_detail_id
        FROM visit_detail
        WHERE visit_detail_concept_id = 581382
        and visit_type_concept_id = 2000000006
        and discharge_to_concept_id = 4216643
  
  ) d USING (visit_detail_id)
  WHERE t.visit_detail_concept_id = 581382
  and t.visit_type_concept_id = 2000000006

)
SELECT dead, total, dead * 100 / total as percentage FROM tmp;
```
| dead | total | percentage |
|------|-------|------------|
| 4559 | 71570 |          6|

## Distribution of length of stay in ICU

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
                        ) + 1
          as percentile
          FROM
             ( SELECT EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0 as los, count(*) AS nb_los
                FROM visit_detail
                WHERE visit_detail_concept_id = 581382            -- concept.concept_name = 'Inpatient Intensive Care Facility'
                AND visit_type_concept_id = 2000000006            -- concept.concept_name = 'Ward and physical location' 
                GROUP BY EXTRACT(EPOCH FROM visit_end_datetime - visit_start_datetime)/60.0/60.0/24.0
               ) as counter
         ) as p
     WHERE percentile <= 3
  ) as percentile_table, visit_detail
  WHERE visit_detail_concept_id = 581382                          -- concept.concept_name = 'Inpatient Intensive Care Facility' 
  AND visit_type_concept_id = 2000000006                          -- concept.concept_name = 'Ward and physical location' 
  GROUP BY percentile_25, median, percentile_75;
```
|   percentile_25   |     median      |  percentile_75   |       minimum        |     maximum      | mean |      stddev      |
|-------------------|-----------------|------------------|----------------------|------------------|------|------------------|
| 0.958622685185185 | 1.8746412037037 | 3.87761574074074 | 1.15740740740741e-05 | 171.622650462963 |    4 | 8.67445796806052|
