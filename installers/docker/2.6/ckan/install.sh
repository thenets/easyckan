clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN installation for Ubuntu 16.04            == #"
echo    "#                                                          #"
echo    "# Special thanks to:                                       #"
echo    "#   Alerson Luz (GitHub: alersonluz)                       #"
echo    "#   Adrien GRIMAL                                          #"
echo    "#                                                          #"
echo    "# ======================================================== #"






# Get parameters
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 1. Getting parameters                              == #"
echo    "# ======================================================== #"

v_siteurl=$1
v_password=$(date +%s | sha256sum | base64 | head -c 24 ; echo)

echo "  Site URL: "$v_siteurl
echo "  PostgreSQL Password: "$v_password
sleep 1

# Save PostgreSQL password
mkdir -p /etc/easyckan/conf/
echo $v_password > /etc/easyckan/conf/postgresql.conf



# Main dependences
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 3. Install CKAN dependences from 'apt-get'         == #"
echo    "# ======================================================== #"
su -c "sleep 2"
apt-get install -y python-dev libpq-dev python-pip python-virtualenv python-paste git-core sudo
apt-get install -y libmemcached-dev zlib1g-dev # FIX for CKAN 2.6.0


# Setup a PostgreSQL database
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 3. Docker: Setup PostgreSQL container              == #"
echo    "# ======================================================== #"

# Set variables
v_docker_postgres_name="ckan-postgres"									# Container name
v_docker_postgres_path="/var/easyckan/database"							# Host persistent data path
v_docker_postgres_v="$v_docker_postgres_path:/var/lib/postgresql/data"	# Volume path
v_docker_postgres_p="5432:5432"											# Port
v_docker_postgres_i="postgres:$V_POSTGRESQL_VERSION"					# Image and tag

# Remove old container if exists
echo "Removing old container if exists..."
docker rm -f $v_docker_postgres_name

# Create persistent data dir
mkdir -p $v_docker_postgres_path

# Create container as daemon
docker run --name $v_docker_postgres_name -v $v_docker_postgres_v -e POSTGRES_DB="ckan_default" -e POSTGRES_PASSWORD=$v_password -p $v_docker_postgres_p -d $v_docker_postgres_i
	   






# Install Solr
# ==============================================
echo    ""
echo    ""
echo    "# ======================================================== #"
echo    "# == 5. Docker: Setup Apache Solr container             == #"
echo    "# ======================================================== #"

# Set variables
v_docker_solr_name="ckan-solr"				# Container name
v_docker_solr_p="8983:8983"					# Port

# Remove old container if exists
echo "Removing old container if exists..."
docker rm -f $v_docker_solr_name

# Create container as daemon
docker run --name $v_docker_solr_name -p $v_docker_solr_p -d easyckan/solr








# Setup CKAN
# ==============================================
echo    ""
echo    ""
echo    "# ======================================================== #"
echo    "# == 4. Setup CKAN                                      == #"
echo    "# ======================================================== #"

# Create user if doesn't exist
if id "ckan" >/dev/null 2>&1; then
	echo    "# 4.1. CKAN user already exist. Skipping..."
	echo 	""
else
	echo    "# 4.1. Creating CKAN user..."
	useradd -m -d /usr/lib/ckan -c "CKAN User" ckan
	sudo usermod -a -G staff ckan
	chmod 775 -R /usr/local/lib/python2.7
	chmod 755 /usr/lib/ckan
	chown 5000.33 -R /usr/lib/ckan
fi

# Python Virtual Environment
echo    "# 4.2. Creating Python Virtual Environment..."
su -s /bin/bash - ckan -c "mkdir -p /usr/lib/ckan/default"
su -s /bin/bash - ckan -c "virtualenv --no-site-packages /usr/lib/ckan/default"

# Update mainly pip packages
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install --upgrade pip"		# HARD FIX
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install setuptools==20.4"	# HARD FIX for CKAN 2.6.0
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install html5lib==0.999"		# HARD FIX

# Download CKAN as cache
su -s /bin/bash - ckan -c "mkdir -p /usr/lib/ckan/cache/"
if [ ! -f "/usr/lib/ckan/cache/ckan-$V_CKAN_VERSION.zip" ]; then
	su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/cache/ && pip download 'git+https://github.com/ckan/ckan.git@ckan-$V_CKAN_VERSION#egg=ckan'"
fi

# Installing CKAN
echo    "# 4.3. Installing CKAN..."
su -s /bin/bash - ckan -c "cd /usr/lib/ckan/cache && unzip ckan-$V_CKAN_VERSION.zip"
su -s /bin/bash - ckan -c "mv /usr/lib/ckan/cache/ckan /usr/lib/ckan/default/src/ckan"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckan && python setup.py develop"

# Installing CKAN dependences
echo    "# 4.3. Installing CKAN dependences..."
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install /usr/lib/ckan/cache/ckan-$V_CKAN_VERSION.zip -t /usr/lib/ckan/default/src"
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
echo    "# 4.4. Creating main configuration file at /etc/ckan/default/development.ini ..."
rm /etc/ckan/default/development.ini
mkdir -p /etc/ckan/default
chown -R 5000.5000 /etc/ckan
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster make-config ckan /etc/ckan/default/development.ini"
sed -i "s/ckan.site_url =/ckan.site_url = http:\/\/$v_siteurl/g" /etc/ckan/default/development.ini
sed -i "s/ckan_default:pass@localhost/postgres:$v_password@localhost/g" /etc/ckan/default/development.ini
sed -i "s/#solr_url/solr_url/g" /etc/ckan/default/development.ini
sed -i "s/127.0.0.1:8983\/solr/127.0.0.1:8983\/solr\/ckan/g" /etc/ckan/default/development.ini
chown 5000.33 -R /etc/ckan/default

# Setup a storage path
echo    "# 4.5 Setting a storage path for upload support..."
su -c "sleep 2"
mkdir -p /var/lib/ckan
chown -R 5000.33 /var/lib/ckan
sed -i 's/#ckan.storage_path/ckan.storage_path/g' /etc/ckan/default/development.ini






# Last configurations
# ==============================================
echo    ""
echo    ""
echo    "# ======================================================== #"
echo    "# == 6. Finishing                                       == #"
echo    "# ======================================================== #"

echo    "# 6.1. Initilize CKAN database..."
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckan && paster db init -c /etc/ckan/default/development.ini"

echo    "# 6.2. Set 'who.ini'..."
rm /etc/ckan/default/who.ini
ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini






# Create a admin account
# ==============================================
clear
echo    "# ======================================================== #"
echo    "# == 7. CKAN Account                                    == #"
echo    "# ======================================================== #"
su -c "sleep 2"

echo    "# 7.1 Creating a Admin account..."
echo    "| Your account name will be 'admin'."
echo    "| Type the admin password:"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckan && paster sysadmin add admin -c /etc/ckan/default/development.ini"





su -c "sleep 2"
echo    ""
echo    "# ======================================================== #"
echo    "# == CKAN installation complete!                        == #"
echo    "# ======================================================== #"
echo    "|"
echo    "# Press [Enter] to continue..."
read success
