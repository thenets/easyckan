clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN : [PLUGIN] PDF View  installation        == #"
echo    "#                                                          #"
echo    "# Installer created by:                                    #"
echo    "#   Timothy (GitHub: timgiles)                             #"
echo    "# ======================================================== #"
su -c "sleep 2"

cd /tmp

# Install PDF View plugin
# ==============================================
echo    "| Install PDF View extension from GitHub"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e git+https://github.com/ckan/ckanext-pdfview.git#egg=ckanext-pdfview"

# Activate PDF View plugin
# ==============================================
echo    "| Active PDF View plugin on CKAN config file"
sed -i 's/pdf_view/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/resource_proxy/ /g' /etc/ckan/default/development.ini # FIX DUPLICATE ON SECOND INSTALLATION
sed -i 's/ckan.plugins = /ckan.plugins = pdf_view resource_proxy /g' /etc/ckan/default/development.ini

## Front-End Settings

echo    "# PDF View plugins installed! #"
