# EasyCKAN v0.2.6 Beta.1
Easiest way to install the CKAN platform.
Compatible with all Linux x64 distros.

## What Is Included In Easy CKAN?
- EasyCKAN CLI
- CKAN 2.6.2
- Plugins
  + [[Plugin] DataStore (version for CKAN base installation)](http://docs.ckan.org/en/latest/maintaining/datastore.html)
  + [[Plugin] Harvest (v0.5)](https://github.com/ckan/ckanext-harvest)

## 1. Requirements
Your server / virtual machine must meet the following requirements:

- Linux x64 kernel version 3.10 or higher
- 2.00 GB of RAM
- 6.00 GB of available disk space
- Nothing running over ports: 80, 5000

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
- @alersonluz : Help with first installer for Ubuntu
- @mohnjatthews : Improved README documentation
- @timgiles : New plugins installers
- @vladimirghetau : New plugins installers
- @samisnunu : Test for CKAN 2.6


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