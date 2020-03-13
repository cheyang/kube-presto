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
declare TABLES="$(sql_exec "SHOW TABLES FROM tpcds.sf1000;" | sed s/\"//g | tr -d '\r')"

echo "Generate table DDL"
for TABLE in $TABLES; do
    echo $TABLE
    sql_exec "SHOW CREATE TABLE tpcds.sf1000.$TABLE;" | sed s/\"//g | sed s/tpcds/hive/g | sed s/sf1000/$SCHEMA/g > tpcds-ddl/$TABLE.sql
    echo "WITH (format = 'ORC', external_location = '$LOCATION/$TABLE')" >> tpcds-ddl/$TABLE.sql
done

# Create schema 
echo "Generate schema DDL"
echo "CREATE SCHEMA $SCHEMA WITH (location = '$LOCATION');" > tpcds-ddl/create-schemal.sql
