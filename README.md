[![Build Status](https://travis-ci.org/thenets/EasyCKAN.svg)](https://travis-ci.org/thenets/EasyCKAN)

# EasyCKAN v2.6 Beta.1

The easiest way to install the CKAN platform.

Compatible with all Linux x64 distros.

## Do you still use the legacy version?
The EasyCKAN was updated to new technologies now based on Docker containers. If you still using the old version on you organization or govern portal, you can find the legacy version on [legacy branch](https://github.com/thenets/EasyCKAN/tree/legacy).

## Who should use EasyCKAN?
The EasyCKAN project was created for **single node portals** and **development environmet**. If you need load balancer or other advanced features, consider create your environment manually from the [CKAN Source Installation](http://docs.ckan.org/en/latest/maintaining/installing/install-from-source.html).


## What Is Included In Easy CKAN?
- EasyCKAN CLI
- CKAN 2.6.2
- Plugins (officially supported)
  + [[Plugin] DataStore (version for CKAN base installation)](http://docs.ckan.org/en/latest/maintaining/datastore.html)

## 1. Requirements
Your server / virtual machine must meet the following requirements:

- Linux x64 kernel version 3.10 or higher
  - Distributions supported with simple installer: Ubuntu, Fedora, CentOS, openSUSE.
  - Other distros will require manual installation.
- 2.00 GB of RAM
- 6.00 GB of available disk space
- Nothing running over ports: 80, 5000

It is generally better to have a completely clean install of Ubuntu to work from, it's not required.


## 2. How To Install
Run the following commands on your server / virtual machine:

```
curl -sSL https://raw.githubusercontent.com/thenets/Easy-CKAN/master/install_easyckan.sh | sudo bash
sudo easyckan install
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
sudo easyckan production # Avaliable over port 80
```

### 3.3. Create admin user
Replace "my_username" with the username you want.
```
easyckan exec paster sysadmin add my_username --config=/etc/ckan/default/development.ini
```

### 3.4. Enter on VirtualEnv
If you want to run custom commands and use bash on CKAN VirtualEnv.
```
easyckan exec
```

### 3.5. Enter on PostgreSQL CLI
Enter on psql.
```
easyckan exec psql -h ckan-postgres -Upostgres
```

### 3.6. Create additional config file
Let's considering you're setuping the production environment from the beggining. In this case, it's better create a clean configuration file.
The follow command allow you to do it:
```
easyckan exec paster make-config ckan /etc/ckan/default/production.ini
```

### 3.7. Repair
Most common problems can be solved with ["Have You Tried Turning It Off And On Again?"](https://www.youtube.com/watch?v=nn2FB1P_Mn8)

The command below restart all Docker containers and create a fresh environment keepin all your CKAN data.
```
easyckan repair
```

Another common problem is wrong permission on CKAN dirs and files. To reset to default, run the following command:
```
sudo chown -R 5000.5000 /usr/lib/ckan/ /etc/ckan/ /var/lib/ckan/
```

### 3.8. Create plugin from scratch
CKAN allow you to create a simple plugin base from a scrath. You need to create the main structure and than compile for development. You can learn more at [Customizing CKAN’s templates](http://docs.ckan.org/en/latest/theming/templates.html)

First, enter on "virtualenv" and create the base template. Pay attention to change "my_plugin" by your plugin name. It's recommended to keep "ckanext-" prefix.

At the end, build your plugin.
```
# Enable virtual env and go to plugins dir
easyckan exec
cd /usr/lib/ckan/default/src

# Create the plugin from scratch
paster --plugin=ckan create -t ckanext ckanext-my_plugin

# Build
cd ./ckanext-my_plugin
python setup.py develop

# Close container
exit
```
Now add the plugin to your config file, on "ckan.plugins = my_plugin ..." at /etc/ckan/default/development.ini



### 3.9. Update search index

Rebuilds the search index. This is useful to prevent search indexes from getting out of sync with the main database.


```
# Full rebuild
easyckan exec paster --plugin=ckan search-index rebuild -c /etc/ckan/default/development.ini

# Fast rebuild
easyckan exec paster --plugin=ckan search-index rebuild_fast -c /etc/ckan/default/development.ini
```




## 4. Questions? Support?
**IRC: If you have any question or need support, talk with me at [Freenode.net](webchat.freenode.net/?channels=easyckan) at channel #easyckan. Not need an account, just enter and type "thenets" and I'll answer you if I'm online.**

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
- Plugin: Harvester


## Special thanks
- @alersonluz : Help with first installer for Ubuntu
- @mohnjatthews : Improved README documentation
- @timgiles : New plugins installers
- @vladimirghetau : New plugins installers
- @samisnunu : Test for CKAN 2.6


## Developer Installer
If you want the lastest Easy CKAN version, use following lines to your installation.

**!IMPORTANT! This version will most likely contain bugs, so use at your own risk.**

You need to instal 'curl' and run the command below.

- For Ubuntu/Debian: ```sudo apt-get install -y curl```
- For Fedora/CentOS: ```sudo yum install -y curl```

```
curl -sSL https://raw.githubusercontent.com/thenets/Easy-CKAN/dev/install_easyckan.sh | sudo bash
sudo easyckan install
sudo easyckan dev
```
