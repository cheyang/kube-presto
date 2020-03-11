#!/bin/bash

JMETER_HOME=/opt/apache-jmeter-5.2.1
PRESTO_VER=330
JAVA_HOME=/usr/jdk64/jdk-11.0.6

# Download jdbc driver
if [ ! -f $JMETER_HOME/lib/presto-jdbc-$PRESTO_VER.jar ]; then
	curl -o $JMETER_HOME/lib/presto-jdbc-$PRESTO_VER.jar https://repo1.maven.org/maven2/io/prestosql/presto-jdbc/$PRESTO_VER/presto-jdbc-$PRESTO_VER.jar
fi

# Run jmeter CLI
REPORT_DIR="reports/`date +%s`"
mkdir -p $REPORT_DIR
mkdir -p logs

JAVA_HOME=$JAVA_HOME $JMETER_HOME/bin/jmeter \
	-n -t jmeter-tpcds.jmx \
	-l logs/tpcds-log.jtl \
	-e -o $REPORT_DIR
