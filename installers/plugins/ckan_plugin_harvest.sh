clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN : [PLUGIN] Harvest installation          == #"
echo    "# ======================================================== #"
su -c "sleep 2"

cd /tmp

# Redis database
# ==============================================
echo    "| Install Redis Server"
apt-get update
apt-get install -y redis-server
sed -i 's/# Plugin Harvest/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/ckan.harvest.mq.type = redis/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i "s/## Plugins Settings/## Plugins Settings\n\n# Plugin Harvest\nckan.harvest.mq.type = redis\n/g" /etc/ckan/default/development.ini


# Install Harvest plugin
# ==============================================
echo    "| Install Harvest from GitHub"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e git+https://github.com/ckan/ckanext-harvest.git@v0.0.5#egg=ckanext-harvest"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -r /usr/lib/ckan/default/src/ckanext-harvest/pip-requirements.txt"


# Activate Harvest plugin
# ==============================================
echo    "| Active Harvest plugin on CKAN config file"
sed -i 's/harvest ckan_harvester/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/ckan.plugins = /ckan.plugins = harvest ckan_harvester /g' /etc/ckan/default/development.ini


# Configuration of Harvest plugin
# ==============================================
echo    "| Install Harvest modifications on database"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster --plugin=ckanext-harvest harvester initdb --config=/etc/ckan/default/development.ini"


# Install Supervisor
# ==============================================
echo    "| Install supervisor to manage harvest background process"

# Install from apt-get
apt-get install -y supervisor

# Active supervisor (FIX for Docker)
service supervisor restart

# Add Supervisor configuration
cp /etc/easyckan/conf/supervisor/ckan_harvesting.conf /etc/supervisor/conf.d/ckan_harvesting.conf

# Create log dir
mkdir -p /var/log/ckan/std/

# Active Supervisor jobs
sudo supervisorctl reread
sudo supervisorctl add ckan_gather_consumer
sudo supervisorctl add ckan_fetch_consumer
sudo supervisorctl add ckan_run_jobs
#sudo supervisorctl start ckan_gather_consumer
#sudo supervisorctl start ckan_fetch_consumer
#sudo supervisorctl start ckan_run_jobs

echo    "# Harvest was installed! #"
