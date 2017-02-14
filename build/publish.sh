#!/bin/bash -e

BASE_IMAGES="${NAMESPACE}/${BASE_IMAGE_NAME}"

if [ ! -z $DOCKER_USER ] && [ ! -z $DOCKER_PASS ]; then
  echo "---> Authenticating to DockerHub..."
  docker login --username $DOCKER_USER --password $DOCKER_PASS
fi

for BASE in $BASE_IMAGES ; do
  echo "publishing: ${BASE}..."
  docker push $BASE
done