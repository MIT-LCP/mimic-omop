# Link to CommonDataModel
- [PERSON](https://github.com/OHDSI/CommonDataModel/wiki/PERSON)

# Source Tables (mimic)

## [patients](https://mimic.physionet.org/mimictables/patients/)

- information about death are moved to `omop.death` table

## [admissions](https://mimic.physionet.org/mimictables/admissions/)

- the ethicity comes from admissions, the first recorded value is put in the `omop.person` table 

# Mapping used

## [ethnicity_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/ethnicity_to_concept.csv)

- it maps the mimic ethnicity to omop ethnicity

# Examples

## Number of persons
``` sql
SELECT COUNT(person_id) AS num_persons_count
FROM person;
```
| num_persons_count |
|-------------------|
|             46520|

## Number of patients grouped by gender
``` sql
SELECT  person.GENDER_CONCEPT_ID,
        concept.CONCEPT_NAME AS ethnicity_name,
        COUNT(person.person_ID) AS num_persons_count
FROM person
INNER JOIN concept ON person.GENDER_concept_id = concept.CONCEPT_ID
GROUP BY person.GENDER_CONCEPT_ID, concept.CONCEPT_NAME;
```
| gender_concept_id | ethnicity_name | num_persons_count |
|-------------------|----------------|-------------------|
|              8532 | FEMALE         |             20399|
|              8507 | MALE           |             26121|

## Number of patients grouped by race
``` sql
SELECT  person.RACE_CONCEPT_ID,
        concept.CONCEPT_NAME AS race_name,
        COUNT(person.person_ID) AS num_persons_count
FROM person
INNER JOIN concept ON person.RACE_CONCEPT_ID = concept.CONCEPT_ID
GROUP BY person.RACE_CONCEPT_ID, concept.CONCEPT_NAME;
```
| race_concept_id |                 race_name                 | num_persons_count |
|-----------------|-------------------------------------------|-------------------|
|         4218674 | Unknown racial group                      |              5526|
|        38003592 | Vietnamese                                |                41|
|        38003581 | Filipino                                  |                15|
|        38003579 | Chinese                                   |               223|
|        38003574 | Asian Indian                              |                57|
|            8527 | White                                     |             32116|
|         4188163 | Histiocytic proliferation                 |                14|
|        38003584 | Japanese                                  |                 7|
|         4188161 | Hispanic, color unknown                   |                11|
|        38003615 | Middle Eastern or North African           |                28|
|         4188159 | Hispanic                                  |                57|
|            8515 | Asian                                     |              1319|
|        38003614 | European                                  |               196|
|        38003599 | African American                          |              3585|
|         4213463 | Portuguese                                |                36|
|        38003605 | Haitian                                   |                71|
|            8557 | Native Hawaiian or Other Pacific Islander |                15|
|         4212311 | Mixed racial group                        |               111|
|         4077359 | Caribbean Island                          |                 7|
|        38003585 | Korean                                    |                11|
|         4087921 | Other ethnic non-mixed                    |              1256|
|         4188160 | Erythrose                                 |                 3|
|        38003603 | Dominican                                 |                60|
|         4188162 | Hispanic, white                           |               146|
|            8657 | American Indian or Alaska Native          |                47|
|        38003578 | Cambodian                                 |                10|
|        38003600 | African                                   |               191|
|         4188164 | History of chronic lung disease           |              1358|
|        38003591 | Thai                                      |                 3|

## Distribution of year of birth
``` sql
SELECT percentile_25
     , median
     , percentile_75
     , MIN( year_of_birth    )    AS minimum
     , MAX( year_of_birth    )    AS maximum
     , CAST(AVG( year_of_birth    ) AS INTEGER)   AS mean
     , STDDEV( year_of_birth    ) AS stddev
FROM
(SELECT MAX( CASE WHEN( percentile = 1    ) THEN year_of_birth END    ) AS percentile_25
      , MAX( CASE WHEN( percentile = 2    ) THEN year_of_birth END    ) AS median
      , MAX( CASE WHEN( percentile = 3    ) THEN year_of_birth END    ) AS percentile_75
  FROM
     ( SELECT counter.year_of_birth, counter.births
            , FLOOR( CAST( SUM( births    ) OVER( ORDER BY year_of_birth ROWS UNBOUNDED PRECEDING    ) AS DECIMAL    )
                   / CAST( SUM( births    ) OVER( ORDER BY year_of_birth ROWS BETWEEN UNBOUNDED PRECEDING
                                                                      AND UNBOUNDED FOLLOWING    )  AS DECIMAL    )
                   * 4
                      ) + 1
        as percentile
        FROM
           ( SELECT year_of_birth, count(*) AS births
              FROM person
              GROUP BY year_of_birth
              ) as counter
       ) as p
   WHERE percentile <= 3
) as percentile_table, person
GROUP BY percentile_25, median, percentile_75;
```
| percentile_25 | median | percentile_75 | minimum | maximum | mean |       stddev        |
|---------------|--------|---------------|---------|---------|------|---------------------|
|          2062 |   2095 |          2123 |    1800 |    2201 | 2088 | 64.2736336370628481|
