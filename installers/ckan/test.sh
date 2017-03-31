clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN installation for Ubuntu 16.04            == #"
echo    "#                                                          #"
echo    "# Special thanks to:                                       #"
echo    "#   Alerson Luz (GitHub: alersonluz)                       #"
echo    "#   Adrien GRIMAL                                          #"
echo    "#                                                          #"

# Main parameters
# ==============================================
V_CKAN_BASE_VERSION="2.6"
V_CKAN_VERSION="2.6.2"
V_POSTGRESQL_VERSION="9.6.2"
V_SOLR_VERSION="6.5.0-alpine"


echo    "# Versions:                                                #"
echo    "#   CKAN        : $V_CKAN_VERSION                                    #"
echo    "#   PostgreSQL  : $V_POSTGRESQL_VERSION                                    #"
echo    "#   Apache Solr : $V_SOLR_VERSION                             #"
echo    "# ======================================================== #"



##if [ ! -d "/var" ]; then # DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!



# Check if already installed
# ==============================================
if [ -d "/usr/lib/ckan/default/src/ckan" ]; then
	echo 	""
	echo 	"An CKAN installation was found!"
	echo    "Do you want to remove old installation?"
	echo -n "(extensions will not be removed) [y/N] : "
	read V_REMOVE_OLD_INSTALLATION

	if [[ $(echo "$V_REMOVE_OLD_INSTALLATION" | perl -ne 'print lc') == "y" ]]
	then
		echo "Removing /usr/lib/ckan/default/src/ckan directory..."
		rm -R /usr/lib/ckan/default/src/ckan
	else
		echo "Aborting installation!"
		echo ""
		exit
	fi
fi
if [ -f /etc/ckan/default/development.ini ]; then
	echo 	""
	echo 	"An CKAN setting file was found!"
	echo -n "Do you want to remove '/etc/ckan/default/development.ini' ? [y/N] : "
	read V_REMOVE_OLD_SETTING_FILE

	if [[ $(echo "$V_REMOVE_OLD_SETTING_FILE" | perl -ne 'print lc') == "y" ]]
	then
		echo "Removing '/etc/ckan/default/development.ini'..."
		rm /etc/ckan/default/development.ini
	else
		echo "Aborting installation!"
		echo ""
		exit
	fi
fi







# Get parameters from user
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 1. Set main config variables                       == #"
echo    "# ======================================================== #"
echo    ""

# No arguments sent. Interactive input.
if [ -z "$1" ] || [ -z "$2" ]; then
	echo    "# 1.1. Set site URL"
	echo    "| You site URL must be like http://localhost"
	echo -n "| Type the domain: http://"
	read v_siteurl

	echo    ""
	echo    "# 1.2. Set Password PostgreSQL (database)"
	echo    "| Enter a password to be used on installation process. "
	echo -n "| Type a password: "
	read v_password

# Set from arguments
else
	v_siteurl=$1
	v_password=$2
fi







# Preparations
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 2. Update Ubuntu packages                          == #"
echo    "# ======================================================== #"
cd /tmp
apt-get update







# Docker
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 3. Install Docker                                  == #"
echo    "# ======================================================== #"
#curl -sSL https://get.docker.com/ | sh
usermod -aG docker $(grep 1000 /etc/passwd | cut -f1 -d:)








# Main dependences
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 3. Install CKAN dependences from 'apt-get'         == #"
echo    "# ======================================================== #"
su -c "sleep 2"
apt-get install -y python-dev libpq-dev python-pip python-virtualenv python-paste git-core sudo
apt-get install -y libmemcached-dev zlib1g-dev # FIX for CKAN 2.6.0

# Used by Apache Solr. No more needed.
# if [ ! -d "/usr/java" ]; then
# 	apt-get install -y openjdk-8-jdk
# 	# Create link to Java JDK on default path
# 	mkdir /usr/java
# 	ln -s /usr/lib/jvm/java-8-openjdk-amd64 /usr/java/default
# fi








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
v_docker_solr_p="8983:8080"					# Port

# Remove old container if exists
echo "Removing old container if exists..."
docker rm -f $v_docker_solr_name

# Create container as daemon
docker run --name $v_docker_solr_name -p $v_docker_solr_p -d ckan/solr








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
	chown ckan.33 -R /usr/lib/ckan
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




#fi # DEBUG!!!!!!!!!!!!!!!!!!!!!!!!!!!




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
chown -R ckan.ckan /etc/ckan
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster make-config ckan /etc/ckan/default/development.ini"
sed -i "s/ckan.site_url =/ckan.site_url = http:\/\/$v_siteurl/g" /etc/ckan/default/development.ini
sed -i "s/ckan_default:pass@localhost/postgres:$v_password@localhost/g" /etc/ckan/default/development.ini
sed -i "s/#solr_url/solr_url/g" /etc/ckan/default/development.ini
sed -i "s/127.0.0.1:8983/127.0.0.1:8983/g" /etc/ckan/default/development.ini
chown ckan.33 -R /etc/ckan/default

# Setup a storage path
echo    "# 4.5 Setting a storage path for upload support..."
su -c "sleep 2"
mkdir -p /var/lib/ckan
chown -R ckan.33 /var/lib/ckan
sed -i 's/#ckan.storage_path/ckan.storage_path/g' /etc/ckan/default/development.ini






# Last configurations
# ==============================================
echo    ""
echo    ""
echo    "# ======================================================== #"
echo    "# == 6. Finishing                                       == #"
echo    "# ======================================================== #"
#su -c "sleep 2"

echo    "# 6.1. Initilize CKAN database..."
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckan && paster db init -c /etc/ckan/default/development.ini"

echo    "# 6.2. Set 'who.ini'..."
rm /etc/ckan/default/who.ini
ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini


exit



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