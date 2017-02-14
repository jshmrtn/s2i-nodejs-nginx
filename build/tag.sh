#!/bin/bash -e

BASE_IMAGES="${NAMESPACE}/${BASE_IMAGE_NAME}"

for BASE in $BASE_IMAGES ; do
  if [ $(echo "${VERSIONS}" | wc -w) -gt 0 ] ; then
    for RELEASE in $VERSIONS ; do
      img=$(docker images | grep $BASE | grep $RELEASE | head -n 1 | tr -s ' ' | cut -f3 -d' ')
      if [[ $RELEASE == 4.* ]] ; then
        echo "tagging ${BASE}:${RELEASE} for release as: ${BASE}:4"
        docker image tag $img $BASE:4
      elif [[ $RELEASE == 5.* ]] ; then
        echo "tagging ${BASE}:${RELEASE} for release as: ${BASE}:5"
        docker image tag $img $BASE:5
      elif [[ $RELEASE == 6.* ]] ; then
        echo "tagging ${BASE}:${RELEASE} for release as: ${BASE}:6"
        docker image tag $img $BASE:6
        echo "tagging ${BASE}:${RELEASE} for release as: ${BASE}:lts"
        docker image tag $img $BASE:lts
      elif [[ $RELEASE == 7.* ]] ; then
        echo "tagging ${BASE}:${RELEASE} for release as: ${BASE}:7"
        docker image tag $img $BASE:7
        echo "tagging ${BASE}:${RELEASE} for release as: ${BASE}:latest"
        docker image tag $img $BASE:latest
      fi
    done
  fi
done