clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN : [PLUGIN] Hierarchy installation        == #"
echo    "#                                                          #"
echo    "# Installer created by:                                    #"
echo    "#   Timothy (GitHub: timgiles)                             #"
echo    "# ======================================================== #"
su -c "sleep 2"

cd /tmp

# Install Hierarchy plugin
# ==============================================
echo    "| Install Hierarchy extension from GitHub"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e git+https://github.com/datagovuk/ckanext-hierarchy.git#egg=ckanext-hierarchy"

# Activate Hierarchy plugin
# ==============================================
echo    "| Active Hierarchy plugin on CKAN config file"
sed -i 's/hierarchy_display hierarchy_form/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/ckan.plugins = /ckan.plugins = hierarchy_display hierarchy_form /g' /etc/ckan/default/development.ini

## Front-End Settings

echo    "# Hierarchy plugins installed! #"
