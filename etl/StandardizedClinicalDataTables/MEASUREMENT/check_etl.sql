BEGIN;

SELECT plan(3);

-- 1.checker global distribution labevents globale(2)
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
AND value_as_number is not null and operator_concept_id is null
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
ORDER BY pat.mimic_id desc, itemid desc, count(itemid) desc;
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
AND value_as_number is not null and operator_concept_id is null
GROUP BY person_id, concept_code
ORDER BY person_id desc, concept_code desc, count(measurement_source_concept_id);
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

SELECT * from finish();
ROLLBACK;
