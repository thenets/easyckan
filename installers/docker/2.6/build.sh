#!/bin/bash

# Version
CKAN_VERSION="2.6"

# All Docker CKAN images
CKAN_IMAGES=(ckan ckan-cli ckan-dev ckan-postgres ckan-production ckan-solr)
CKAN_IMAGES=(ckan ckan-cli ckan-dev ckan-production) # DEBUG

# Build each image
for i in ${CKAN_IMAGES[@]}; do
    echo "# Building easyckan/"${i}":"$CKAN_VERSION
    echo "# ====================================================="
    docker build -f installers/docker/$CKAN_VERSION/${i}/Dockerfile \
                -t easyckan/${i}:$CKAN_VERSION \
                installers/docker/$CKAN_VERSION/${i}
    echo ""
    echo ""
done