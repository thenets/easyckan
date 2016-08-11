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



# Install command line tools
# ==============================================
echo    "# ======================================================== #"
echo    "# == Installing Easy CKAN command line tools            == #"
echo    "# ======================================================== #"
su -c "sleep 2"
mkdir -p /etc/easyckan/

# Copying folders
cp -R ./bin/ /etc/easyckan/bin/
cp -R ./conf/ /etc/easyckan/conf/
cp -R ./helpers/ /etc/easyckan/helpers/
cp -R ./installers/ /etc/easyckan/installers/

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
echo    "| Run the following command to learn how to use:           |"
echo    "|     # sudo easyckan help                                 |"
echo    "|                                                          |"
echo    "|                                                          |"
echo    "| Luiz Felipe F M Costa                                    |"
echo    "| TheNets.org                                              |"
echo    "# ======================================================== #"
