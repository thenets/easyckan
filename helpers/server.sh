#!/bin/bash
su -c "service postgresql start" 2> /dev/null
su -c "service tomcat6 start" 2> /dev/null
su -c "service tomcat7 start" 2> /dev/null
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster serve --reload /etc/ckan/default/development.ini"
