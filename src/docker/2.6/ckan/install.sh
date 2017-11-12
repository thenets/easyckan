#!/bin/bash

echo    "# ======================================================== #"
echo    "# == Easy CKAN installation for Ubuntu 16.04            == #"
echo    "# ======================================================== #"

# Environments variables
# ==============================================
V_CKAN_BASE_VERSION="2.6"
V_CKAN_VERSION="2.6.2"




# Get parameters
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 1. Getting parameters                              == #"
echo    "# ======================================================== #"

v_siteurl="http://localhost"
v_password=$(date +%s | sha256sum | base64 | head -c 24 ; echo)

echo "  Site URL            : "$v_siteurl
echo "  PostgreSQL Password : "$v_password
sleep 1

# Save PostgreSQL password
mkdir -p /var/lib/ckan/default
echo $v_password > /var/lib/ckan/default/postgresql.conf



# Main dependences
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 2. Update Ubuntu package repositories              == #"
echo    "# ======================================================== #"
apt-get update




# Setup CKAN
# ==============================================
echo    ""
echo    ""
echo    "# ======================================================== #"
echo    "# == 3. Setup CKAN                                      == #"
echo    "# ======================================================== #"

# Create user if doesn't exist
if id "ckan" >/dev/null 2>&1; then
	echo    "# 3.1. CKAN user already exist. Skipping..."
	echo 	""
else
	echo    "# 3.1. Creating CKAN user..."
	useradd -m -d /usr/lib/ckan -c "CKAN User" ckan
	sudo usermod -a -G staff ckan
	chmod 775 -R /usr/local/lib/python2.7
	chmod 755 /usr/lib/ckan
	chown 5000.33 -R /usr/lib/ckan
fi

# Python Virtual Environment
echo    "# 3.2. Creating Python Virtual Environment..."
su -s /bin/bash - ckan -c "mkdir -p /usr/lib/ckan/default"
su -s /bin/bash - ckan -c "virtualenv --no-site-packages /usr/lib/ckan/default"

# Update mainly pip packages
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install --upgrade pip"		# HARD FIX
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install setuptools==20.4"	# HARD FIX for CKAN 2.6.0
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install html5lib==0.999"		# HARD FIX

# Installing CKAN
echo    "# 3.3. Installing CKAN..."
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e 'git+https://github.com/ckan/ckan.git@ckan-$V_CKAN_VERSION#egg=ckan'"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckan && python setup.py develop"

# Installing CKAN dependences
echo    "# 3.3. Installing CKAN dependences..."
sed -i "s/bleach==1.4.2/bleach==1.4.3/g" /usr/lib/ckan/default/src/ckan/requirements.txt # HOT FIX
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -r /usr/lib/ckan/default/src/ckan/pip-requirements-docs.txt"






# Setup CKAN
# ==============================================
echo    ""
echo    ""
echo    "# ======================================================== #"
echo    "# == 4. Create CKAN settings file                       == #"
echo    "#                                                       == #"
echo    "#       /etc/ckan/default/development.ini               == #"
echo    "# ======================================================== #"

# Create main CKAN config files
echo    ""
echo    "# 4.1. Creating main configuration file at /etc/ckan/default/development.ini ..."
rm /etc/ckan/default/development.ini
mkdir -p /etc/ckan/default
chown -R 5000.5000 /etc/ckan
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster make-config ckan /etc/ckan/default/development.ini"
sed -i "s/ckan.site_url =/ckan.site_url = http:\/\/localhost/g" /etc/ckan/default/development.ini
sed -i "s/ckan_default:pass@localhost/postgres:$v_password@ckan-postgres/g" /etc/ckan/default/development.ini
sed -i "s/#solr_url/solr_url/g" /etc/ckan/default/development.ini
sed -i "s/127.0.0.1:8983\/solr/ckan-solr:8983\/solr\/ckan/g" /etc/ckan/default/development.ini
chown 5000.33 -R /etc/ckan/default

# Setup a storage path
echo    "# 4.2. Setting a storage path for upload support..."
su -c "sleep 1"
mkdir -p /var/lib/ckan
chown -R 5000.33 /var/lib/ckan
sed -i 's/#ckan.storage_path/ckan.storage_path/g' /etc/ckan/default/development.ini






# Last configurations
# ==============================================
echo    ""
echo    ""
echo    "# ======================================================== #"
echo    "# == 5. Finishing                                       == #"
echo    "# ======================================================== #"

echo    "# 5.1. Initilize CKAN database..."
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckan && paster db init -c /etc/ckan/default/development.ini"

echo    "# 5.2. Set 'who.ini'..."
rm /etc/ckan/default/who.ini 2> /dev/null
ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini





su -c "sleep 1"
echo    ""
echo    "# ======================================================== #"
echo    "# == CKAN installation complete!                        == #"
echo    "#                                                          #"
echo    "# To start CKAN development mode:                          #"
echo    "#    sudo easyckan dev                                     #"
echo    "#                                                          #"
echo    "# To setup production mode:                                #"
echo    "#    sudo easyckan production                              #"
echo    "#                                                          #"
echo    "# ======================================================== #"
echo    ""

