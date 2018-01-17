# Mimic Local Codes

- they are above 2 bilion

# Mimic Manual Local Codes

- they have been added when omop didn't provided any equivalent

# Mimic Automatic Local Codes

## d_items

- concept_name is a concatenation of main source table information
- vocabulary_id is 'MIMIC Local Code'
- concept_code is itemid
- domain_id = 'd_items'
- table concept_synonym contains abbreviation

## d_labitems

- concept_name is a concatenation of main source table information
- vocabulary_id is 'MIMIC Local Code'
- concept_code is itemid
- domain_id = 'd_labitems'

## drugs

- from prescriptions attributes
- concept_name is a concatenation of main source table information
- from inputevents attributes

## Procedures

- from prescriptions attributes
- concept_name  the long title or the short title whn not exists
- concept_synonyms tables contains the short title when the long title exists


## Note Sections
