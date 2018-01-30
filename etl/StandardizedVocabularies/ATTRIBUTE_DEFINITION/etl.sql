INSERT INTO omop.attribute_definition 
(
  attribute_definition_id 
, attribute_name            
, attribute_description     
, attribute_type_concept_id 
, attribute_syntax          

)
VALUES 
  (1, 'Callout Delay', null, 0, null)
, (2, 'Visit Detail Delay', null, 0, null)
, (3, 'Visit Occurrence Delay', null, 0, null)
, (4, 'duration_hours', 'ventdurations - duration_hours',  0, null)
, (5, 'sofa', 'sofa - sofa',  0, null)
, (6, 'respiration', 'sofa - respiration',  0, null)
, (7, 'coagulation', 'sofa - coagulation',  0, null)
, (8, 'liver', 'sofa - liver',  0, null)
, (9, 'cardiovascular', 'sofa - cardiovascular',  0, null)
, (10, 'cns', 'sofa - cns',  0, null)
, (11, 'renal', 'sofa - renal',  0, null)
, (12, 'aki_stage_7day', 'kdigo_stages_7day - aki_stage_7day',  0, null)
, (13, 'aki_stage_48hr', 'kdigo_stages_48hr - aki_stage_48hr',  0, null)
, (14, 'duration_hours', 'vasopressordurations - duration_hours',  0, null)
, (15, 'congestive_heart_failure', 'elixhauser_ahrq - congestive_heart_failure',  0, null)
, (16, 'cardiac_arrhythmias', 'elixhauser_ahrq - cardiac_arrhythmias',  0, null)
, (17, 'valvular_disease', 'elixhauser_ahrq - valvular_disease',  0, null)
, (18, 'pulmonary_circulation', 'elixhauser_ahrq - pulmonary_circulation',  0, null)
, (19, 'peripheral_vascular', 'elixhauser_ahrq - peripheral_vascular',  0, null)
, (20, 'hypertension', 'elixhauser_ahrq - hypertension',  0, null)
, (21, 'paralysis', 'elixhauser_ahrq - paralysis',  0, null)
, (22, 'other_neurological', 'elixhauser_ahrq - other_neurological',  0, null)
, (23, 'chronic_pulmonary', 'elixhauser_ahrq - chronic_pulmonary',  0, null)
, (24, 'diabetes_uncomplicated', 'elixhauser_ahrq - diabetes_uncomplicated',  0, null)
, (25, 'diabetes_complicated', 'elixhauser_ahrq - diabetes_complicated',  0, null)
, (26, 'hypothyroidism', 'elixhauser_ahrq - hypothyroidism',  0, null)
, (27, 'renal_failure', 'elixhauser_ahrq - renal_failure',  0, null)
, (28, 'liver_disease', 'elixhauser_ahrq - liver_disease',  0, null)
, (29, 'peptic_ulcer', 'elixhauser_ahrq - peptic_ulcer',  0, null)
, (30, 'aids', 'elixhauser_ahrq - aids',  0, null)
, (31, 'lymphoma', 'elixhauser_ahrq - lymphoma',  0, null)
, (32, 'metastatic_cancer', 'elixhauser_ahrq - metastatic_cancer',  0, null)
, (33, 'solid_tumor', 'elixhauser_ahrq - solid_tumor',  0, null)
, (34, 'rheumatoid_arthritis', 'elixhauser_ahrq - rheumatoid_arthritis',  0, null)
, (35, 'coagulopathy', 'elixhauser_ahrq - coagulopathy',  0, null)
, (36, 'obesity', 'elixhauser_ahrq - obesity',  0, null)
, (37, 'weight_loss', 'elixhauser_ahrq - weight_loss',  0, null)
, (38, 'fluid_electrolyte', 'elixhauser_ahrq - fluid_electrolyte',  0, null)
, (39, 'blood_loss_anemia', 'elixhauser_ahrq - blood_loss_anemia',  0, null)
, (40, 'deficiency_anemias', 'elixhauser_ahrq - deficiency_anemias',  0, null)
, (41, 'alcohol_abuse', 'elixhauser_ahrq - alcohol_abuse',  0, null)
, (42, 'drug_abuse', 'elixhauser_ahrq - drug_abuse',  0, null)
, (43, 'psychoses', 'elixhauser_ahrq - psychoses',  0, null)
, (44, 'depression', 'elixhauser_ahrq - depression',  0, null)
;

