#!/bin/bash
#
# Create TPC-DS schema and tables in Presto.
#

source ./tpcds-env.sh

sql_exec() {
    kubectl exec -it pod/presto-cli /opt/presto-cli -- --server presto.warehouse:8080 --catalog hive --execute "$1"
}

declare TABLES="$(sql_exec "SHOW TABLES FROM tpcds.sf1000;" | sed s/\"//g | tr -d '\r')"
# clean up from any previous runs.
for tab in $TABLES; do
    echo "Analyze $SCHEMA.$tab"
    sql_exec "ANALYZE $SCHEMA.$tab;"
done
