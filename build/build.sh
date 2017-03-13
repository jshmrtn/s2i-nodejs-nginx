#!/bin/bash -e
# This script is used to build, test and squash the OpenShift Docker images.
#
# Name of resulting image will be: 'NAMESPACE/BASE_IMAGE_NAME:NODE_VERSION'.
#
# VERSION - Specifies the image version
# VERSIONS - a list of possible versions, can be provided instead of VERSION

VERSION=${2-$VERSION}

DOCKERFILE="Dockerfile"

# Cleanup the temporary Dockerfile created by docker build with version
trap "rm -f ${DOCKERFILE}.${version}" SIGINT SIGQUIT EXIT

# Perform docker build but append the LABEL with GIT commit id at the end
function docker_build_with_version {
  cp ${DOCKERFILE} "${DOCKERFILE}.${version}"
  git_version=$(git rev-parse HEAD)
  sed -i '' -e "s/NODE_VERSION *= *.*/NODE_VERSION=${version} \\\/" "${DOCKERFILE}.${version}"
  echo "LABEL io.origin.builder-version=\"${git_version}\"" >> "${DOCKERFILE}.${version}"
  docker build -t ${IMAGE_NAME}:${version} -f "${DOCKERFILE}.${version}" .
  rm -f "${DOCKERFILE}.${version}"
}

# Specify a VERSION variable to build a specific nodejs.org release
# or specify a list of VERSIONS
versions=${VERSION:-$VERSIONS}

for version in ${versions}; do
  IMAGE_NAME="${NAMESPACE}/${BASE_IMAGE_NAME}"

  echo "-> Building ${IMAGE_NAME}:${version} ..."

  docker_build_with_version Dockerfile

done
