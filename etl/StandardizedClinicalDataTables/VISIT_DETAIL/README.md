# Source Tables

## transfers

- the room or bed movement have been removed so that only ward change are logged in the table
- the emergency stays have been added in has conventional stays (may introduce strange gap in times)
- `visit_concept_id` is equal to 9201  (Inpatient visit) for a non emergency stay
- `visit_concept_id` is equal to 9203  (Emergency room) for a emergency  stay
- `visit_concept_id` is equal to 9204  (Intensive Care Unit) for an ICU  stay
- `visit_type_concept_id` is equal to 44818518  (Visit derived from EHR record)
- the callout delay has been added in the table has an omop contrib derived variable

## services

- the services table populates the `visit_detail` too
- `visit_concept_id` is always equal to 9201  (Inpatient visit) because service information does not cover emergency stays
- `visit_type_concept_id` is equal to 45770670  (services and care)
- it is then possible to know both where the patient is (from transfers) and whose take care of him (from services)

# Contrib

Those fields have been added:
- `discharge_delay`
- `visit_detail_length`
- omop concept 9204 has been introduced for ICU stays, it should be proposed to the OHSDI community

# Example


``` sql
-- the distribution of ward types
SELECT count(1), concept_name FROM omop.visit_detail LEFT JOIN omop.concept ON (visit_detail_concept_id = concept_id) WHERE 44818518 = visit_type_concept_id GROUP BY concept_name;
```
 count |       concept_name        
-------+---------------------------
    72 | Emergency Room Visit
   187 | Inpatient Visit
   185 | Intensive Care Unit Visit
