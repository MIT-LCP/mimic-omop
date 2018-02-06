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
                      )
 INSERT INTO omop.CARE_SITE (care_site_id, care_site_name, place_of_service_concept_id, care_site_source_value, place_of_service_source_value)
 SELECT gcpt_care_site.care_site_id
      , gcpt_care_site.care_site_name
      , gcpt_care_site.place_of_service_concept_id
      , care_site_source_value
      , place_of_service_source_value
   FROM gcpt_care_site;
