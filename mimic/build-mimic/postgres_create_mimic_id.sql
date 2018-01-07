-- generates a unique mimic_id for all mimic tables


-- select 'ALTER TABLE mimic.'|| table_name ||' add column mimic_id bigint default
-- nextval(''mimic.mimic_id_seq''::regclass);'
-- from (
-- SELECT distinct table_name
-- FROM information_schema.columns
-- WHERE table_name in (
-- select tablename
--  from pg_tables
--  where schemaname like 'mimic' )
--  ORDER BY table_name) as tables;

 ALTER TABLE mimic.admissions drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.callout drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.caregivers drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.chartevents drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.cptevents drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.datetimeevents drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.diagnoses_icd drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.drgcodes drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.icustays drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.inputevents_cv drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.inputevents_mv drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.labevents drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.microbiologyevents drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.noteevents drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.outputevents drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.patients drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.prescriptions drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.procedureevents_mv drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.procedures_icd drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.services drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.transfers drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.d_icd_diagnoses drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.d_icd_procedures drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.d_items drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.d_labitems drop column IF EXISTS mimic_id;
 ALTER TABLE mimic.d_cpt drop column IF EXISTS mimic_id;

DROP SEQUENCE IF EXISTS mimic.mimic_id_seq CASCADE;
CREATE SEQUENCE mimic.mimic_id_seq START WITH 1;

 ALTER TABLE mimic.admissions add column mimic_id integer default         nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.callout add column mimic_id integer default            nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.caregivers add column mimic_id integer default         nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.chartevents add column mimic_id integer default        nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.cptevents add column mimic_id integer default          nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.datetimeevents add column mimic_id integer default     nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.diagnoses_icd add column mimic_id integer default      nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.drgcodes add column mimic_id integer default           nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.icustays add column mimic_id integer default           nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.inputevents_cv add column mimic_id integer default     nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.inputevents_mv add column mimic_id integer default     nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.labevents add column mimic_id integer default          nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.microbiologyevents add column mimic_id integer default nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.noteevents add column mimic_id integer default         nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.outputevents add column mimic_id integer default       nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.patients add column mimic_id integer default           nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.prescriptions add column mimic_id integer default      nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.procedureevents_mv add column mimic_id integer default nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.procedures_icd add column mimic_id integer default     nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.services add column mimic_id integer default           nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.transfers add column mimic_id integer default          nextval('mimic.mimic_id_seq'::regclass);

DROP SEQUENCE IF EXISTS mimic.mimic_id_concept_seq;
CREATE SEQUENCE mimic.mimic_id_concept_seq START WITH 2001000000; -- the CDM allow local concepts above 2B only. First 1milion are manual local codes.

 ALTER TABLE mimic.d_icd_diagnoses add column mimic_id integer default    nextval('mimic.mimic_id_concept_seq'::regclass);
 ALTER TABLE mimic.d_icd_procedures add column mimic_id integer default   nextval('mimic.mimic_id_concept_seq'::regclass);
 ALTER TABLE mimic.d_items add column mimic_id integer default            nextval('mimic.mimic_id_concept_seq'::regclass);
 ALTER TABLE mimic.d_labitems add column mimic_id integer default         nextval('mimic.mimic_id_concept_seq'::regclass);
 ALTER TABLE mimic.d_cpt add column mimic_id integer default              nextval('mimic.mimic_id_concept_seq'::regclass);

