#!/bin/bash

# Color for bash output
RED='\033[0;31m'        # Red color
GREEN='\033[0;32m'      # Green color
NC='\033[0m'            # No Color


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

# Start CKAN containers dependencies
echo ""
echo "# Create network and start dependencies..."
sudo easyckan exec echo "... done"
docker rm -f ckan-supervisor

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
docker run --net=easyckan --name "ckan-production" -d \
        -v /usr/lib/ckan:/usr/lib/ckan \
        -v /etc/ckan:/etc/ckan \
        -v /var/lib/ckan:/var/lib/ckan \
        -v /var/log/apache2:/var/log/apache2 \
        -p 8080:8080 \
        --restart unless-stopped \
        easyckan/ckan-production:$V_CKAN_BASE_VERSION
        

sleep 9 # Make sure the server has fully started

echo ""
echo "# All Docker containers started..."
docker ps -a

echo ""
echo "# ckan-production container log..."
docker logs ckan-production
cat /var/log/apache2/*

echo ""
echo "# ckan-dev container log..."
docker logs ckan-dev


echo ""
echo "# Curl request test on dev and prod modes..."
curl -sSf http://127.0.0.1:8080 > /dev/null
curl -sSf http://127.0.0.1:5000 > /dev/null

sleep 2


# Creating NodeJS container for Mocha PhantomJS
# ===========================================================
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo ""
echo "# Creating NodeJS container for Mocha PhantomJS..."
docker run --net=easyckan --name "ckan-mocha" --rm -it \
        -v $DIR/travis-mocha.sh:/mocha.sh \
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
