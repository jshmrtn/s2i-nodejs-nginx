#!/bin/bash -e

LAST_RELEASE="$(grep 'NODE_VERSION=' Dockerfile | sed -e "s/ *NODE_VERSION=\([^ ]*\) \\\/\1/")"
LAST_RELEASES="$VERSIONS"
LATEST_RELEASE="$(./build/latest.js | cut -f5 -d' ')"
LATEST_RELEASES="$(node ./build/latest.js)"
NUMS="$(seq 1 `echo $LAST_RELEASES | wc -w`)"

# Files with hard-coded version strings:
LAST_UPDATES_NEEDED="imagestream.json \
  README.md"

if [ "${LAST_RELEASES}" != "${LATEST_RELEASES}" ] ; then
  echo "New NodeJS releases available!: ${LATEST_RELEASES}"
  sed -i '' -e "s/VERSIONS.*/VERSIONS = $LATEST_RELEASES/" Makefile

  for release in $NUMS ; do
    last="$( echo ${LAST_RELEASES} | cut -d' ' -f$release )"
    latest="$( echo ${LATEST_RELEASES} | cut -d' ' -f$release )"
    if [ "$last" != "$latest" ] ; then
      echo "Updating v$last to v$latest"
      for file in $LAST_UPDATES_NEEDED ; do
        sed -i '' -e "s/${last}/${latest}/g" $file
      done
    fi
  done

  docker pull centos/nginx-18-centos7

else
  echo "No new NodeJS releases found"
fi