#!/bin/bash

PASTER=/usr/lib/ckan/default/bin/paster

# Check if CKAN is installed and wait if it's not
while true; do
    
    if [ -f /etc/ckan/default/who.ini ]; then
        break
    fi

    sleep 5
done

# Start Apache HTTP Server
apachectl -DFOREGROUND