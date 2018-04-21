 WITH
"wardid" as (
        select distinct coalesce(curr_careunit,'UNKNOWN') as curr_careunit, curr_wardid
        from transfers
),
"gcpt_care_site" AS (
 SELECT
      nextval('mimic_id_seq') as care_site_id
    , CASE
      WHEN wardid.curr_careunit IS NOT NULL THEN format_ward(care_site_name, curr_wardid)
      ELSE care_site_name end as care_site_name
    , place_of_service_concept_id as place_of_service_concept_id
    , care_site_name as care_site_source_value
    , place_of_service_source_value
 FROM gcpt_care_site
 left join wardid on care_site_name = curr_careunit
),
"insert_relationship_itself" AS (
	INSERT INTO omop.fact_relationship
	(domain_concept_id_1, fact_id_1, domain_concept_id_2, fact_id_2, relationship_concept_id)
SELECT
  57 AS domain_concept_id_1 -- 57    Care site
, care_site_id AS fact_id_1
, 57 AS domain_concept_id_2 -- 57    Care site
, care_site_id AS fact_id_2 
, 46233688 as relationship_concept_id -- care site has part of care site (any level is part of himself)
FROM gcpt_care_site
),
"insert_relationship_ward_hospit" AS ( --link the wards to BIDMC hospital
	INSERT INTO omop.fact_relationship
	(domain_concept_id_1, fact_id_1, domain_concept_id_2, fact_id_2, relationship_concept_id)
SELECT
  57 AS domain_concept_id_1 -- 57    Care site
, gc1.care_site_id AS fact_id_1
, 57 AS domain_concept_id_2 -- 57    Care site
, gc2.care_site_id AS fact_id_2 
, 46233688 as relationship_concept_id -- care site has part of care site (any level is part of himself)
FROM gcpt_care_site gc1
JOIN gcpt_care_site gc2 ON gc2.care_site_name = 'BIDMC' 
WHERE gc1.care_site_name ~ ' ward '
)
INSERT INTO omop.CARE_SITE
(
   care_site_id
 , care_site_name
 , place_of_service_concept_id
 , care_site_source_value
 , place_of_service_source_value
)
SELECT gcpt_care_site.care_site_id
    , gcpt_care_site.care_site_name
    , gcpt_care_site.place_of_service_concept_id
    , care_site_source_value
    , place_of_service_source_value
FROM gcpt_care_site;
