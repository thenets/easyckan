# Easy-CKAN
Easiest way to install CKAN platform.


## 1. Requirements
Pay attention if you have the follow requirements.

- Ubuntu 14.04


## 2. How to Install
Just run the following lines on your server:

```
sudo su -c "apt-get install git-core"
sudo su -c "cd /tmp && rm -rf ./Easy-CKAN && git clone https://github.com/thenets/Easy-CKAN.git && cd ./Easy-CKAN && ./ckan_installer.sh"
```

## 3. How to use (helpers)
The Easy CKAN create the "helpers". The best way to interact with your CKAN installation.

### 3.1. Server Helper (development mode)
Just run the following command as root:

`# /root/easy_ckan/server.sh`


## 4. Have questions?
Just let me know here, on "Issues", or send me an email: luiz@thenets.org


## For future
I want to add some additional features:

- Support to Ubuntu 16.04
- More plugins
- Better bash interface



## Developer installer
If you want the lastest Easy CKAN version, use following lines to your installation.
!IMPORTANT! Probably you will find some bugs. This is just for developers.

```
sudo su -c "apt-get install git-core"
sudo su -c "cd /tmp && rm -rf ./Easy-CKAN && git clone -v dev https://github.com/thenets/Easy-CKAN.git && cd ./Easy-CKAN && ./easy_ckan.sh"
```