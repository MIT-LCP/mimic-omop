 WITH  AS (SELECT  FROM mimic.) 
 INSERT INTO omop.CDM_SOURCE ()
 SELECT NA.cdm_source_name, NA.cdm_source_abbreviation, NA.cdm_holder, NA.source_description, NA.source_documentation_reference, NA.cdm_etl_reference, NA.source_release_date, NA.cdm_release_date, NA.cdm_version, NA.vocabulary_version 
FROM NA 