clear
echo    "# ======================================================== #"
echo    "# == Welcome to Easy CKAN installation v0.2             == #"
echo    "# ======================================================== #"
echo    "| If you have any question or need support, just open an   |"
echo    "| issue on: https://github.com/thenets/Easy-CKAN           |"
echo    "# ======================================================== #"
echo ""
su -c "sleep 3"



# Fix bash permissions
chmod +x ./*/*.sh



# ========================================
# Selecting OS version
# ========================================
os_version=$(lsb_release -r) # Get OS version
os_version_compatible=1

	# Run Ubuntu 14.04 installer
	if [[ $os_version == *"14.04"* ]]
	then
		os_version_compatible=1
		./installers/ckan/ckan_ubuntu14.04_installer.sh
	fi

	# Run Ubuntu 16.04 installer
	if [[ $os_version == *"16.04"* ]]
	then
		os_version_compatible=1
		./installers/ckan/ckan_ubuntu16.04_installer.sh
	fi

	# Run Ubuntu 16.04 installer
	if [[ $os_version_compatible == 0 ]]
	then
		echo "Your Linux distro is not compatible! :/"
		echo "Check the GitHub repository for supported versions\n or request for other distros versions."
		echo "   GitHub URL: https://github.com/thenets/Easy-CKAN"
	fi




# Install command line tools
# ==============================================
echo    ""
echo    ""
echo    "# ======================================================== #"
echo    "# == Installing Easy CKAN command line tools            == #"
echo    "# ======================================================== #"
su -c "sleep 2"
mkdir -p /etc/easyckan/

# Copying folders
cp -R  /bin/ 			/etc/easyckan/bin/
cp -R  /conf/ 			/etc/easyckan/conf/
cp -R  /helpers/ 		/etc/easyckan/helpers/
cp -R  /installers/ 	/etc/easyckan/installers/

# Set permissions
chmod +x /etc/easyckan/bin/easyckan

# Add easyckan to path
ln -s /etc/easyckan/bin/easyckan /usr/bin/easyckan

echo "... done!"
su -c "sleep 1"




# Finish
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == Easy CKAN                                          == #"
echo    "# ======================================================== #"
echo    "| If you have any question or need support, just open an   |"
echo    "| issue on: https://github.com/thenets/Easy-CKAN           |"
echo    "|                                                          |"
echo    "| Run the following command to learn the mainly commands:  |"
echo    "|     # sudo easyckan help                                 |"
echo    "|                                                          |"
echo    "|                                                          |"
echo    "| Luiz Felipe F M Costa                                    |"
echo    "| TheNets.org                                              |"
echo    "# ======================================================== #"
