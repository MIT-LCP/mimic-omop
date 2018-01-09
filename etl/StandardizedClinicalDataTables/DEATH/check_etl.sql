
-- -----------------------------------------------------------------------------
-- File created - January-9-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 2 );

-- 1. number dead patient checker
SELECT results_eq
(
'
SELECT COUNT(person_id) AS num_dead_count
FROM omop.death;
'

,
'
SELECT COUNT(expire_flag) AS num_dead_count
FROM patients
WHERE expire_flag = 1;
' 
);

/*
-- 2. number dead patient in hospital checker
SELECT results_eq
(
'
-- -- Todo

'
,
'
SELECT COUNT(*) AS num_dead_count
FROM admissions
WHERE hospital_expire_flag = 1;
'
);
*/

-- 3. distribution age checker
SELECT results_eq
(
'
SELECT FLOOR (percentile_25) AS percentile_25
       , FLOOR(median) AS median
       , FLOOR(percentile_75) AS percentile_75
       , FLOOR (MIN( cast(death.death_datetime as date) - cast(person.birth_datetime as date))  / 365.242  )    AS minimum
       , FLOOR (MAX( cast(death.death_datetime as date) - cast(person.birth_datetime as date))  / 365.242  )    AS maximum
       , CAST(FLOOR (AVG(cast(death.death_datetime as date) - cast(person.birth_datetime as date))  / 365.242 ) AS INTEGER)   AS mean
       , FLOOR(STDDEV( cast(death.death_datetime as date) - cast(person.birth_datetime as date))  / 365.242  ) AS stddev
  FROM
  (SELECT MAX( CASE WHEN( percentile = 1  ) THEN age_deaths END  ) AS percentile_25
        , MAX( CASE WHEN( percentile = 2  ) THEN age_deaths END  ) AS median
        , MAX( CASE WHEN( percentile = 3  ) THEN age_deaths END  ) AS percentile_75
    FROM
       ( SELECT counter.age_deaths, counter.deaths
              , FLOOR( CAST( SUM( age_deaths  ) OVER( ORDER BY age_deaths ROWS UNBOUNDED PRECEDING  ) AS DECIMAL  )
                     / CAST( SUM( age_deaths  ) OVER( ORDER BY age_deaths ROWS BETWEEN UNBOUNDED PRECEDING
                                                                        AND UNBOUNDED FOLLOWING  )  AS DECIMAL  )
                     * 4
                      ) + 1
          as percentile
          FROM
             ( SELECT FLOOR (cast(death.death_datetime as date) - cast(person.birth_datetime as date))  / 365.242 as age_deaths, count(*) AS deaths
                FROM omop.death as death
		INNER JOIN omop.person as person USING (person_id)
                GROUP BY FLOOR (cast(death.death_datetime as date) - cast(person.birth_datetime as date))
              ) as counter
       ) as p
     WHERE percentile <= 3
  ) as percentile_table, omop.death
  INNER JOIN omop.person as person USING (person_id)
  GROUP BY percentile_25, median, percentile_75;
'
,
'
SELECT FLOOR (percentile_25) AS percentile_25
       , FLOOR(median) AS median
       , FLOOR(percentile_75) AS percentile_75
       , FLOOR (MIN( cast(dod as date) - cast(dob as date))  / 365.242  )    AS minimum
       , FLOOR (MAX( cast(dod as date) - cast(dob as date))  / 365.242  )    AS maximum
       , CAST(FLOOR (AVG(cast(dod as date) - cast(dob as date))  / 365.242 ) AS INTEGER)   AS mean
       , FLOOR(STDDEV( cast(dod as date) - cast(dob as date))  / 365.242  ) AS stddev
  FROM
  (SELECT MAX( CASE WHEN( percentile = 1  ) THEN age_deaths END  ) AS percentile_25
        , MAX( CASE WHEN( percentile = 2  ) THEN age_deaths END  ) AS median
        , MAX( CASE WHEN( percentile = 3  ) THEN age_deaths END  ) AS percentile_75
    FROM
       ( SELECT counter.age_deaths, counter.deaths
              , FLOOR( CAST( SUM( age_deaths  ) OVER( ORDER BY age_deaths ROWS UNBOUNDED PRECEDING  ) AS DECIMAL  )
                     / CAST( SUM( age_deaths  ) OVER( ORDER BY age_deaths ROWS BETWEEN UNBOUNDED PRECEDING
                                                                        AND UNBOUNDED FOLLOWING  )  AS DECIMAL  )
                     * 4
                      ) + 1
          as percentile
          FROM
             ( SELECT FLOOR (cast(dod as date) - cast(dob as date))  / 365.242 as age_deaths, count(*) AS deaths
                FROM patients
                GROUP BY FLOOR (cast(dod as date) - cast(dob as date))
              ) as counter
       ) as p
     WHERE percentile <= 3
  ) as percentile_table, patients
  GROUP BY percentile_25, median, percentile_75;
'
);




SELECT * FROM finish();
ROLLBACK;
