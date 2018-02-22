MIMIC_SCHEMA=mimic
HOST_OMOP=localhost
concept:
	Rscript --vanilla etl/ConceptTables/loadTables.R $(MIMIC_SCHEMA)
sequence: 
	psql --set=mimicschema="$(MIMIC_SCHEMA)" -h  $(HOST_OMOP)  -d mimic postgres  -f etl/etl_sequence.sql 
load: 
	psql --set=mimicschema="$(MIMIC_SCHEMA)" -h  $(HOST_OMOP)  -d mimic postgres  -f etl/etl.sql 
contrib: 
	psql --set=mimicschema="$(MIMIC_SCHEMA)" -h  $(HOST_OMOP)  -d mimic postgres  -f etl/etl_contrib.sql 
check:
	psql --set=mimicschema="$(MIMIC_SCHEMA)" -h  $(HOST_OMOP)  -d mimic postgres  -f etl/check_etl.sql 
export:
	find etl/Result/ -name "*.gz" -delete &&\
	find etl/Result/ -name "*.tar" -delete &&\
	find etl/Result/ -name "*.sql" -delete &&\
	psql -h $(HOST_OMOP) -d mimic postgres  -f etl/export_mimic_omop.sql &&\
	cp etl/import_mimic_omop.sql etl/Result/ &&\
	cp omop/build-omop/postgresql/* etl/Result/
#	tar -cf $(MIMIC_SCHEMA)-omop.tar etl/Result/
runetl: sequence concept load export 
runetlwithcontrib: sequence concept load contrib export 
runetllight: concept load 
