# Phases

## phase 0
make source's source values fit into X_source_value columns in OMOP 
CDM

## phase 1 (using athena (concept table)
assume source values are nice - infer correct concept_id into 
X_source_concept_id

## phase 2 (using athena again (concept relationships) 
assume simple 
mapping, infer correct  X_concept_id fields from X_source_concept_id
