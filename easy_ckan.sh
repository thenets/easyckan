clear
echo    "# ======================================================== #"
echo    "# == Welcome to Easy CKAN installation for Ubuntu 14.04 == #"
echo    "# ======================================================== #"
echo    "| If you have any question or need support, just open an   |"
echo    "| issue on: https://github.com/thenets/Easy-CKAN           |"
echo    "# ======================================================== #"
su -c "sleep 3"



echo "Starting CKAN Installation..."
	
# Fix bash permissions
chmod +x ./*/*.sh

# Run Ubuntu 14.04 installer
./installers/ckan/ckan_ubuntu14.04_installer.sh

# Install helpers
cp -R ./helpers /root/easy_ckan/




# Finish
# ==============================================
echo    ""
echo    ""
echo    "# ======================================================== #"
echo    "# == CKAN installation complete!                        == #"
echo    "# ======================================================== #"
echo    "| If you have any question or need support, just open an   |"
echo    "| issue on: https://github.com/thenets/Easy-CKAN           |"
echo    "# ======================================================== #"
read success
