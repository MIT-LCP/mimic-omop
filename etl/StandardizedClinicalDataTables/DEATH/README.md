# Link to CommonDataModel
- [DEATH](https://github.com/OHDSI/CommonDataModel/wiki/DEATH)

# Source Tables

## [admissions](https://mimic.physionet.org/mimictables/admissions/)

- `admissions.deathtime` is considered as the reference (compared to patients table)
- for 11 admissions, the admissions.deathtime is after the `admissions.dischtime`. 
  However, for those 11 patients the `patients.dod_hosp` is equal to the `admissions.dischtime`. Then the later is used in this particular case
- patients dead during hospitalisation have `death_type_concept_id` equal to 38003569

## [patients](https://mimic.physionet.org/mimictables/patients/)

- patients `dod_hosp` has been described has odd behavior (https://github.com/MIT-LCP/mimic-code/issues/190)
- only `dod_ssn` is taken in consideration and the omop `death_type_concept_id` is equal to 261

# Examples

## Number of dead patients in the dataset

``` sql
SELECT COUNT(person_id) AS num_deaths_count
FROM death;
```
| num_deaths_count |
|------------------|
|            14849|

## distinct `death_type_concept_id` dead patients in the database

``` sql
SELECT distinct concept_name, death_type_concept_id  as concept_id
FROM death d
JOIN concept c ON d.death_type_concept_id = c.concept_id;
```
|                concept_name                 | concept_id |
|---------------------------------------------|------------|
| EHR record patient status "Deceased"        |   38003569|
| US Social Security Death Master File record |        261|

## Distribution of age of death

``` sql
SELECT FLOOR (percentile_25) AS percentile_25
       , FLOOR(median) AS median
       , FLOOR(percentile_75) AS percentile_75
       , FLOOR (MIN( cast(death.death_datetime as date) - cast(person.birth_datetime as date)  )  / 365.242  )    AS minimum
       , FLOOR (MAX( cast(death.death_datetime as date) - cast(person.birth_datetime as date)  )  / 365.242  )    AS maximum
       , CAST(FLOOR (AVG(cast(death.death_datetime as date) - cast(person.birth_datetime as date))  / 365.242 ) AS INTEGER)   AS mean
       , FLOOR(STDDEV( cast(death.death_datetime as date) - cast(person.birth_datetime as date)  )  / 365.242  ) AS stddev
  FROM
  (SELECT MAX( CASE WHEN( percentile = 1    ) THEN age_deaths END    ) AS percentile_25
        , MAX( CASE WHEN( percentile = 2    ) THEN age_deaths END    ) AS median
        , MAX( CASE WHEN( percentile = 3    ) THEN age_deaths END    ) AS percentile_75
    FROM
       ( SELECT counter.age_deaths, counter.deaths
              , FLOOR( CAST( SUM( age_deaths    ) OVER( ORDER BY age_deaths ROWS UNBOUNDED PRECEDING    ) AS DECIMAL    )
                     / CAST( SUM( age_deaths    ) OVER( ORDER BY age_deaths ROWS BETWEEN UNBOUNDED PRECEDING
                                                                        AND UNBOUNDED FOLLOWING    )  AS DECIMAL    )
                     * 4
                        ) + 1
          as percentile
          FROM
             ( SELECT FLOOR (cast(death.death_datetime as date) - cast(person.birth_datetime as date))  / 365.242 as age_deaths, count(*) AS deaths
                FROM death as death
		INNER JOIN person as person USING (person_id)
                GROUP BY FLOOR (cast(death.death_datetime as date) - cast(person.birth_datetime as date))
                ) as counter
         ) as p
     WHERE percentile <= 3
  ) as percentile_table, death
  INNER JOIN person as person USING (person_id)
  GROUP BY percentile_25, median, percentile_75;
```
| percentile_25 | median | percentile_75 | minimum | maximum | mean | stddev |
|---------------|--------|---------------|---------|---------|------|--------|
|            67 |     79 |            90 |       0 |     310 |   91 |     68|
