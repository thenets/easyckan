#!/bin/bash

# Import env
SCRIPT_HOME="/etc/easyckan/bin"
source $SCRIPT_HOME/_tools

# Create database for datastore_default
# ========================================================
# easyckan exec psql -h ckan-postgres -Upostgres
# CREATE USER datastore_default WITH PASSWORD 'pass';
# CREATE DATABASE datastore_default;
# GRANT ALL ON DATABASE datastore_default TO datastore_default;



# EVENT install
# Commands on plugin installation process
# =====================================
if [[ $1 == "install" ]]
then

fi



# EVENT run
# Commands on CKAN startup
# =====================================
if [[ $1 == "run" ]]
then
    # Set variables
    v_docker_datapusher="ckan-datapusher"									# Container name

    if [[ $(docker container ls | grep -i $v_docker_datapusher) ]]; then
        echo "ckan-datapusher was found..."
    else
        # Remove old container if exists
        docker rm -f $v_docker_datapusher 2> /dev/null

        # Create container as daemon
        docker run --net=easyckan --name $v_docker_datapusher \
                    -p 8800:8800 -d easyckan/ckan-datapusher:$V_CKAN_BASE_VERSION
    fi
fi
