#!/usr/bin/env bash
set -e # Exit immediately if a command exits with a non-zero status.

cd /opt/mimic-omop/
echo -e "dbname=mimic\nuser=postgres\nhost=db\nport=5432\npassword=$PGPASSWORD" > /opt/mimic-omop/mimic-omop.cfg
make build runetl exporter check 
