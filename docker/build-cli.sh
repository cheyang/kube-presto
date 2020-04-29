#!/bin/bash

set -e

BUILD_VER=330
REPO_NAME=uprush

# Build docker image.
docker build --build-arg PRESTO_VERSION=$BUILD_VER \
	-t prestosql-cli-$BUILD_VER -f ./Dockerfile-presto-cli .

# Push to docker repository.
docker tag prestosql-cli-$BUILD_VER $REPO_NAME/prestosql-cli:$BUILD_VER
docker push $REPO_NAME/prestosql-cli:$BUILD_VER
