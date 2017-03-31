#!/bin/bash

# Create theme
sudo su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src && paster --plugin=ckan create -t ckanext ckanext-$1"

# Remove old link, if exists
sudo rm -f /usr/lib/ckan/default/lib/python2.7/site-packages/ckanext-$1.egg-link

# Build new theme
sudo su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckanext-$1 && python setup.py develop"
