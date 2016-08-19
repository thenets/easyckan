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
su postgres -c "createdb -O ckan_default datastore_default -E utf-8"

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



# ========================================
# DataPusher
# ========================================

# install requirements for the DataPusher
apt-get install python-dev python-virtualenv build-essential libxslt1-dev libxml2-dev git

# Remove old installation
cd ~
rm -Rf /usr/lib/ckan/datapusher

# create a virtualenv for datapusher
virtualenv /usr/lib/ckan/datapusher

# HARD FIX
su -c ". /usr/lib/ckan/datapusher/bin/activate && pip install --upgrade pip"
su -c ". /usr/lib/ckan/datapusher/bin/activate && pip install setuptools==18.5"
su -c ". /usr/lib/ckan/datapusher/bin/activate && pip install --upgrade html5lib"

#create a source directory and switch to it
mkdir /usr/lib/ckan/datapusher/src
cd /usr/lib/ckan/datapusher/src

#clone the source (always target the stable branch)
git clone -b stable https://github.com/ckan/datapusher.git

#install the DataPusher and its requirements
cd /usr/lib/ckan/datapusher/src/datapusher
su -c ". /usr/lib/ckan/datapusher/bin/activate && /usr/lib/ckan/datapusher/bin/pip install -r requirements.txt"
su -c ". /usr/lib/ckan/datapusher/bin/activate && /usr/lib/ckan/datapusher/bin/python setup.py develop"


#copy the standard Apache config file
# (use deployment/datapusher.apache2-4.conf if you are running under Apache 2.4)
rm -f /etc/apache2/sites-available/datapusher.conf
cp /usr/lib/ckan/datapusher/src/datapusher/deployment/datapusher.conf /etc/apache2/sites-available/datapusher.conf

#copy the standard DataPusher wsgi file
#(see note below if you are not using the default CKAN install location)
rm -f /etc/ckan/datapusher.wsgi
cp /usr/lib/ckan/datapusher/src/datapusher/deployment/datapusher.wsgi /etc/ckan/datapusher.wsgi

#copy the standard DataPusher settings.
rm -f /etc/ckan/datapusher_settings.py
cp /usr/lib/ckan/datapusher/src/datapusher/deployment/datapusher_settings.py /etc/ckan/datapusher_settings.py

#open up port 8800 on Apache where the DataPusher accepts connections.
#make sure you only run these 2 functions once otherwise you will need
#to manually edit /etc/apache2/ports.conf.

# FIX DUPLICATE
sed -i 's/NameVirtualHost *:8800/ /g' /etc/apache2/ports.conf 
sed -i 's/Listen 8800/ /g' /etc/apache2/ports.conf 

sh -c 'echo "NameVirtualHost *:8800" >> /etc/apache2/ports.conf'
sh -c 'echo "Listen 8800" >> /etc/apache2/ports.conf'

# Set permission
chown www-data /etc/ckan/datapusher.wsgi
chown www-data /etc/ckan/datapusher_settings.py
chown -R www-data /usr/lib/ckan/datapusher/

# Enable DataPusher Apache site
a2ensite datapusher
service apache2 restart


# Install Supervisor
# ==============================================
apt-get install -y supervisor

# Log dir
mkdir -p /var/log/ckan/std/

# Supervisor config
cp /etc/easyckan/conf/supervisor/ckan_datapusher.conf /etc/supervisor/conf.d/ckan_datapusher.conf

# Active Supervisor jobs
sudo supervisorctl reread
sudo supervisorctl add ckan_datapusher
sudo supervisorctl start ckan_datapusher

service supervisor restart