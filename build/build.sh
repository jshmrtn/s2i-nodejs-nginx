#!/bin/bash -e
# This script is used to build, test and squash the OpenShift Docker images.
#
# Name of resulting image will be: 'NAMESPACE/BASE_IMAGE_NAME:NODE_VERSION'.
#
# VERSION - Specifies the image version
# VERSIONS - a list of possible versions, can be provided instead of VERSION

VERSION=${2-$VERSION}

# Specify a VERSION variable to build a specific nodejs.org release
# or specify a list of VERSIONS
versions=${VERSION:-$VERSIONS}

for version in ${versions}; do
  IMAGE_NAME="${NAMESPACE}/${BASE_IMAGE_NAME}"

  echo "-> Building ${IMAGE_NAME}:${version} ..."

  docker build \
    -t "${IMAGE_NAME}:${version}" \
    --build-arg NODE_VERSION=${version} \
    --build-arg GIT_VERSION="$(git rev-parse HEAD)" \
    .

done
