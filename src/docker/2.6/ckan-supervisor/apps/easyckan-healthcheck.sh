#!/bin/bash

PASTER=/usr/lib/ckan/default/bin/paster

# Main loop
while true; do
    
    # Install CKAN if not installed
    if ! [ -f /etc/ckan/default/who.ini ]; then
        curl -sSL https://raw.githubusercontent.com/thenets/EasyCKAN/master/src/docker/2.6/ckan/install.sh | bash
    fi


    sleep 5
done




















