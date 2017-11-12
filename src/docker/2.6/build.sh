#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/..

# Version
CKAN_VERSION="2.6"

# Image name
IMAGE_NAME=$1

# Build image
echo "# Building easyckan/"${IMAGE_NAME}":"$CKAN_VERSION
echo "# ====================================================="
docker build -f $CKAN_VERSION/${IMAGE_NAME}/Dockerfile \
            -t easyckan/${IMAGE_NAME}:$CKAN_VERSION \
            $CKAN_VERSION/${IMAGE_NAME}
echo ""
echo ""