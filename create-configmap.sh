#!/bin/bash

BASE=`dirname $0`
BASE=`cd $BASE; pwd`

NAMESPACE=warehouse

# Create configmap under etc
CMD="kubectl -n $NAMESPACE create configmap presto-etc "
cd $BASE/etc
for PROP in ./*.*
do
	PROP_NAME=`basename $PROP | cut -d'.' -f 1`
	CMD="$CMD --from-file=$PROP "
done
cd $BASE/etc && eval "$CMD"

# Create configmap under etc/catalog
cd $BASE/etc/catalog
CMD="kubectl -n $NAMESPACE create configmap presto-catalog "
for CAT in ./*.*
do
	CAT_NAME=`basename $CAT | cut -d'.' -f 1`
	CMD="$CMD --from-file=$CAT"
done
cd $BASE/etc/catalog && eval "$CMD"

