clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN installation for Docker (Ubuntu 16.04)   == #"
echo    "#                                                          #"
echo    "# Special thanks to:                                       #"
echo    "#   Alerson Luz (GitHub: alersonluz)                       #"
echo    "#   Adrien GRIMAL                                          #"
echo    "# ======================================================== #"
su -c "sleep 3"



# Check if has all parameters
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == 1. Set main config variables                       == #"
echo    "# ======================================================== #"
echo    ""

# No arguments sent. Interactive input.
if [ -z "$1" ] || [ -z "$2" ]; then
   echo "You most give all parameters...\nExample: easyckan install [domain_name] [password]\nExiting..." 1>&2
   exit 1

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
su -c "sleep 2"
cd /tmp
apt-get update




# Main dependences
# ==============================================
echo    "# ======================================================== #"
echo    "# == 3. Install CKAN dependences from 'apt-get'         == #"
echo    "# ======================================================== #"
su -c "sleep 2"
apt-get install -y python-dev libpq-dev python-pip python-virtualenv git-core sudo



# Setup CKAN
# ==============================================
echo    ""
echo    ""
echo    "# ======================================================== #"
echo    "# == 4. Setup CKAN                                      == #"
echo    "# ======================================================== #"
su -c "sleep 2"

# Create user
echo    "# 4.1. Creating CKAN user..."
useradd -m -s /sbin/nologin -d /usr/lib/ckan -c "CKAN User" ckan
sudo usermod -a -G staff ckan
chmod 775 -R /usr/local/lib/python2.7
chmod 755 /usr/lib/ckan
chown ckan.33 -R /usr/lib/ckan

# Python Virtual Environment
echo    "# 4.2. Creating Python Virtual Environment..."
su -c "sleep 2"
apt-get install -y  python-pastescript
su -s /bin/bash - ckan -c "mkdir -p /usr/lib/ckan/default"
su -s /bin/bash - ckan -c "virtualenv --no-site-packages /usr/lib/ckan/default"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install --upgrade pip"		# HARD FIX
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install setuptools==18.5"	# HARD FIX
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install html5lib==0.999"		# HARD FIX

# Installing CKAN and dependences
echo    "# 4.3. Installing CKAN and dependences..."
su -c "sleep 2"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e 'git+https://github.com/ckan/ckan.git@ckan-2.5.2#egg=ckan'"
sed -i "s/bleach==1.4.2/bleach==1.4.3/g" /usr/lib/ckan/default/src/ckan/requirements.txt # HOT FIX
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -r /usr/lib/ckan/default/src/ckan/pip-requirements-docs.txt"

# Create main CKAN config files
echo    "# 4.4. Creating main configuration file at /etc/ckan/default/development.ini ..."
su -c "sleep 2"
mkdir -p /etc/ckan/default
chown -R ckan.ckan /etc/ckan
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster make-config ckan /etc/ckan/default/development.ini"
sed -i "s/ckan.site_url =/ckan.site_url = http:\/\/$v_siteurl/g" /etc/ckan/default/development.ini
sed -i "s/ckan_default:pass@localhost/ckan_default:$v_password@localhost/g" /etc/ckan/default/development.ini
sed -i "s/#solr_url/solr_url/g" /etc/ckan/default/development.ini
sed -i "s/127.0.0.1:8983/127.0.0.1:8080/g" /etc/ckan/default/development.ini
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
su -c "sleep 2"

echo    "# 6.2. Set 'who.ini'..."
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