#!/bin/bash

MOCHA_STD_FILE='/tmp/mocha/mocha_std.log'
MOCHA_ERR_FILE='/tmp/mocha/mocha_err.log'
echo '' > $MOCHA_STD_FILE
echo '' > $MOCHA_ERR_FILE

# Colors
NC='\033[0m'        # No Color
PURPLE='\033[0;35m' # PURPLE color



# Test EasyCKAN dev and prod modes
echo ""
echo -e "${PURPLE}--- Testing for development mode: http://ckan-dev:5000/${NC}"
mocha-phantomjs http://ckan-dev:5000/base/test/index.html 2>&1 | tee -a $MOCHA_STD_FILE

#echo ""
#echo -e "${PURPLE}--- Testing for production mode: http://ckan-production:8080/${NC}"
#mocha-phantomjs http://ckan-production:8080/base/test/index.html 2>&1 | tee -a $MOCHA_STD_FILE


# Catch error log
echo '' > /tmp/err_tmp
cat $MOCHA_STD_FILE | grep Error >> /tmp/err_tmp
sed '/^$/d' /tmp/err_tmp > $MOCHA_ERR_FILE
