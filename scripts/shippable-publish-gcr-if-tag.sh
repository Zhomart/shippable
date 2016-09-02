#!/bin/bash

##
## MIT License
##

set -e

echo "Publishes to PUBLISH_REPO=$PUBLISH_REPO if BRANCH looks like a version"
echo
echo "IS_GIT_TAG=$IS_GIT_TAG"
echo "GIT_TAG_NAME=$GIT_TAG_NAME"
echo "IS_RELEASE=$IS_RELEASE"
echo "BRANCH=$BRANCH"
echo "PUBLISH_REPO=$PUBLISH_REPO"

if [ -z "$PUBLISH_REPO" ]; then
  echo "Please specify variable PUBLISH_REPO"
  exit 1
fi

# if ($IS_GIT_TAG); then
# regexp matches `13.2`, `1.22.52`, `1.22.5.pre01`
if [[ "$BRANCH" =~ [^\d+(\.\d+)+(\..+)?$] ]] ; then
  IMAGE_VERSION=$BRANCH
  echo "Building and publishing docker image version :latest and :$IMAGE_VERSION"
  echo
  docker build -t $PUBLISH_REPO:latest .
  docker tag -f $PUBLISH_REPO:latest $PUBLISH_REPO:$IMAGE_VERSION
  docker push $PUBLISH_REPO:$IMAGE_VERSION
  docker push $PUBLISH_REPO:latest
else
  echo "Skipping, because BRANCH doesn't look like a version"
  echo
fi