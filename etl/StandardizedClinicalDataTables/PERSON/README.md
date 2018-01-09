# URL to CommonDataModel
- https://github.com/OHDSI/CommonDataModel/wiki/PERSON

# Source Tables

## mimic.patients

- information about death are mooved to `omop.death` table

## mimic.admissions

- the ethicity comes from admissions, the first recorded value is put in the omop.person table 

# Lookup Tables

## gcpt_ethnicity_to_concept

- this maps the mimic ethnicity to omop ethnicity
- this has been made by google

# Examples

## Standard queries from http://cdmqueries.omop.org/person

``` sql
-- Number of patients in the dataset
SELECT COUNT(person_id) AS num_persons_count
FROM person;
```

``` sql
-- Number of patients grouped by gender
SELECT  person.GENDER_CONCEPT_ID,
        concept.CONCEPT_NAME AS ethnicity_name,
        COUNT(person.person_ID) AS num_persons_count
FROM person
INNER JOIN concept ON person.GENDER_concept_id = concept.CONCEPT_ID
GROUP BY person.GENDER_CONCEPT_ID, concept.CONCEPT_NAME;
```

``` sql
-- Number of patients grouped by race
SELECT  person.RACE_CONCEPT_ID,
        concept.CONCEPT_NAME AS race_name,
        COUNT(person.person_ID) AS num_persons_count
FROM person
INNER JOIN concept ON person.RACE_CONCEPT_ID = concept.CONCEPT_ID
GROUP BY person.RACE_CONCEPT_ID, concept.CONCEPT_NAME;
```

``` sql
-- Number of patients grouped by ethnicity
SELECT  person.ETHNICITY_CONCEPT_ID,
        concept.CONCEPT_NAME AS ethnicity_name,
        COUNT(person.person_ID) AS num_persons_count
FROM person
INNER JOIN concept ON person.ETHNICITY_CONCEPT_ID = concept.CONCEPT_ID
GROUP BY person.ETHNICITY_CONCEPT_ID, concept.CONCEPT_NAME;
```

``` sql
-- Distribution of year of birth
SELECT percentile_25
     , median
     , percentile_75
     , MIN( year_of_birth  )    AS minimum
     , MAX( year_of_birth  )    AS maximum
     , CAST(AVG( year_of_birth  ) AS INTEGER)   AS mean
     , STDDEV( year_of_birth  ) AS stddev
FROM
(SELECT MAX( CASE WHEN( percentile = 1  ) THEN year_of_birth END  ) AS percentile_25
      , MAX( CASE WHEN( percentile = 2  ) THEN year_of_birth END  ) AS median
      , MAX( CASE WHEN( percentile = 3  ) THEN year_of_birth END  ) AS percentile_75
  FROM
     ( SELECT counter.year_of_birth, counter.births
            , FLOOR( CAST( SUM( births  ) OVER( ORDER BY year_of_birth ROWS UNBOUNDED PRECEDING  ) AS DECIMAL  )
                   / CAST( SUM( births  ) OVER( ORDER BY year_of_birth ROWS BETWEEN UNBOUNDED PRECEDING
                                                                      AND UNBOUNDED FOLLOWING  )  AS DECIMAL  )
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
