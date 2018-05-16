MIMIC_SCHEMA=mimiciii
OMOP_SCHEMA=omop
MIMIC="host=localhost dbname=mimic user=postgres options=--search_path=$(MIMIC_SCHEMA)"
OMOP="host=localhost dbname=mimic user=postgres options=--search_path=$(OMOP_SCHEMA)"

runetl: sequence concept load
runetlprivate: runetl private

buildomop:
	psql $(OMOP) -f omop/build-omop/postgresql/omop_ddl_comments.sql &&\
	psql $(OMOP) -f omop/build-omop/postgresql/mimic-omop-add-column.sql &&\
	psql $(OMOP) -f omop/build-omop/postgresql/mimic-omop-alter.sql

loadvocab:
	psql $(OMOP)  -f omop/build-omop/postgresql/omop_vocab_load.sql

concept:
	Rscript --vanilla etl/ConceptTables/loadTables.R $(MIMIC_SCHEMA)

sequence: 
	psql $(MIMIC)  -f mimic/build-mimic/postgres_create_mimic_id.sql

load: 
	psql $(MIMIC)  -f etl/etl.sql 

private: 
	psql  $(MIMIC) -f etl/etl_contrib.sql 

check:
	psql $(MIMIC) -f etl/check_etl.sql 

export:
	psql $(MIMIC)  -f export/export_mimic_omop.sql &&\
	cp import/import_mimic_omop.sql etl/Result/ &&\
	cp omop/build-omop/postgresql/* etl/Result/
#	tar -cf $(MIMIC_SCHEMA)-omop.tar etl/Result/

exportmonet:
	psql $(MIMIC)  -f export/export_mimic_omop_monetdb.sql &&\
	cp import/import_mimic_omop_monetdb.sh etl/Result/ &&\
	cp omop/build-omop/monetdb/ddl_monetdb.sql etl/Result/
#	tar -cf $(MIMIC_SCHEMA)-omop.tar etl/Result/
	
exportmonetdenorm:
	psql $(MIMIC)  -f export/export_mimic_omop_monetdb_denorm.sql &&\
	cp import/import_mimic_omop_monetdb.sh etl/Result/ &&\
	cp omop/build-omop/monetdb/ddl_monetdb_denorm.sql etl/Result/

purgeresult:
	find etl/Result/ -name "*.gz" -delete &&\
	find etl/Result/ -name "*.tar" -delete &&\
	find etl/Result/ -name "*.sql" -delete 
