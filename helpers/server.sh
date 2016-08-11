#!/bin/bash
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster serve --reload /etc/ckan/default/development.ini"
