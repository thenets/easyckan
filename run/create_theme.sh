#!/bin/bash

sudo su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src && paster --plugin=ckan create -t ckanext ckanext-$1"
