
-- -----------------------------------------------------------------------------
-- File created - January-8-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 4 );
SELECT results_eq
(
'
SELECT COUNT(*) AS num_persons_count
FROM omop.person;
'
,
'
SELECT COUNT(*) AS num_persons_count
FROM patients;
'
,'PERSON -- number patients match'
);

SELECT results_eq
(
'
SELECT COUNT(person.person_ID) AS num_persons_count
FROM omop.person as person
INNER JOIN omop.concept as concept ON person.gender_concept_id = concept.CONCEPT_ID
GROUP BY person.gender_CONCEPT_ID, concept.CONCEPT_NAME
ORDER BY num_persons_count DESC;
'
,
'
SELECT  COUNT(gender) AS num_persons_count
FROM patients
GROUP BY gender
ORDER BY num_persons_count DESC;
'
,'PERSON -- gender distribution matches'
);

SELECT results_eq
(
'
SELECT percentile_25
       , median
       , percentile_75
       , MIN( extract(year from dob  ))    AS minimum
       , MAX( extract(year from dob  )) AS maximum
       , CAST(AVG( extract(year from dob  )) AS INTEGER)   AS mean
       , FLOOR(STDDEV( extract(year from dob  ))) AS stddev
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
             ( SELECT extract(year from dob) as year_of_birth, count(*) AS births
                FROM patients
                GROUP BY extract(year from dob)
              ) as counter
       ) as p
     WHERE percentile <= 3
    ) as percentile_table, patients
  GROUP BY percentile_25, median, percentile_75;
'
,
'
SELECT percentile_25
       , median
       , percentile_75
       , MIN(extract(year from birth_datetime) )    AS minimum
       , MAX(extract(year from birth_datetime ))    AS maximum
       , CAST(AVG(extract(year from birth_datetime)) AS INTEGER)   AS mean
       , FLOOR(STDDEV( extract(year from birth_datetime)  )) AS stddev
  FROM
  (SELECT MAX( CASE WHEN( percentile = 1  ) THEN year_of_birth END  ) AS percentile_25
        , MAX( CASE WHEN( percentile = 2  ) THEN year_of_birth END  ) AS median
        , MAX( CASE WHEN( percentile = 3  ) THEN year_of_birth END  ) AS percentile_75
    FROM
       ( SELECT counter.year_of_birth, counter.births
           , FLOOR( CAST( SUM( births  ) OVER( ORDER BY year_of_birth ROWS UNBOUNDED PRECEDING  ) AS DECIMAL )
		/ CAST( SUM( births  ) OVER( ORDER BY year_of_birth ROWS BETWEEN UNBOUNDED PRECEDING
                                                            AND UNBOUNDED FOLLOWING  )  AS DECIMAL )
                     * 4
                      ) + 1
          as percentile
          FROM
             ( SELECT extract(year from birth_datetime) as year_of_birth, count(*) AS births
                FROM omop.person as person
                GROUP BY extract(year from birth_datetime)
              ) as counter
       ) as p
     WHERE percentile <= 3
    ) as percentile_table, omop.person
  GROUP BY percentile_25, median, percentile_75;
'
,'PERSON -- date of birth year distributions match'
);

SELECT results_eq
(
'
SELECT 0::integer;
'
,
'
WITH tmp AS
(
        SELECT person_id
             , CASE when death.death_datetime < person.birth_datetime THEN 1 ELSE 0 END AS abnormal
        FROM omop.person
        JOIN omop.death USING (person_id)

)
SELECT max(abnormal) FROM tmp;
'
,'PERSON -- no births after deaths'
);


SELECT * FROM finish();
ROLLBACK;
