-- generates a unique mimic_id for all mimic tables


-- select 'ALTER TABLE '|| table_name ||' add column mimic_id bigint default
-- nextval(''mimic_id_seq''::regclass);'
-- from (
-- SELECT distinct table_name
-- FROM information_schema.columns
-- WHERE table_name in (
-- select tablename
--  from pg_tables
--  where schemaname like 'mimic' )
--  ORDER BY table_name) as tables;

 ALTER TABLE admissions drop column IF EXISTS mimic_id;
 ALTER TABLE callout drop column IF EXISTS mimic_id;
 ALTER TABLE caregivers drop column IF EXISTS mimic_id;
 ALTER TABLE chartevents drop column IF EXISTS mimic_id;
 ALTER TABLE cptevents drop column IF EXISTS mimic_id;
 ALTER TABLE datetimeevents drop column IF EXISTS mimic_id;
 ALTER TABLE diagnoses_icd drop column IF EXISTS mimic_id;
 ALTER TABLE drgcodes drop column IF EXISTS mimic_id;
 ALTER TABLE icustays drop column IF EXISTS mimic_id;
 ALTER TABLE inputevents_cv drop column IF EXISTS mimic_id;
 ALTER TABLE inputevents_mv drop column IF EXISTS mimic_id;
 ALTER TABLE labevents drop column IF EXISTS mimic_id;
 ALTER TABLE microbiologyevents drop column IF EXISTS mimic_id;
 ALTER TABLE noteevents drop column IF EXISTS mimic_id;
 ALTER TABLE outputevents drop column IF EXISTS mimic_id;
 ALTER TABLE patients drop column IF EXISTS mimic_id;
 ALTER TABLE prescriptions drop column IF EXISTS mimic_id;
 ALTER TABLE procedureevents_mv drop column IF EXISTS mimic_id;
 ALTER TABLE procedures_icd drop column IF EXISTS mimic_id;
 ALTER TABLE services drop column IF EXISTS mimic_id;
 ALTER TABLE transfers drop column IF EXISTS mimic_id;
 ALTER TABLE d_icd_diagnoses drop column IF EXISTS mimic_id;
 ALTER TABLE d_icd_procedures drop column IF EXISTS mimic_id;
 ALTER TABLE d_items drop column IF EXISTS mimic_id;
 ALTER TABLE d_labitems drop column IF EXISTS mimic_id;
 ALTER TABLE d_cpt drop column IF EXISTS mimic_id;

DROP SEQUENCE IF EXISTS mimic_id_seq CASCADE;
CREATE SEQUENCE mimic_id_seq START WITH 1;

 ALTER TABLE admissions add column mimic_id integer default         nextval('mimic_id_seq'::regclass);
 ALTER TABLE callout add column mimic_id integer default            nextval('mimic_id_seq'::regclass);
 ALTER TABLE caregivers add column mimic_id integer default         nextval('mimic_id_seq'::regclass);
 ALTER TABLE chartevents add column mimic_id integer default        nextval('mimic_id_seq'::regclass);
 ALTER TABLE cptevents add column mimic_id integer default          nextval('mimic_id_seq'::regclass);
 ALTER TABLE datetimeevents add column mimic_id integer default     nextval('mimic_id_seq'::regclass);
 ALTER TABLE diagnoses_icd add column mimic_id integer default      nextval('mimic_id_seq'::regclass);
 ALTER TABLE drgcodes add column mimic_id integer default           nextval('mimic_id_seq'::regclass);
 ALTER TABLE icustays add column mimic_id integer default           nextval('mimic_id_seq'::regclass);
 ALTER TABLE inputevents_cv add column mimic_id integer default     nextval('mimic_id_seq'::regclass);
 ALTER TABLE inputevents_mv add column mimic_id integer default     nextval('mimic_id_seq'::regclass);
 ALTER TABLE labevents add column mimic_id integer default          nextval('mimic_id_seq'::regclass);
 ALTER TABLE microbiologyevents add column mimic_id integer default nextval('mimic_id_seq'::regclass);
 ALTER TABLE noteevents add column mimic_id integer default         nextval('mimic_id_seq'::regclass);
 ALTER TABLE outputevents add column mimic_id integer default       nextval('mimic_id_seq'::regclass);
 ALTER TABLE patients add column mimic_id integer default           nextval('mimic_id_seq'::regclass);
 ALTER TABLE prescriptions add column mimic_id integer default      nextval('mimic_id_seq'::regclass);
 ALTER TABLE procedureevents_mv add column mimic_id integer default nextval('mimic_id_seq'::regclass);
 ALTER TABLE procedures_icd add column mimic_id integer default     nextval('mimic_id_seq'::regclass);
 ALTER TABLE services add column mimic_id integer default           nextval('mimic_id_seq'::regclass);
 ALTER TABLE transfers add column mimic_id integer default          nextval('mimic_id_seq'::regclass);

DROP SEQUENCE IF EXISTS mimic_id_concept_seq CASCADE;
CREATE SEQUENCE mimic_id_concept_seq START WITH 2001000000; -- the CDM allow local concepts above 2B only. First 1milion are manual local codes.

 ALTER TABLE d_icd_diagnoses add column mimic_id integer default    nextval('mimic_id_concept_seq'::regclass);
 ALTER TABLE d_icd_procedures add column mimic_id integer default   nextval('mimic_id_concept_seq'::regclass);
 ALTER TABLE d_items add column mimic_id integer default            nextval('mimic_id_concept_seq'::regclass);
 ALTER TABLE d_labitems add column mimic_id integer default         nextval('mimic_id_concept_seq'::regclass);
 ALTER TABLE d_cpt add column mimic_id integer default              nextval('mimic_id_concept_seq'::regclass);

