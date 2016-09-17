clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN : [PLUGIN] Basic charts installation     == #"
echo    "#                                                          #"
echo    "# Installer created by:                                    #"
echo    "#   Timothy (GitHub: timgiles)                             #"
echo    "# ======================================================== #"
su -c "sleep 2"

cd /tmp

# Install Basic Charts plugin
# ==============================================
echo    "| Install Basic Charts extension from GitHub"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e git+https://github.com/ckan/ckanext-basiccharts.git#egg=ckanext-basiccharts"

# Activate Basic Charts plugin
# ==============================================
echo    "| Active Basic Charts plugin on CKAN config file"
sed -i 's/linechart barchart piechart basicgrid/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/ckan.plugins = /ckan.plugins = linechart barchart piechart basicgrid /g' /etc/ckan/default/development.ini

## Front-End Settings

echo    "# Basic Charts plugins installed! #"
