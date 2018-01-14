concept:
	Rscript etl/ConceptTables/loadTables.R
load: 
	psql -h  $(HOST_OMOP)  -d mimic postgres  -f etl/etl.sql 
check:
	psql -h  $(HOST_OMOP)  -d mimic postgres  -f etl/check_etl.sql 
export:
	find etl/Result/ -name "*.gz" -delete &&\
	find etl/Result/ -name "*.tar" -delete &&\
	find etl/Result/ -name "*.sql" -delete &&\
	psql -h localhost  -d mimic postgres  -f etl/export_mimic_omop.sql &&\
	cp etl/import_mimic_omop.sql etl/Result/ &&\
	cp omop/build-omop/postgresql/* etl/Result/ &&\
	tar -cf etl/Result/mimic-omop.tar etl/Result/
