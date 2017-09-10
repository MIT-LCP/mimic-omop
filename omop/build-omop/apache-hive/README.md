HOW TO CREATE THE DDL
=====================

- convert the postgresql scripts to apache-hive semantic


HOW TO LOAD
===========

- Problem: hdfs splits the csv. Then if the csv contains multilines contents, it is corrupted
- Workaround: Use pg
	1. load csv into postgres
	2. create avro files with apache-sqoop
	3. load avro into hive tables
