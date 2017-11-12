clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN : [PLUGIN] Scheming installation         == #"
echo    "#                                                          #"
echo    "# Installer created by:                                    #"
echo    "#   Timothy (GitHub: timgiles)                             #"
echo    "# ======================================================== #"
su -c "sleep 2"

cd /tmp

# Install Scheming plugins
# ==============================================
echo    "| Install Scheming (+Fluent, Repeating and Composite) from GitHub"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e git+https://github.com/ckan/ckanext-scheming.git#egg=ckanext-scheming"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -r /usr/lib/ckan/default/src/ckanext-scheming/requirements.txt"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e git+https://github.com/open-data/ckanext-repeating.git#egg=ckanext-repeating"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e git+https://github.com/ckan/ckanext-fluent.git#egg=ckanext-fluent"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e git+https://github.com/espona/ckanext-composite.git#egg=ckanext-composite"

# Activate Scheming plugins
# ==============================================
echo    "| Active Scheming plugin on CKAN config file"
sed -i 's/scheming_datasets repeating fluent composite/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/ckan.plugins = /ckan.plugins = scheming_datasets repeating fluent composite /g' /etc/ckan/default/development.ini

sed -i 's/scheming.dataset_schemas = ckanext.scheming:dataset.json/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/scheming.presets = ckanext.scheming:presets.json/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/                   ckanext.repeating:presets.json/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/                   ckanext.fluent:presets.json/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/                   ckanext.composite:presets.json/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/scheming.dataset_fallback = false/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION

sed -i 's/## Front-End Settings/scheming.dataset_schemas = ckanext.scheming:dataset.json \n \nscheming.presets = ckanext.scheming:presets.json \n                   ckanext.repeating:presets.json \n                   ckanext.fluent:presets.json \n                   ckanext.composite:presets.json \n \nscheming.dataset_fallback = false \n \n## Front-End Settings /g' /etc/ckan/default/development.ini


# Copy default scheming file
# ==============================================
cp /usr/lib/ckan/default/src/ckanext-scheming/ckanext/scheming/ckan_dataset.json /usr/lib/ckan/default/src/ckanext-scheming/ckanext/scheming/dataset.json


## Front-End Settings
echo    ""
echo    "# Scheming plugins installed!"
echo    "#"
echo    "# Set edit all datasets and resources fields, you should edit the file:"
echo    "#     /usr/lib/ckan/default/src/ckanext-scheming/ckanext/scheming/dataset.json"
echo    "#"
echo    "# Or run the command:"
echo    "#     easyckan plugin scheming"
