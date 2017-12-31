# Source Tables

## admissions

- admissions deathtime is considered as the reference (compared to patients table)
- for 11 admissions, the deathtime is after the dischtime. However, for those 11 patients the `patients.dod_hosp` is equal to the dischtime. Then the later is used in this particular case
- they are patients dead during hospitalisation with concept equal to 38003569

## patients

- patients `dod_hosp` has been described has odd behavior (https://github.com/MIT-LCP/mimic-code/issues/190)
- only `dod_ssn` is taken in consideration and the omop concept is equal to 261

# Lookup Tables
