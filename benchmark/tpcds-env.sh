#!/bin/bash

SCALE=1000
FORMAT=orc
SCHEMA=hs_tpcds_sf${SCALE}_${FORMAT}
LOCATION=s3a://bigdatabucket/warehouse/tpcds_sf${SCALE}_${FORMAT}.db
