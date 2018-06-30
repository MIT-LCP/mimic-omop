-- 1/ Generate mapping of HCFA and MS drg_type from drgcodes
-- using concept and concept_relationship OMOP table 
\copy (
WITH DRG AS 
(
	SELECT drg_code, description, concept_id, concept_name 
	FROM mimiciii.drgcodes d 
	JOIN omop.CONCEPT c 
	ON d.drg_code = c.concept_code 
	AND drg_type = 'HCFA' 
	AND concept_class_id = 'DRG'
), 
standardisation_DRG AS 
(
	SELECT d.drg_code
	, d.description
	, d.concept_id as observation_source_concept_id
	, d.concept_name as observation_source_concept_name
	, rs.concept_id_2 as observation_concept_id
	, c.concept_name 
	FROM DRG d 
	LEFT JOIN concept_relationship  rs 
	ON d.concept_id = rs.concept_id_1 
	LEFT JOIN concept c 
	ON rs.concept_id_2 = c.concept_id 
	AND c.standard_concept = 'S'
), 
MS_DRG AS 
(
	SELECT drg_code
	, description
	, 0 as observation_source_concept_id
	, null::text as observation_source_concept_name
	, concept_id as observation_concept_id
	, concept_name 
	FROM mimiciii.drgcodes d 
	JOIN omop.CONCEPT c 
	ON d.drg_code = c.concept_code 
	AND drg_type = 'MS' 
	AND concept_class_id = 'MS-DRG' 
	AND standard_concept = 'S'
), 
union_DRG AS 
(
	SELECT * 
	FROM standardisation_DRG 
	UNION 
	SELECT * 
	FROM MS_DRG
) 
SELECT * FROM union_DRG ORDER BY description
) to './drgcode_to_concept.csv' delimiter ',' csv header;

-- 2/ Check automatic mapping for HCFA and MS 
-- 2/ Add mapping for APR drg_type from drgcodes
