#!/bin/bash

# Reset permissions
chown -R ckan.ckan /etc/ckan
chown -R ckan.ckan /usr/lib/ckan
chown -R ckan.ckan /var/data/ckan
chown -R ckan.ckan /var/log/ckan

# Start
su ckan /ckan-entrypoint.sh
