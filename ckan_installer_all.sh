echo "Starting CKAN Installation..."

cd /tmp
wget -nv https://dl.dropboxusercontent.com/u/1644096/ckan/ckan_distros_versions/ckan_ubuntu14.04_installer.sh -O ckan_installer.sh
chmod +x ckan_installer.sh

clear
./ckan_installer.sh
 

