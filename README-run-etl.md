# Running the ETL on PostgreSQL

This README overviews running the MIMIC-OMOP ETL from the ground up on a PostgreSQL server. You will need an installation of PostgreSQL 9.6+ in order to run the ETL. You will also need MIMIC-III installed on this instance of postgres, see here for details: https://mimic.physionet.org/gettingstarted/dbsetup/

This README will assume the following:

* MIMIC-III v1.4 is available in the `mimic` database under the `mimiciii` schema
* The standard concepts from Athena have been downloaded and are available somewhere (including running the extra script to download CPT code definitions)
* The R software library with remotes (`install.packages("remotes")`) and a GitHub package `remotes::install_github("r-dbi/RPostgres")`
* The computer has an active internet connection (needed to clone certain repositories throughout the build)

## 0. Open up a terminal and define parameters

To simplify the reusability of these scripts, we define a few environment variables and reuse them throughout the rest of the guide.

First is the connection string used to connect to the database. Note this also specifies the schema using `search_path`.

```bash
export OMOP='host=localhost dbname=postgres user=postgres options=--search_path=omop'
export MIMIC='host=localhost dbname=postgres user=postgres options=--search_path=mimiciii'
# or, e.g., export OMOP="dbname=mimic options=--search_path=omop"
```

We will later use these environmental variables to connect to postgres.

**NOTE**: While ideally specifying the schemas would be completely configurable, much of the repository assumes the `omop` schema. The `mimiciii` schema should be configurable, but this is experimental.

## 1. Build OMOP tables with standard concepts

See [the omop/build-omop/postgresql/README.md file](omop/build-omop/postgresql/README.md) to build OMOP on postgres.

## 2. Create local MIMIC-III concepts

We need to create a `concept_id` for each MIMIC-III local code. OMOP reserves `concept_id` above 20,000,000+ for local codes, so we will use this range to insert ours.

```sh
psql "$MIMIC" -f mimic/build-mimic/postgres_create_mimic_id.sql
```

N.B. this script is called by `etl_sequence.sql`

After this, every table in the MIMIC-III schema will have an additional column called `mimic_id`.

## 3. Load the concepts from the CSV files

First prepare a configuration file for the R script and save it as `mimic-omop.cfg` in the root folder of this repository. Here is an example of the file structure:

```sh
dbname=mimic
user=alistairewj
```

After that, run the R script from the root folder:

```
Rscript etl/ConceptTables/loadTables.R mimiciii
```

This will load various manual mappings to the database under the `mimiciii` schema.

## 4. Run the ETL

Be sure to run this from the *root* folder of the repository, or the relative path names will cause errors.

```sh
psql "$MIMIC" -f "etl/etl.sql"
```

## 5. Check the ETL has run properly

In order to run the checks, you'll need [pgTap](http://pgtap.org/). pgTap is a testing framework for postgres.
You can install pgtap by either:

* using a package manager, e.g. on Ubuntu using: `sudo apt-get install pgtap`.
* from source, following the [install instructions here](https://pgxn.org/dist/pgtap/)

If building from source, pay careful attention to the make output. You may need to install additional perl modules in order to use functions such as pg_prove, using `cpan TAP::Parser::SourceHandler::pgTAP`.
You may also need to run the installation `make` files as the postgres user, who has superuser privileges to the postgres database.

After you install it, be sure to enable the extension as follows:

```sh
psql "$MIMIC" -c "CREATE EXTENSION pgtap;"
```

Now the extension is available database-wide, and we can run the ETL.

```sh
psql "$MIMIC" -f "etl/check_etl.sql"
```
