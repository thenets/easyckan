#!/bin/bash

# Waiting Solr and PostgreSQL start
sleep 3

# Enable Virtual Enritonment
# And start server over port 5000
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && \
cd /usr/lib/ckan/default/src/ckan && \
paster serve --reload /etc/ckan/default/development.ini"
