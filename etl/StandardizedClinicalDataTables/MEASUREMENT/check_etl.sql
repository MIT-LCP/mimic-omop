BEGIN;

SELECT plan(3);
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
);

-- 2.checker distribution labevents / patients
SELECT results_eq
(
'
SELECT count(1), cast(FLOOR(MIN(valuenum)) as numeric), cast(FLOOR(AVG(valuenum)) as numeric), cast(floor(MAX(valuenum)) as numeric)
FROM labevents lab
JOIN d_labitems USING (itemid)
JOIN patients pat on pat.subject_id = lab.subject_id
where itemid IN
  (
        SELECT itemid
        from labevents join d_labitems using (itemid)
        group by itemid order by count(itemid) desc
  )
AND valuenum is not null
GROUP BY pat.mimic_id, itemid
ORDER BY pat.mimic_id desc, itemid desc, count(itemid) desc limit 1000;
'
,
'
SELECT count(1), floor(MIN(value_as_number)), floor(AVG(value_as_number)), floor(MAX(value_as_number))
FROM omop.measurement
JOIN omop.concept on measurement_source_concept_id = concept_id
Where concept_code IN
  (
        SELECT itemid::VARCHAR
        from labevents join d_labitems using (itemid)
        group by itemid order by count(itemid) desc
  )
AND value_as_number is not null and operator_concept_id  = 4172703
GROUP BY person_id, concept_code
ORDER BY person_id desc, concept_code desc, count(measurement_source_concept_id) limit 1000;
'
);

-- 3.checker distribution labevents charttime (2)
SELECT results_eq
(
'
SELECT count(1), MIN(charttime), MAX(charttime)
FROM labevents lab
JOIN d_labitems USING (itemid)
where itemid IN
  (
        SELECT itemid
        from labevents join d_labitems using (itemid)
        group by itemid order by count(itemid) desc
  )
GROUP BY itemid
ORDER BY itemid, count(itemid) desc;
'
,
'
SELECT count(1), MIN(measurement_datetime), MAX(measurement_datetime)
FROM omop.measurement
JOIN omop.concept on measurement_source_concept_id = concept_id
Where concept_code IN
  (
        SELECT itemid::VARCHAR
        from labevents join d_labitems using (itemid)
        group by itemid order by count(itemid) desc
  )
GROUP BY concept_code
ORDER BY concept_code, count(measurement_source_concept_id) desc;
'
);


-- 4.repartition des microorganismes
SELECT results_eq
(
'
SELECT org_name::TEXT, count(1) 
FROM (
	SELECT distinct on (hadm_id, spec_type_desc, org_name, coalesce( charttime, chartdate)) org_name--, count(org_name)
	from microbiologyevents where org_name is not null
     ) tmp
GROUP BY org_name ORDER BY 2, 1 desc;
'
,
'
SELECT value_source_value::TEXT, count(1) FROM omop.measurement
WHERE measurement_type_concept_id = 2000000007
And value_as_concept_id is distinct from 9189
Group by value_source_value order by 2, 1 desc;
'
);

-- 5. examen negatif
SELECT results_eq
(
'
SELECT count(*)
FROM (
        SELECT distinct on (hadm_id, spec_itemid, coalesce (charttime, chartdate)) *--, count(org_name)
        from microbiologyevents where org_name is null
) tmp;
'
,
'

SELECT count(*)
FROM omop.measurement 
where measurement_type_concept_id = 2000000007 and value_as_concept_id = 9189;
'
);


SELECT * from finish();
ROLLBACK;
