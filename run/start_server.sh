#!/bin/bash

sudo su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster serve /etc/ckan/default/development.ini"
