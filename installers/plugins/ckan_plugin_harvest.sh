clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN : [PLUGIN] Harvest installation          == #"
echo    "# ======================================================== #"
su -c "sleep 2"

cd /tmp

# Redis database
# ==============================================
echo    "| Install Redis Server"
apt-get install -y redis-server
sed -i "s/## Plugins Settings/## Plugins Settings\n\n# Harvest plugin dependence\nckan.harvest.mq.type = redis\n/g" /etc/ckan/default/development.ini


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


# Creating helper
# ==============================================
echo    "| Creating Helper"
mkdir -p /root/easy_ckan/
cp /tmp/Easy-CKAN/helpers/harvest.sh /root/easy_ckan/harvest.sh
cp /tmp/Easy-CKAN/helpers/harvest_background.sh /root/easy_ckan/harvest_background.sh



# Install service
# ==============================================


echo    "# Harvest was installed! #"
su -c "sleep 2"

