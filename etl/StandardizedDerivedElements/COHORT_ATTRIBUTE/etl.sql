-- CF other etl:
-- visit_detail

-- Load the cohort attribute extracted by Alistair on sunday morning
\copy omop.cohort_attribute FROM PROGRAM 'gzip -dc ~/git/mimic-omop/extra/private/cohort_attribute.csv.gz' CSV HEADER NULL '' QUOTE '"';
