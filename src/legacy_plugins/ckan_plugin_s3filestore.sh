clear
echo    "# ======================================================== #"
echo    "# == Easy CKAN : [PLUGIN] s3filestore installation     = = #"
echo    "#                                                          #"
echo    "# Installer created by:                                    #"
echo    "#   Vlad (GitHub: vladimirghetau)                          #"
echo    "# ======================================================== #"
su -c "sleep 3"

echo    "# == Setup Postgres for DataStore"
echo -n "| Your AWS Access Key ID: "
read aws_access_key_id

echo -n "| Your AWS Secret Access Key: "
read aws_secret_access_key 

echo -n "| Bucket to store your stuff: "
read aws_bucket_name  

echo -n "| Path (optional): "
read aws_storage_path 

cd /tmp

# Install Basic Charts plugin
# ==============================================
echo    "| Install S3 File Store from GitHub"
su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && pip install -e git+https://github.com/okfn/ckanext-s3filestore.git#egg=ckanext-s3filestore"

# Activating plugin
echo    "| Activating plugin"
sed -i 's/ckan.plugins = /ckan.plugins = s3filestore /g' /etc/ckan/default/development.ini

# plugin settings string formation
pluginSettingsList="ckanext.s3filestore.aws_access_key_id = ${aws_access_key_id}\nckanext.s3filestore.aws_secret_access_key = ${aws_secret_access_key}\nckanext.s3filestore.aws_bucket_name = ${aws_bucket_name}\n"

if [[ -z "${aws_storage_path// }" ]]; then
    pluginSettingsList+="ckanext.s3filestore.aws_storage_path = ${aws_storage_path}\n"
fi

# Save plugin settings
echo    "| Saving plugin settings"
sed -i "s/## Plugins Settings/## Plugins Settings\n\n# s3filestore plugin\n${pluginSettingsList}/g" /etc/ckan/default/development.ini

echo    "# S3 File Store plugin installed! #"

# ========================================
# Deploy
# ========================================
/etc/easyckan/bin/easyckan deploy

# restarting Restart CKAN
service apache2 restart
echo    "# CKAN Restarted #"
