#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR/..

# Version
CKAN_VERSION="2.6"

# All Docker CKAN images
CKAN_IMAGES=(ckan ckan-cli ckan-dev ckan-postgres ckan-production ckan-solr)
CKAN_IMAGES=(ckan ckan-cli ckan-dev ckan-production ckan-datapusher) # DEBUG
CKAN_IMAGES=(ckan-supervisor) # DEBUG

# Build each image
for i in ${CKAN_IMAGES[@]}; do
    echo "# Building easyckan/"${i}":"$CKAN_VERSION
    echo "# ====================================================="
    docker build -f $CKAN_VERSION/${i}/Dockerfile \
                -t easyckan/${i}:$CKAN_VERSION \
                $CKAN_VERSION/${i}
    echo ""
    echo ""
done