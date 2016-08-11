# Easy-CKAN v0.2
Easiest way to install CKAN platform.

## What have inside the Easy CKAN?
- CKAN 2.5.2
- [[Plugin] DataStore (version for CKAN base installation)](http://docs.ckan.org/en/latest/maintaining/datastore.html)
- [[Plugin] Harvest 0.5](https://github.com/ckan/ckanext-harvest)
- Easy CKAN command line (NEW!)

## 1. Requirements
Pay attention if you have the follow requirements.

- Ubuntu 14.04 or Ubuntu 16.04
- Nothing running over ports: 8080, 8888, 80
- No Apache2 or NGINX previously installed


## 2. How to Install
Just run the following lines on your server:

```
sudo su -c "apt-get install git-core"
sudo su -c "cd /tmp && rm -rf ./Easy-CKAN && git clone https://github.com/thenets/Easy-CKAN.git && cd ./Easy-CKAN && ./easy_ckan.sh"
sudo su -c "easyckan install"
```

## 3. How to use (Easy CKAN command line)
The Easy CKAN command line is the best way to interact with your CKAN installation.

### 3.1. Start server
Run the server on development enviroment:

```
# Development enviroment
sudo easyckan server # Avaliable over port 5000
```

### 3.2. Deploy to production
After develop everything you want, just run the following command to deploy your CKAN to production:

```
# Production enviroment
sudo easyckan deploy # Avaliable over port 80
```


### 3.2. Harvest Helper (plugin)
This helper is a simple interface for Harvest Plugin.
You can learn more about on plugin's page at [CKANext Harvest](https://github.com/ckan/ckanext-harvest)
But below a create some examples:

```
sudo /root/easy_ckan/harvest.sh sources   # Show all sources
sudo /root/easy_ckan/harvest.sh job-all   # Create jobs for all sources
```

## 4. Have questions?
Just let me know here, on "Issues", or send me an email: luiz@thenets.org


## For future
I want to add some additional improments:

- Feature: Uninstaller
- Feature: More plugins
    + [Wordpress integration for CKAN](http://extensions.ckan.org/extension/wordpresser/)
    + [CKAN extension to integrate Google Analytics data into CKAN](http://extensions.ckan.org/extension/googleanalytics/)
- Improvement: Better bash interface


## Developer installer
If you want the lastest Easy CKAN version, use following lines to your installation.
!IMPORTANT! Probably you will find some bugs. This is just for developers.

```
sudo su -c "apt-get install git-core"
sudo su -c "cd /tmp && rm -rf ./Easy-CKAN && git clone -b dev https://github.com/thenets/Easy-CKAN.git && cd ./Easy-CKAN && ./easy_ckan.sh"
sudo su -c "easyckan install"
```

To update the Easy CKAN command line tools with the DEV version, just run:

```
sudo easyckan update dev
```
