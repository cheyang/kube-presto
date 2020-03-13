#!/bin/bash

SCALE=1000
FORMAT=orc
SCHEMA=tpcds_sf${SCALE}_${FORMAT}
LOCATION=s3://deephub/mydir/$SCHEMA.db
