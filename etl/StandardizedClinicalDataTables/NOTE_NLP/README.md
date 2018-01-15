# URL to CommonDataModel
- https://github.com/OHDSI/CommonDataModel/wiki/NOTE_NLP

# Source Tables

## noteevents

# Example
``` sql
-- explanation of the section_sourceconcept_id
-- the 20 first section
SELECT concept_name, section_source_concept_id, count(1)
FROM omop.note_nlp 
JOIN omop.concept ON section_source_concept_id = concept_id
GROUP by 1, 2 ORDER BY 3 desc LIMIT 20;
```
             concept_name             | section_source_concept_id |  count
--------------------------------------+---------------------------+---------
 No particular Section                |                2002120774 | 2083180
 Service                              |                2002120911 |   59240
 Date of Birth                        |                2002120912 |   51875
 INTERPRETATION:                      |                2002121023 |   45794
 LEFT VENTRICLE:                      |                2002121025 |   42996
 MITRAL VALVE:                        |                2002121026 |   41747
 AORTIC VALVE:                        |                2002121027 |   41228
 RIGHT VENTRICLE:                     |                2002121028 |   41203
 Attending                            |                2002120914 |   41036
 Allergies                            |                2002120913 |   41025
 Discharge Disposition                |                2002120915 |   40811
 PERICARDIUM:                         |                2002121029 |   40534
 TRICUSPID VALVE:                     |                2002121030 |   39280
 Major Surgical or Invasive Procedure |                2002120918 |   38733
 Brief Hospital Course                |                2002120916 |   38661
 Discharge Diagnosis                  |                2002120917 |   38649
 Discharge Condition                  |                2002120919 |   38584
 History of Present Illness           |                2002120921 |   38496
 Past Medical History                 |                2002120920 |   38478
 Social History                       |                2002120923 |   37894


``` sql
-- to access to one section
SELECT lexical_variant 
FROM note_nlp
WHERE section_source_concept_id = 2002120913  -- concept.concept_name = 'Allergies' 
limit 5 ;
```
         lexical_variant
---------------------------------
 Allergies:                     +
 Sulfa (Sulfonamide Antibiotics)+
                                +

 Allergies:                     +
 pollen / mold / Cobalt / Nickel+
                                +

 Allergies:                     +
 Nafcillin / Penicillins        +
                                +

 Allergies:                     +
 Penicillins                    +
                                +

 Allergies:                     +
 Iodine; Iodine Containing      +
                                +

