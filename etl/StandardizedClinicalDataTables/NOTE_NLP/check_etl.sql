
-- -----------------------------------------------------------------------------
-- File created - January-13-2018
-- ----------------------------------------------------------------------------

-- --------------------------------------------------
-- Need to install pgTAP
-- http://pgtap.org/
-- --------------------------------------------------

BEGIN;
SELECT plan ( 3 );

SELECT results_eq
(
'
select 0::integer;
'
,
'
select count(1)::integer from (
SELECT count(1)::integer
FROM omop.note_nlp
group by note_nlp_id
having count(1) > 1) as t;
'
,
'primary key checker'
);

SELECT results_eq
(
'
select 0::integer;
'
,
'
SELECT count(1)::integer
FROM omop.note_nlp
where section_source_concept_id = 0;
'
,
'source concept described'
);

SELECT results_eq
(
'
select 0::integer;
'
,
'
SELECT count(1)::integer
FROM omop.note_nlp
where section_concept_id = 0;
'
,
'source concept described'
);
SELECT pass( 'Note Nlp pass, w00t!' );

SELECT * FROM finish();
ROLLBACK;
