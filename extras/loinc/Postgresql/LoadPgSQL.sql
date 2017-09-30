set search_path to loinc;
\copy loinc FROM 'loinc.csv' CSV HEADER quote '"';
\copy map_to FROM 'map_to.csv' CSV HEADER quote '"';
\copy source_organization FROM 'source_organization.csv' CSV HEADER quote '"';
