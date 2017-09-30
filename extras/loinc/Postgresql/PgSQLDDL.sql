set search_path to loinc;

DROP  TABLE IF EXISTS source_organization;
CREATE TABLE source_organization (
id integer primary key,
  copyright_id varchar(255) not null,
  name varchar(255) default null,
  copyright text,
  terms_of_use text,
  url varchar(255) default null
) ;

DROP  TABLE IF EXISTS loinc;
CREATE TABLE loinc (
  loinc_num varchar(10) PRIMARY KEY,
  component varchar(255) default null,
  property varchar(30) default null,
  time_aspct varchar(15) default null,
  system varchar(100) default null,
  scale_typ varchar(30) default null,
  method_typ varchar(50) default null,
  class varchar(20) default null,
  VersionLastChanged varchar(10) default null,
  chng_type varchar(3) default null,
  DefinitionDescription text,
  status varchar(11) default null,
  consumer_name varchar(255) default null,
  "classtype" integer default null,
  formula text,
  species varchar(20) default null,
  exmpl_answers text,
  survey_quest_text text,
  survey_quest_src varchar(50) default null,
  unitsrequired varchar(1) default null,
  submitted_units varchar(30) default null,
  relatednames2 text,
  shortname varchar(40) default null,
  order_obs varchar(15) default null,
  cdisc_common_tests varchar(1) default null,
  hl7_field_subfield_id varchar(50) default null,
  external_copyright_notice text,
  example_units varchar(255) default null,
  long_common_name varchar(255) default null,
  UnitsAndRange text,
  document_section varchar(255) default null,
  example_ucum_units varchar(255) default null,
  example_si_ucum_units varchar(255) default null,
  status_reason varchar(9) default null,
  status_text text,
  change_reason_public text,
  common_test_rank integer default null,
  common_order_rank integer default null,
  common_si_test_rank integer default null,
  hl7_attachment_structure varchar(15) default null,
  ExternalCopyrightLink varchar(255) default null,
  PanelType varchar(50) default null,
  AskAtOrderEntry varchar(255) default null,
  AssociatedObservations varchar(255) default null,
  VersionFirstReleased varchar(10) default null,
  ValidHL7AttachmentRequest varchar(50) default null
) ;

DROP TABLE IF EXISTS map_to;
CREATE TABLE map_to (
  loinc varchar(10) NOT NULL,
  map_to varchar(10) NOT NULL,
  comment text,
  primary key (loinc, map_to)

);
