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
    echo "nothing"
fi



# EVENT run
# Commands on CKAN startup
# =====================================
if [[ $1 == "run" ]]
then

    # Database container
    # ===============================
    v_docker_datapusher_db_name="ckan-datapusher-db"							# Container name
    v_docker_datapusher_db_path="/var/easyckan/datapusher"						# Host persistent data path
    v_docker_datapusher_db_v="$v_docker_datapusher_db_path:/var/lib/postgresql/data"	# Volume path

    if [[ $(docker container ls | grep -i $v_docker_datapusher_db_name) ]]; then
        echo "ckan-postgres was found..."
    else
        # Remove old container if exists
        docker rm -f $v_docker_datapusher_db_name 2> /dev/null

        # Create persistent data dir
        mkdir -p $v_docker_datapusher_db_path

        # Create container as daemon
        docker run --net=easyckan --name $v_docker_datapusher_db_name -v $v_docker_datapusher_db_v \
                    -e POSTGRES_DB="ckan_datapusher" -e POSTGRES_PASSWORD=$v_password \
                    -d easyckan/ckan-postgres:$V_CKAN_BASE_VERSION
        
        # Wait application start
        sleep 2
    fi


    # Main datapusher container
    # ===============================
    v_docker_datapusher="ckan-datapusher" # Container name
    if [[ $(docker container ls | grep -i $v_docker_datapusher) ]]; then
        echo "ckan-datapusher was found..."
    else
        docker rm -f $v_docker_datapusher 2> /dev/null
        
        docker run --net=easyckan --name $v_docker_datapusher \
                    -p 8800:8800 -d easyckan/ckan-datapusher:$V_CKAN_BASE_VERSION
    fi

fi