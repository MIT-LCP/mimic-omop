with
"note_section"  as 
(
select 
  noteevents.mimic_id as note_id
, nextval('mimic_id_seq') as note_nlp_id
, coalesce(concept.concept_id, 0) as section_concept_id         
, section_begin as offset_begin
, section_end as offset_end
, section_text as lexical_variant
, 'UIMA Section Extractor v1.0'::text as nlp_system
, now()::date as nlp_date
, now() as nlp_datetime
, gcpt_note_section_to_concept.label as section_source_value
, gcpt_note_section_to_concept.mimic_id as section_source_concept_id
from omop.tmp_note_nlp
join noteevents using (row_id)
left join gcpt_note_section_to_concept ON section_code = section_id
left join omop.concept on label = concept_name AND concept_code = 'MIMIC Generated' AND domain_id = 'Note Nlp' and concept.vocabulary_id = noteevents.category
WHERE iserror IS NULL
)
INSERT INTO omop.note_nlp
(
  note_nlp_id         
, note_id                    
, section_concept_id         
, snippet                    
, lexical_variant            
, note_nlp_concept_id        
, note_nlp_source_concept_id 
, nlp_system                 
, nlp_date                   
, nlp_datetime               
, term_exists                
, term_temporal              
, term_modifiers             
, offset_begin               
, offset_end                 
, section_source_value       
, section_source_concept_id  
)
SELECT
  note_nlp_id         
, note_id                    
, section_concept_id         
, null::text as snippet                    
, lexical_variant            
, 4307844 as note_nlp_concept_id  --document section
, 0 as note_nlp_source_concept_id -- 0
, nlp_system                 
, nlp_date                   
, nlp_datetime               
, null::text as term_exists                
, null::text as term_temporal              
, null::text as term_modifiers             
, offset_begin               
, offset_end                 
, section_source_value       
, section_source_concept_id  
FROM note_section;
