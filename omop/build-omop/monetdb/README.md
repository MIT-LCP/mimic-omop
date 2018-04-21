Intallation
-----------

- add listenadrr=0.0.0.0 to .merovingian_properties in order to open the database to remote access


Client
------

- pymonetdb is fine and works with pandas.read_sql

Data loading
------------

- use the make exportmonetdb 


Security aspects
----------------

- admin security : ̀`ALTER USER SET UNENCRYPTED PASSWORD '<your admin password>' USING OLD PASSWORD  'monetdb';`
- give bob access to omop: 
    ```
    CREATE ROLE omop_access;
    CREATE SCHEMA omop AUTHORIZATION "omop_access";
    CREATE USER bob WITH PASSWORD '<bob password>' NAME 'Bob User' SCHEMA omop;
    GRANT omop_access to bob;
    ```

Access from pandas and pymonetdb
--------------------------------


```
import pymonetdb
import pandas as pd
#connection
connection = pymonetdb.connect(username="bob", password="<bob password>", hostname="<dbhost>",  database="<dbname>", port="50000")
connection.execute("set schema omop;set role omop_access;")
connection.execute("create table test as select * from person limit 10")
pd.read_sql("select count(1) from test",connection)
   L3
0  10
connection.execute("drop table test")
```

