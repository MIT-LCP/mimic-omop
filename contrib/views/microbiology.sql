DROP MATERIALIZED VIEW IF EXISTS microbiology CASCADE;
CREATE MATERIALIZED VIEW microbiology 	AS

WITH org_res AS
(
SELECT org.person_id 			AS person_id
, org.visit_occurrence_id 		AS visit_occurrence_id
, org.visit_detail_id 			AS visit_detail_id

, org.measurement_id
, org.value_as_concept_id  		AS organism_concept_id
, org_concept.concept_name 		AS organism_concept_name
, org.value_source_value 		AS organism_source_value
, null::integer 			AS organism_quantity

, org.measurement_source_value  	AS specimen_source_value

, atb.measurement_concept_id 		AS antibiotic_concept_id
, atb_concept.concept_name 		AS antibiotic_concept_name
, atb.measurement_source_value  	AS antibiotic_source_value
, atb.value_as_concept_id       	AS antibiotic_interpretation_concept_id
, resistance.concept_name       	AS antibiotic_interpretation_concept_name
, atb.value_source_value            	AS antibiotic_MIC_interpration -- TODO extract operateur et la value in 2 != columns

FROM
(
	SELECT fact_id_1, fact_id_2
	FROM fact_relationship
	WHERE fact_id_1 IN
	(
        	SELECT measurement_id
        	FROM measurement
        	WHERE measurement_type_concept_id = 2000000007
    	
	)
	AND relationship_concept_id = 44818757


) as fact
JOIN measurement org ON org.measurement_id = fact.fact_id_1 and org.measurement_type_concept_id = 2000000007
	JOIN concept org_concept ON org_concept.concept_id = org.measurement_concept_id
JOIN measurement atb ON atb.measurement_id = fact.fact_id_2 and atb.measurement_type_concept_id = 2000000008
	JOIN concept atb_concept ON atb_concept.concept_id = atb.measurement_concept_id
	JOIN concept resistance ON resistance.concept_id = atb.value_as_concept_id

)

SELECT o.person_id
, o.visit_occurrence_id
, o.visit_detail_id
, specimen.specimen_date               	AS microbiology_date
, specimen.specimen_datetime           	AS microbiology_datetime

-- organisms
, o.organism_concept_id
, o.organism_concept_name
, o.organism_source_value
, o.organism_quantity

-- specimen
, specimen.specimen_concept_id 		AS specimen_concept_id
, specimen_concept.concept_name 	AS specimen_concept_name
, o.specimen_source_value

-- atb
, o.antibiotic_concept_id
, o.antibiotic_concept_name
, o.antibiotic_source_value
, o.antibiotic_interpretation_concept_id
, o.antibiotic_interpretation_concept_name
, o.antibiotic_MIC_interpration

, 0::integer 				AS linker  
-- if all the informations related to a specimen are in this view, linker is equal 0 ; else 1

FROM org_res o
JOIN fact_relationship f ON o.measurement_id = f.fact_id_1 and f.relationship_concept_id = 44818756
JOIN specimen ON specimen.specimen_id = f.fact_id_2
	JOIN concept specimen_concept ON specimen_concept.concept_id = specimen.specimen_concept_id;
