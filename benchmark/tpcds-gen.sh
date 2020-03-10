#!/bin/bash
SCALE=1000
FORMAT=orc
SCHEMA=tpcds_sf${SCALE}_${FORMAT}

sql_exec() {
    kubectl exec -it pod/presto-cli /opt/presto-cli -- --server presto.warehouse:8080 --catalog hive --execute "$1"
}

echo "`date`: Drop existing schema: $SCHEMA"
declare TABLES="$(sql_exec "SHOW TABLES FROM tpcds.sf1000;" | sed s/\"//g)"
# clean up from any previous runs.
for tab in $TABLES; do
    echo $tab
    sql_exec "DROP TABLE IF EXISTS $SCHEMA.$tab;"
done
sql_exec "DROP SCHEMA IF EXISTS $SCHEMA;"

# Create schema 
LOCATION="s3a://deephub/warehouse/$SCHEMA.db/"
echo "`date`: Create schema under location: $LOCATION"
sql_exec "CREATE SCHEMA $SCHEMA WITH (location = '$LOCATION');"

# Create tables, generate data
echo "`date`: Generating data..."

START=`date +%s`
for tab in $TABLES; do
    sql_exec "CREATE TABLE $SCHEMA.$tab WITH (format = 'orc') AS SELECT * FROM tpcds.sf$SCALE.$tab;"
done

END=`date +%s`
RUNTIME=$((END-START))
echo "`date`: Finished data generation. Time taken: $RUNTIME s"

