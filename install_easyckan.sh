echo    "# ======================================================== #"
echo    "# == Welcome to Easy CKAN installation                  == #"
echo    "# ======================================================== #"
echo    ""



# Install Docker and main dependences
# ==============================================
echo    "# ======================================================== #"
echo    "# == Installing Docker and main dependences             == #"
echo    "# ======================================================== #"

# Envs for package manager
YUM_CMD=$(which yum)
APT_GET_CMD=$(which apt-get)

if [[ ! -z $YUM_CMD ]]; then
    yum install -y      curl sudo git
elif [[ ! -z $APT_GET_CMD ]]; then
    apt-get update
    apt-get install -y  curl sudo git
else
    echo "Your distro is not compatible! Check https://github.com/thenets/Easy-CKAN"
    echo "Exiting..."
    exit 1;
fi

curl -sSL https://get.docker.com/ | sh
usermod -aG docker $(grep 1000 /etc/passwd | cut -f1 -d:)




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
