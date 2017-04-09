# EasyCKAN v2.6 Beta.1

Easiest way to install the CKAN platform.

Compatible with all Linux x64 distros.

## What Is Included In Easy CKAN?
- EasyCKAN CLI
- CKAN 2.6.2
- Plugins
  + [[Plugin] DataStore (version for CKAN base installation)](http://docs.ckan.org/en/latest/maintaining/datastore.html)

## 1. Requirements
Your server / virtual machine must meet the following requirements:

- Linux x64 kernel version 3.10 or higher
- 2.00 GB of RAM
- 6.00 GB of available disk space
- Nothing running over ports: 80, 5000

It is generally better to have a completely clean install of Ubuntu to work from, it's not required.


## 2. How To Install
Run the following commands on your server / virtual machine:

```
# Not avaliable yet...
# Check dev mode below...
```

## 3. Easy CKAN Command Line
The Easy CKAN command line is the best way to interact with your CKAN installation.

### 3.1. Start Server - Development Mode
To run the server in a development enviroment, run:

```
# Development enviroment
sudo easyckan dev # Avaliable over port 5000
```

### 3.2. Deploy - Production Mode
Once you have finished development and are ready to push your changes into a production environment, run:

```
# Production enviroment
sudo easyckan deploy # Avaliable over port 80
```

## 4. Questions? Support?
If you have any question or need support, talk with me at https://webchat.freenode.net at channel #easyckan. 

If you have any questions, either [raise an issue here on GitHub](https://github.com/thenets/Easy-CKAN/issues) or send me an email: [luiz@thenets.org](mailto:luiz@thenets.org)

## Where are my files?
All files are located on default content. Check CKAN documentation for more information:
http://docs.ckan.org/en/latest/maintaining/

```
/etc/easyckan   # EasyCKAN files
/etc/ckan/      # CKAN settings files
/usr/lib/ckan/  # Main CKAN files and plugins/extensions
/var/lib/ckan/  # CKAN upload files
```

## Todo
I want to add some additional improvements:

- Feature: Uninstaller
- Feature: Interface plugin installations
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

You need to instal 'curl' and run the command below.

- For Ubuntu/Debian: sudo apt-get install -y curl
- For Fedora/CentOS: sudo yum install -y curl

```
curl -sSL https://raw.githubusercontent.com/thenets/Easy-CKAN/dev/install_easyckan.sh | sudo bash
```

To update the Easy CKAN command line tools with the DEV version, just run:

```
sudo easyckan update dev
```