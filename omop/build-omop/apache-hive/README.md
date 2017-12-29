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


TABLE COMMENT
============

- `ALTER TABLE table_name SET TBLPROPERTIES ('comment' = new_comment);`
- `// Add a comment to column a1 -- ALTER TABLE test_change CHANGE a1 a1 INT COMMENT 'this is column a1';`
