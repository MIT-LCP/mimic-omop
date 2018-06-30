-- 1/ generate distinct itemid from datetimeevents
\copy (
WITH distinct_itemid AS
(
	SELECT distinct itemid 
	FROM mimiciii.datetimeevents
),
distinct_label AS
(
	SELECT label, itemid::text
	FROM mimiciii.d_items 
	WHERE itemid IN (SELECT * FROM distinct_itemid)
)
SELECT dl.*
, null  observation_concept_id
, null observation_concept_name
, c.concept_id as observation_source_concept_id
FROM distinct_label dl
JOIN concept c ON concept_code = itemid
AND c.vocabulary_id = 'MIMIC d_items')
to './datetimeevents_to_concept.csv' delimiter ',' csv header;

--2/ Manual mapping
