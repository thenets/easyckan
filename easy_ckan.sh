clear
echo    "# ======================================================== #"
echo    "# == Welcome to Easy CKAN installation                  == #"
echo    "# ======================================================== #"
echo    "| If you have any question or need support, just open an   |"
echo    "| issue on: https://github.com/thenets/Easy-CKAN           |"
echo    "# ======================================================== #"
su -c "sleep 3"



#echo "Starting CKAN Installation..."
echo ""

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




# Install helpers
cp -R ./helpers /root/easy_ckan/




# Finish
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == Easy CKAN                                          == #"
echo    "# ======================================================== #"
echo    "| If you have any question or need support, just open an   |"
echo    "| issue on: https://github.com/thenets/Easy-CKAN           |"
echo    "|                                                          |"
echo    "| Luiz Felipe F M Costa                                    |"
echo    "| TheNets.org                                              |"
echo    "# ======================================================== #"
