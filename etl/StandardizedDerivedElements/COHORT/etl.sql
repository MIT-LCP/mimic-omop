INSERT INTO omop.cohort
(
  cohort_definition_id
, subject_id
, cohort_start_date
, cohort_end_date
)
SELECT
1 -- angus severe
, mimic_id , admittime , dischtime
FROM sepsis.hadm_deliberation_all
JOIN admissions USING (hadm_id)
WHERE angus = 1
UNION
SELECT
2 -- angus shock
, mimic_id , admittime , dischtime
FROM sepsis.hadm_deliberation_all
JOIN admissions USING (hadm_id)
WHERE angus = 2
UNION
SELECT
3 -- accp_severe
, mimic_id , admittime , dischtime
FROM sepsis.hadm_deliberation_all
JOIN admissions USING (hadm_id)
WHERE accp = 1
UNION
SELECT
4 -- accp_shock
, mimic_id , admittime , dischtime
FROM sepsis.hadm_deliberation_all
JOIN admissions USING (hadm_id)
WHERE accp = 2
UNION
SELECT
5 -- sepsis severe
, mimic_id , admittime , dischtime
FROM sepsis.hadm_deliberation_all
JOIN admissions USING (hadm_id)
WHERE sepsis3 = 1
UNION
SELECT
6 -- sepsis shock
, mimic_id , admittime , dischtime
FROM sepsis.hadm_deliberation_all
JOIN admissions USING (hadm_id)
WHERE sepsis3 = 2
