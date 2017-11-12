#!/bin/bash
sudo su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster --plugin=ckanext-harvest harvester $1 $2 $3 $4 $5 $6 $7 -c /etc/ckan/default/development.ini"
