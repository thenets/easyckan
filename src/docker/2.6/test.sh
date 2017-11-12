#!/bin/bash

# Dependencies
# ===========================================================
echo "Installing Mocha for front-end tests..."
npm install mocha-phantomjs@4.0


# Test Front-end
# ===========================================================
docker rm -f $(docker ps -qa)

# Import env
EASYCKAN_DEV_MODE=false
SCRIPT_HOME="/etc/easyckan/bin"
source $SCRIPT_HOME/_dependencies

# Start CKAN containers dependences
echo "# Create network and start dependences..."
ckan-dependencies

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
        
sleep 15 # Make sure the server has fully started

# Run test
mocha-phantomjs http://localhost:5000/base/test/index.html
mocha-phantomjs http://localhost:8080/base/test/index.html

# Did an error occur?
MOCHA_ERROR=$?

# Did an error occur?
[ "0" -ne "$MOCHA_ERROR" ] && echo MOCHA tests have failed


# Remove all containers
# ===========================================================
docker ps -a
docker rm -f $(docker ps -qa)

# Error output to Travis
# ===========================================================
exit `expr $MOCHA_ERROR`