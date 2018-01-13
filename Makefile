export:
	find etl/Result/ -name "*.gz" -delete &&\
	find etl/Result/ -name "*.tar" -delete &&\
	find etl/Result/ -name "*.sql" -delete &&\
	psql -h localhost  -d mimic postgres  -f etl/export_mimic_omop.sql &&\
	cp etl/import_mimic_omop.sql etl/Result/ &&\
	cp omop/build-omop/postgresql/* etl/Result/ &&\
	tar -cf etl/Result/mimic-omop.tar etl/Result/
etl:
	psql -h localhost  -d mimic postgres  -f etl/.sql
