HOW TO UPDATE
=============

- sync from the CommonDataModel PostgreSQL folder

```bash
rsync -avh /home/nps/git/CommonDataModel/PostgreSQL/*.sql .
```

HOW TO BUILD
============

```bash
psql -h localhost postgres postgres -f build-omop.sql
```

