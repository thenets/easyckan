clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN : [PLUGIN] DataStore installation        == #"
echo    "# ======================================================== #"
su -c "sleep 3"

echo    "# == Setup Postgres for DataStore"
echo -n "| Type DataStore password: "
read v_password

# Set-up the database
su postgres -c "psql --command \"CREATE USER datastore_default WITH PASSWORD '"$v_password"';\""
#echo    "| Insert the SAME password two more times..."
#: $(su postgres -c "createuser -S -D -R -P -l datastore_default")
#su postgres -c "createdb -O ckan_default datastore_default -E utf-8"

# Activating plugin
sed -i 's/ckan.plugins = /ckan.plugins = datastore /g' /etc/ckan/default/development.ini

# Set-up database configuration access
sed -i "s/ckan_default:pass@localhost/ckan_default:$v_password@localhost/g" /etc/ckan/default/development.ini
sed -i "s/datastore_default:pass@localhost/datastore_default:$v_password@localhost/g" /etc/ckan/default/development.ini

# Uncomment database settings
sed -i 's/#ckan.datastore.write_url/ckan.datastore.write_url/g' /etc/ckan/default/development.ini
sed -i 's/#ckan.datastore.read_url/ckan.datastore.read_url/g' /etc/ckan/default/development.ini

# Set permissions
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster --plugin=ckan datastore set-permissions -c /etc/ckan/default/development.ini > /etc/ckan/default/_plugin_datastore.sql"

su postgres -c "cat /etc/ckan/default/_plugin_datastore.sql | psql --set ON_ERROR_STOP=1"
