# link to CommonDataModel
- [PERSON](https://github.com/OHDSI/CommonDataModel/wiki/PERSON)

# Source Tables

## mimic.patients

- information about death are moved to `omop.death` table

## mimic.admissions

- the ethicity comes from admissions, the first recorded value is put in the `omop.person` table 

# Mapping used

## [ethnicity_to_concept](https://github.com/MIT-LCP/mimic-omop/blob/master/extras/concept/ethnicity_to_concept.csv)

- it maps the mimic ethnicity to omop ethnicity

# Examples

``` sql
--  100 patients!!
SELECT COUNT(person_id) AS num_persons_count
FROM person;
```

| num_persons_count |
|-------------------|
|               100|

``` sql
-- Number of patients grouped by gender
SELECT  person.GENDER_CONCEPT_ID,
        concept.CONCEPT_NAME AS ethnicity_name,
        COUNT(person.person_ID) AS num_persons_count
FROM person
INNER JOIN concept ON person.GENDER_concept_id = concept.CONCEPT_ID
GROUP BY person.GENDER_CONCEPT_ID, concept.CONCEPT_NAME;
```

| gender_concept_id | ethnicity_name | num_persons_count |
|-------------------|----------------|-------------------|
|              8507 | MALE           |                49|
|              8532 | FEMALE         |                51|

``` sql
-- Number of patients grouped by race
SELECT  person.RACE_CONCEPT_ID,
        concept.CONCEPT_NAME AS race_name,
        COUNT(person.person_ID) AS num_persons_count
FROM person
INNER JOIN concept ON person.RACE_CONCEPT_ID = concept.CONCEPT_ID
GROUP BY person.RACE_CONCEPT_ID, concept.CONCEPT_NAME;
```

| race_concept_id |            race_name            | num_persons_count |
|-----------------|---------------------------------|-------------------|
|            8515 | Asian                           |                 3|
|            8527 | White                           |                67|
|         4087921 | Other ethnic non-mixed          |                 3|
|         4188161 | Hispanic, color unknown         |                 1|
|         4188164 | History of chronic lung disease |                 4|
|         4213463 | Portuguese                      |                 1|
|         4218674 | Unknown racial group            |                16|
|        38003592 | Vietnamese                      |                 1|
|        38003599 | African American                |                 3|
|        38003614 | European                        |                 1|

``` sql
-- Number of patients grouped by ethnicity
SELECT  person.ETHNICITY_CONCEPT_ID,
        concept.CONCEPT_NAME AS ethnicity_name,
        COUNT(person.person_ID) AS num_persons_count
FROM person
INNER JOIN concept ON person.ETHNICITY_CONCEPT_ID = concept.CONCEPT_ID
GROUP BY person.ETHNICITY_CONCEPT_ID, concept.CONCEPT_NAME;
```

| ethnicity_concept_id |   ethnicity_name    | num_persons_count |
|----------------------|---------------------|-------------------|
|                    0 | No matching concept |               100|

``` sql
-- Distribution of year of birth
SELECT percentile_25
     , median
     , percentile_75
     , MIN( year_of_birth   )    AS minimum
     , MAX( year_of_birth   )    AS maximum
     , CAST(AVG( year_of_birth   ) AS INTEGER)   AS mean
     , STDDEV( year_of_birth   ) AS stddev
FROM
(SELECT MAX( CASE WHEN( percentile = 1   ) THEN year_of_birth END   ) AS percentile_25
      , MAX( CASE WHEN( percentile = 2   ) THEN year_of_birth END   ) AS median
      , MAX( CASE WHEN( percentile = 3   ) THEN year_of_birth END   ) AS percentile_75
  FROM
     ( SELECT counter.year_of_birth, counter.births
            , FLOOR( CAST( SUM( births   ) OVER( ORDER BY year_of_birth ROWS UNBOUNDED PRECEDING   ) AS DECIMAL   )
                   / CAST( SUM( births   ) OVER( ORDER BY year_of_birth ROWS BETWEEN UNBOUNDED PRECEDING
                                                                      AND UNBOUNDED FOLLOWING   )  AS DECIMAL   )
                   * 4
                     ) | 1
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
|          2069 |   2100 |          2129 |    1817 |    2187 | 2090 | 72.9610903637733958|
