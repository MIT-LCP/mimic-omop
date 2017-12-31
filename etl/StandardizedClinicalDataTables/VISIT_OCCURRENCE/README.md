# Source Tables

## admissions

- some informations from admissions are populated elswhere (religion, ethnicity, deathtime) respectiveley in (observation, person/observation, death)
- emergency information have been extracted
- when the admissions is emergency, then 
	- the admission start datetime becomes the emergency start datetime
	- that emergency stay is added to transfers (in the `visit_details` table)
- `visit_type_concept_id` is always equals to 44818518 (visit derived from EHR)
- `visit_concept_id` is either equals to 9201 (inpatient visit) or 262 (emergency room and inpatient visit) when admitting by emergency

# Lookup Tables

## admission_location_to_concept

- made by google

## admission_type_to_concept

- made by google

## admission_type_to_concept

- made by google
