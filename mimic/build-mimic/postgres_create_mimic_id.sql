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

--CREATE SEQUENCE mimic.mimic_id_seq START WITH 10000000000;

 ALTER TABLE mimic.admissions add column mimic_id bigint default        
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.callout add column mimic_id bigint default           
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.caregivers add column mimic_id bigint default        
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.chartevents add column mimic_id bigint default       
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.cptevents add column mimic_id bigint default         
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.datetimeevents add column mimic_id bigint default    
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.d_cpt add column mimic_id bigint default             
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.diagnoses_icd add column mimic_id bigint default     
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.d_icd_diagnoses add column mimic_id bigint default   
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.d_icd_procedures add column mimic_id bigint default  
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.d_items add column mimic_id bigint default           
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.d_labitems add column mimic_id bigint default        
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.drgcodes add column mimic_id bigint default          
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.icustays add column mimic_id bigint default          
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.inputevents_cv add column mimic_id bigint default    
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.inputevents_mv add column mimic_id bigint default    
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.labevents add column mimic_id bigint default         
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.microbiologyevents add column mimic_id bigint default
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.noteevents add column mimic_id bigint default        
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.outputevents add column mimic_id bigint default      
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.patients add column mimic_id bigint default          
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.prescriptions add column mimic_id bigint default     
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.procedureevents_mv add column mimic_id bigint default
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.procedures_icd add column mimic_id bigint default    
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.services add column mimic_id bigint default          
 nextval('mimic.mimic_id_seq'::regclass);
 ALTER TABLE mimic.transfers add column mimic_id bigint default         
 nextval('mimic.mimic_id_seq'::regclass);
