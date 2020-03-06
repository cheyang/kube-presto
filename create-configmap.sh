#!/bin/bash

BASE=`dirname $0`
BASE=`cd $BASE/./; pwd`

NAMESPACE=warehouse

# Create configmap under etc
cd $BASE/etc
CMD="kubectl -n $NAMESPACE create configmap presto-etc "
for PROP in ./*.*
do
	PROP_NAME=`basename $PROP | cut -d'.' -f 1`
	CMD="$CMD --from-file=PROP "
done
"$CMD"

# Create configmap under etc/catalog
cd $BASE/etc/catalog
CMD="kubectl -n $NAMESPACE create configmap presto-catalog "
for CAT in ./*.*
do
	CAT_NAME=`basename $CAT | cut -d'.' -f 1`
	CMD="$CMD --from-file=$CAT"
done
"$CMD"
