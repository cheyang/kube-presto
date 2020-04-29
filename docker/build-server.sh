#!/bin/bash

set -e

BUILD_VER=330
REPO_NAME=uprush

# Build docker image.
docker build --build-arg PRESTO_VERSION=$BUILD_VER \
	-t prestosql-server-$BUILD_VER -f ./Dockerfile-presto-server .

# Push to docker repository.
docker tag prestosql-server-$BUILD_VER $REPO_NAME/prestosql-server:$BUILD_VER
docker push $REPO_NAME/prestosql-server:$BUILD_VER
