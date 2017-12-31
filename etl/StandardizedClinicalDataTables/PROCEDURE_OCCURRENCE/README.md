# Lookup Table

- `cpt4_to_concept`
- `\copy (SELECT distinct '[' || coalesce(costcenter,'') || '][' || coalesce(sectionheader,'') || '] ' || subsectionheader || ' ' || coalesce(description, '') as procedure_source_value FROM mimic.cptevents  order by 1) TO '/tmp/cpt4_to_concept.csv' CSV HEADER QUOTE '"';`
