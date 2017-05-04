clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN : [PLUGIN] Pages                         == #"
echo    "# ======================================================== #"
su -c "sleep 2"

cd /tmp

# Install CKANext Pages plugin
# ==============================================
echo    "| Install CKANext Pages extension from GitHub"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e git+https://github.com/ckan/ckanext-pages.git#egg=ckanext-pages"


# Activate CKANext Pages plugin
# ==============================================
sed -i 's/pages/ /g' /etc/ckan/default/development.ini
sed -i 's/ckan.plugins = /ckan.plugins = pages /g' /etc/ckan/default/development.ini
sed -i "s/## Plugins Settings/## Plugins Settings\n\n# Pages plugin\nckanext.pages.allow_html = True\nckanext.pages.editor = ckeditor\n/g" /etc/ckan/default/development.ini


## Front-End Settings
echo    "# CKANext Pages plugins installed! #"
