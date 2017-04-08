echo    "# ======================================================== #"
echo    "# == Welcome to Easy CKAN installation                  == #"
echo    "# ======================================================== #"
echo    "| If you have any question or need support, open an        |"
echo    "| issue on: https://github.com/thenets/Easy-CKAN           |"
echo    "# ======================================================== #"
echo    ""


# Fix bash permissions
chmod +x ./*/*.sh


# Install command line tools
# ==============================================
echo    "# ======================================================== #"
echo    "# == Installing Easy CKAN command line tools            == #"
echo    "# ======================================================== #"
su -c "sleep 1"
mkdir -p /etc/easyckan/

# Copying folders
cp -R ./bin/ /etc/easyckan/bin/
cp -R ./helpers/ /etc/easyckan/helpers/
cp -R ./installers/ /etc/easyckan/installers/

# Set permissions
chmod +x /etc/easyckan/bin/easyckan

# Add easyckan to path
ln -s /etc/easyckan/bin/easyckan /usr/bin/easyckan

echo "... done!"



# Finish
# ==============================================
echo    ""
echo    "# ======================================================== #"
echo    "# == Easy CKAN                                          == #"
echo    "# ======================================================== #"
echo    "| If you have any question or need support, talk with me   |"
echo    "| at https://webchat.freenode.net at channel #easyckan.    |"
echo    "|                                                          |"
echo    "| If you find bugs, please open a issue on:                |"
echo    "|           https://github.com/thenets/Easy-CKAN           |"
echo    "|                                                          |"
echo    "| Run the following command to learn how to use:           |"
echo    "|     # sudo easyckan help                                 |"
echo    "|                                                          |"
echo    "|                                                          |"
echo    "| Luiz Felipe F M Costa                                    |"
echo    "| TheNets.org                                              |"
echo    "# ======================================================== #"
