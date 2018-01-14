# Mimic Local Codes

- they are above 2 bilion

# Mimic Manual Local Codes

- they have been added when omop didn't provided any equivalent

# Mimic Automatic Local Codes

## d_items

- concept_name is label  or 'UNKNONW' when missing or empty
- vocabulary_id is 'MIMIC Local Code'
- concept_code is itemid
- domain_id = 'd_items'
- table concept_synonym contains abbreviation
- table concept_relationship contains:
    - dbsource (has_mimic_dbsource)
    - unitname (has_mimic_unitname)
    - param_type (has_mimic_param_type)
    - linksto (has_mimic_linksto)

## d_labitems

- label is concept_name
- table concept_relationship contains:
    - dbsource (has_mimic_fluid)
    - category (has_mimic_category)
    - loinc_code ('LOINC replaced by')

## drugs

- from prescriptions attributes
- from inputevents attributes

## Procedures


## Note Sections
