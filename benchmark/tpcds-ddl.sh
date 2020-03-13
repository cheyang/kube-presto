#!/bin/bash
#
# Generate TPCDS table DDL, point to external location.
#

SCALE=1000
FORMAT=orc
SCHEMA=tpcds_sf${SCALE}_${FORMAT}
LOCATION=s3://deephub/mydir/$SCHEMA.db

sql_exec() {
    kubectl exec -it pod/presto-cli /opt/presto-cli -- --server presto.warehouse:8080 --catalog hive --execute "$1"
}

# clean up from any previous runs.
rm -rf tpcds-ddl
mkdir tpcds-ddl

# Retrieve table schema
echo "Retrieve existing schema"
declare TABLES="$(sql_exec "SHOW TABLES FROM tpcds.sf1000;" | sed s/\"//g)"

echo "Generate table DDL"
for TAB in $TABLES; do
    echo $TAB
    sql_exec "SHOW CREATE TABLE tpcds.sf1000.$TAB;" > tpcds-ddl/$TAB.sql
    echo "WITH (format = 'ORC', external_location = '$LOCATION/$TAB')" >> tpcds-ddl/$TAB.sql
done

# Create schema 
echo "Generate schema DDL"
echo "CREATE SCHEMA $SCHEMA WITH (location = '$LOCATION');" > tpcds-ddl/create-schemal.sql
