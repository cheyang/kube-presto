#!/bin/bash

set -e

# Each node needs to have different node.id
echo "node.id=$HOSTNAME" >> $PRESTO_HOME/etc/node.properties

# Add addtional S3 setting
cat /tmp/hive.properties >> $PRESTO_HOME/etc/catalog/hive.properties

# Add S3 credential from environment variable
echo "hive.s3.aws-access-key=$AWS_ACCESS_KEY_ID" >> $PRESTO_HOME/etc/catalog/hive.properties
echo "hive.s3.aws-secret-key=$AWS_SECRET_ACCESS_KEY" >> $PRESTO_HOME/etc/catalog/hive.properties

/opt/presto-server/bin/launcher run
