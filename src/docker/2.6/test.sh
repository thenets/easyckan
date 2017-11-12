#!/bin/bash

# Dependencies
# ===========================================================
echo "Starting EasyCKAN dependencies..."
sudo easyckan exec pwd

echo "Installing Mocha for front-end tests..."
npm install -g mocha-phantomjs@3.5.0 phantomjs@~1.9.1


# Test Front-end
# ===========================================================

# Start CKAN server
sudo easyckan dev &
sleep 5 # Make sure the server has fully started

# Run test
mocha-phantomjs http://localhost:5000/base/test/index.html

# Did an error occur?
MOCHA_ERROR=$?

# Did an error occur?
[ "0" -ne "$MOCHA_ERROR" ] && echo MOCHA tests have failed


# Remove all containers
# ===========================================================
docker rm -f $(docker ps -qa)

# Error output to Travis
# ===========================================================
exit `expr $MOCHA_ERROR + $NOSE_ERROR`