#!/bin/bash


# Starting server
# ===========================================================
echo ""
echo "# Remove all Docker containers..."
docker rm -f $(docker ps -qa) 2>/dev/null

# Import env
EASYCKAN_DEV_MODE=false
echo $EASYCKAN_DEV_MODE > /tmp/easyckan_dev_mode
SCRIPT_HOME="/etc/easyckan/bin"
source $SCRIPT_HOME/_dependencies

# Start CKAN containers dependences
echo ""
echo "# Create network and start dependences..."
sudo easyckan exec pwd

# Start server dev mode
echo ""
echo "# Start EasyCKAN server..."
docker run --net=easyckan --name "ckan-dev" --rm -d \
        -v /usr/lib/ckan:/usr/lib/ckan \
        -v /etc/ckan:/etc/ckan \
        -v /var/lib/ckan:/var/lib/ckan \
        -p 5000:5000 \
        easyckan/ckan-dev:$V_CKAN_BASE_VERSION

# Start server prod mode
docker run --net=easyckan --name "ckan-production" --rm -d \
        -v /usr/lib/ckan:/usr/lib/ckan \
        -v /etc/ckan:/etc/ckan \
        -v /var/lib/ckan:/var/lib/ckan \
        -p 8080:8080 \
        easyckan/ckan-production:$V_CKAN_BASE_VERSION apachectl -X
        
sleep 5 # Make sure the server has fully started


# Creating NodeJS container for Mocha PhantomJS
# ===========================================================
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ""
echo "# Creating NodeJS container for Mocha PhantomJS..."
docker run --net=easyckan --name "ckan-mocha" --rm -it \
        -v $DIR/mocha.sh:/mocha.sh \
        -v /tmp/mocha:/tmp/mocha \
        --entrypoint /mocha.sh \
        --user root \
        easyckan/ckan-cli:$V_CKAN_BASE_VERSION bash


# Remove all containers
# ===========================================================
echo ""
echo "# Remove all Docker containers..."
docker rm -f $(docker ps -qa) &>/dev/null


# Tests result
# ===========================================================echo ""
echo ""
MOCHA_ERROR_LOG=$(echo /tmp/mocha/mocha_err.log)
RED='\033[0;31m'        # Red color
GREEN='\033[0;32m'      # Green color
NC='\033[0m'            # No Color
if [[ -s $MOCHA_ERROR_LOG ]]; then
        echo -e "${RED}# Tests result..."
        MOCHA_ERROR=1
        echo -e "${RED}--- MOCHA tests have failed! T.T $NC"
else
        echo -e "${GREEN}# Tests result..."
        MOCHA_ERROR=0
        echo -e "${GREEN}--- MOCHA tests passed! :D $NC"
fi
echo ''


# Error output to Travis
# ===========================================================
exit `expr $MOCHA_ERROR`
