HOW TO BUILD
============

Clone the mimic-omop repository:

```bash
git clone git@github.com:MIT-LCP/mimic-omop.git
cd mimic-omop
```

All the following commands are assumed to be run in the root path of the repository, i.e. the mimic-omop folder you just cloned and changed into.

Copy the OMOP Common Data Model DDL to this folder, e.g.:

```bash
git clone https://github.com/OHDSI/CommonDataModel.git
cp CommonDataModel/PostgreSQL/*.txt omop/build-omop/postgresql/
```

Modify the DDL a bit

```bash
sed -i 's/^CREATE TABLE \([a-z_]*\)/CREATE UNLOGGED TABLE \1/' "omop/build-omop/postgresql/OMOP CDM postgresql ddl.txt"
```

Define the PSQL connection parameters you would like to use.

```bash
export OMOP_SCHEMA='omop'
export OMOP='host=localhost dbname=postgres user=postgres options=--search_path='$OMOP_SCHEMA
# or, e.g., export OMOP='dbname=mimic options=--search_path='$OMOP_SCHEMA
```

Build the schema (NOTE: at the moment uses a fixed schema name of `omop`, edit the script if you need to modify the schema name):

```bash
psql "$OMOP" -c "DROP SCHEMA IF EXISTS $OMOP_SCHEMA CASCADE;"
psql "$OMOP" -c "CREATE SCHEMA $OMOP_SCHEMA;"
psql "$OMOP" -f "omop/build-omop/postgresql/OMOP CDM postgresql ddl.txt"
```

We alter the character columns to `text`, as there is no performance degradation. This also adds ~4 columns to the NLP table:

```bash
psql "$OMOP" -f "omop/build-omop/postgresql/mimic-omop-alter.sql"
```

We add some comments to the data model:

```bash
psql "$OMOP" -f "omop/build-omop/postgresql/omop_cdm_comments.sql"
```

Symlink your vocabulary folder so that the `extras/athena` path symlinks to it, e.g.:

```bash
ln -s /data/vocab/ extras/athena
```

Above my `/data/vocab/` folder contains `CONCEPT_ANCESTOR.csv`, `CONCEPT_CPT4.csv`, `CONCEPT.csv`, etc.

Note: you can download the vocabulary from here: https://www.ohdsi.org/analytic-tools/athena-standardized-vocabularies/
Don't forget to run the java file to import CPT codes into the concept folder after you download the vocabulary.

Import the vocabulary:

```bash
psql "$OMOP" -f "omop/build-omop/postgresql/omop_vocab_load.sql"
```

(Optional) Build indexes and primary key constraints:

```bash
psql "$OMOP" -f "omop/build-omop/postgresql/OMOP CDM postgresql indexes.txt"
```

(Optional) Build foreign key constraints (slows things down usually but can be useful to ensure integrity of data):

```bash
psql "$OMOP" -f "omop/build-omop/postgresql/OMOP CDM postgresql constraints.txt"
```
