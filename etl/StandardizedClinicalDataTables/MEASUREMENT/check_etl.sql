BEGIN;

SELECT plan(7);

-- 1.checker global distribution labevents
SELECT results_eq
(
'
SELECT count(1), cast(FLOOR(MIN(valuenum)) as numeric), cast(FLOOR(AVG(valuenum)) as numeric), cast(floor(MAX(valuenum)) as numeric)
FROM labevents lab
JOIN d_labitems USING (itemid)
where itemid IN
  (
        SELECT itemid
        from labevents join d_labitems using (itemid)
        group by itemid order by count(itemid) desc
  )
AND valuenum is not null
GROUP BY itemid
ORDER BY itemid, count(itemid) desc;
'
,
'
SELECT count(1), floor(MIN(value_as_number)), floor(AVG(value_as_number)), floor(MAX(value_as_number)
)
FROM omop.measurement
JOIN omop.concept on measurement_source_concept_id = concept_id
Where concept_code IN
  (
        SELECT itemid::VARCHAR
        from labevents join d_labitems using (itemid)
        group by itemid order by count(itemid) desc
  )
AND value_as_number is not null and operator_concept_id = 4172703
GROUP BY concept_code
ORDER BY concept_code, count(measurement_source_concept_id) desc;
'
,
'MEASUREMENT -- check distribution of all labs match'
);

-- 2. repartition des microorganismes
SELECT results_eq
(
'
SELECT org_name::TEXT, count(1)
FROM
(
	SELECT DISTINCT ON
    (hadm_id, spec_type_desc, org_name, coalesce(charttime, chartdate))
    AS org_name
	FROM microbiologyevents
  WHERE org_name IS NOT NULL
) tmp
GROUP BY org_name ORDER BY 2, 1 desc;
'
,
'
SELECT value_source_value::TEXT, count(1)
FROM omop.measurement
WHERE measurement_type_concept_id = 2000000007
AND value_as_concept_id IS DISTINCT FROM 9189
GROUP BY value_source_value ORDER BY 2, 1 desc;
'
,
'MEASUREMENT -- check microbiology organism distributions match'
);

SELECT results_eq
(
'
select 0::integer;
'
,
'
SELECT count(1)::integer
FROM omop.measurement
WHERE measurement_source_concept_id = 0;
'
,
'MEASUREMENT -- there is source concept in measurement not described'
);


SELECT results_eq
(
'
SELECT 0::INTEGER;
'
,
'
SELECT COUNT(1)::INTEGER
FROM
(
  SELECT COUNT(1)::INTEGER
  FROM omop.measurement
  GROUP BY measurement_id
  HAVING COUNT(1) > 1
) as t;
'
,
'MEASUREMENT -- check for duplicate primary keys'
);

SELECT results_eq
(
'
SELECT 0::INTEGER;
'
,
'
SELECT COUNT(1)::INTEGER
FROM omop.measurement
LEFT JOIN omop.concept
  ON measurement_concept_id = concept_id
WHERE measurement_concept_id != 0
AND standard_concept != ''S'';
'
,
'MEASUREMENT -- standard concept checker'
);

SELECT results_eq
(
'
WITH omop_measure AS
(
  SELECT concept_code::integer as itemid, count(*)
  FROM omop.measurement
  JOIN omop.concept ON measurement_source_concept_id = concept_id
  WHERE measurement_type_concept_id IN (44818701, 44818702, 2000000003, 2000000009, 2000000010, 2000000011)
  group by 1 order by 1 asc
),
omop_observation AS
(
  SELECT concept_code::integer as itemid, count(*)
  FROM omop.observation
  JOIN omop.concept ON observation_source_concept_id = concept_id
  WHERE observation_type_concept_id = 581413
  group by 1 order by 1 asc
),
omop_result AS
(
  SELECT * from omop_measure
  UNION
  SELECT * from omop_observation
)
SELECT itemid, count
FROM omop_result
ORDER BY 1 asc;
'
,
'
WITH mimic_chartevents as
(
	SELECT itemid, count(*)
	from chartevents
	WHERE error is null or error = 0
	group by 1 order by 1 asc
),
mimic_labevents AS
(
	SELECT itemid, count(*)
	from labevents
	group by 1 order by 1 asc
),
mimic_output AS
(
	SELECT itemid, count(*)
	FROM outputevents
	WHERE iserror is null
	group by 1 order by 1 asc
),
mimic_result AS
(
	SELECT *
	from mimic_chartevents
	UNION
	SELECT *
	from mimic_labevents
	UNION
	SELECT *
	FROM mimic_output
)
SELECT itemid, count
FROM mimic_result
ORDER BY 1 asc;
'
,
'MEASUREMENT -- check row counts match'
);

SELECT pass( 'Measurement pass, w00t!' );

SELECT * from finish();
ROLLBACK;
