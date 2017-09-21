<a href="https://koding.com/"> <img src="https://koding-cdn.s3.amazonaws.com/badges/made-with-koding/v1/koding_badge_RectangleColor.png" srcset="https://koding-cdn.s3.amazonaws.com/badges/made-with-koding/v1/koding_badge_RectangleColor.png 1x, https://koding-cdn.s3.amazonaws.com/badges/made-with-koding/v1/koding_badge_RectangleColor@2x.png 2x" alt="Made with Koding" /> </a>

# Easy-CKAN v0.3 Beta
Easiest way to install the CKAN platform.

## What Is Included In Easy CKAN?
- CKAN 2.5.2
- Plugins
  + [[Plugin] DataStore (version for CKAN base installation)](http://docs.ckan.org/en/latest/maintaining/datastore.html)
  + [[Plugin] Harvest (v0.5)](https://github.com/ckan/ckanext-harvest)
  + [[Plugin] Scheming (latest) - Thanks to @timgiles](https://github.com/ckan/ckanext-scheming)

- Easy CKAN command line (NEW!)

## 1. Requirements
Your server / virtual machine must meet the following requirements:

- Ubuntu 14.04 (beta) or Ubuntu 16.04 (alpha is not recommended)
- Nothing running over ports: 8080, 8888, 8800, 80, 5000
- No Apache2 or NGINX previously installed

It is generally better to have a completely clean install of Ubuntu to work from.

## 2. How To Install
Run the following commands on your server / virtual machine:

```
sudo su -c "apt-get update && apt-get upgrade -y"
sudo su -c "apt-get install git-core"
sudo su -c "cd /tmp && rm -rf ./Easy-CKAN && git clone https://github.com/thenets/Easy-CKAN.git && cd ./Easy-CKAN && ./easy_ckan.sh"
sudo su -c "easyckan install"
```

## 3. Easy CKAN Command Line
The Easy CKAN command line is the best way to interact with your CKAN installation.

### 3.1. Start Server - Development Mode
To run the server in a development enviroment, run:

```
# Development enviroment
sudo easyckan server # Avaliable over port 5000
```

### 3.2. Deploy - Production Mode
Once you have finished development and are ready to push your changes into a production environment, run:

```
# Production enviroment
sudo easyckan deploy # Avaliable over port 80
```

## 4. Any Questions?
If you have any questions, either [raise an issue here on GitHub](https://github.com/thenets/Easy-CKAN/issues) or send me an email: [luiz@thenets.org](mailto:luiz@thenets.org)


## Other Commands
Some of these features not completed yet. Use with caution.

```
# Plugins
# ================================================================
easyckan plugin install {PLUGIN_NAME}
   - harvest
   - datastore
   - scheming
   
   # Example: easyckan plugin install harvest


# DataPusher (from https://github.com/ckan/datapusher )
# ================================================================
easyckan plugin datapusher {COMMAND}
   - update
     Update all files on DataStore.
   
   # Example: easyckan plugin datapusher update



# Harvest (from https://github.com/ckan/ckanext-harvest )
#
# You can check all usage documentation official plugin page.
# ================================================================
easyckan plugin harvest {COMMAND}
    - harvester source {name} {url} {type} [{title}] [{active}] [{owner_org}] [{frequency}] [{config}]
    - harvester source {source-id/name}
    - harvester rmsource {source-id/name}
    - harvester clearsource {source-id/name}
    - harvester sources [all]
    - harvester job {source-id/name}
    - harvester jobs
    - harvester job_abort {source-id/name}
    - harvester run
    - harvester run_test {source-id/name}
    - harvester gather_consumer
    - harvester fetch_consumer
    - harvester purge_queues
    - harvester job-all
    - harvester reindex

```



## Todo
I want to add some additional improvements:

- Feature: Uninstaller
- Feature: More plugins
    + [Wordpress integration for CKAN](http://extensions.ckan.org/extension/wordpresser/)
    + [CKAN extension to integrate Google Analytics data into CKAN](http://extensions.ckan.org/extension/googleanalytics/)
- Feature: Bash interface for new plugin installations
- Improvement: Better bash interface


## Special thanks
- @mohnjatthews : Improved README documentation
- @vladimirghetau : New plugins installers


## Developer Installer
If you want the lastest Easy CKAN version, use following lines to your installation.
!IMPORTANT! This version will most likely contain bugs, so use at your own risk.

```
sudo su -c "apt-get update && apt-get upgrade -y"
sudo su -c "apt-get install git-core"
sudo su -c "cd /tmp && rm -rf ./Easy-CKAN && git clone -b dev https://github.com/thenets/Easy-CKAN.git && cd ./Easy-CKAN && ./easy_ckan.sh"
sudo su -c "easyckan install"
```

To update the Easy CKAN command line tools with the DEV version, just run:

```
sudo easyckan update dev
```