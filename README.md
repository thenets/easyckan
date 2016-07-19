# Easy-CKAN
Easiest way to install CKAN platform.


## Requeriments
Pay attention if you have the follow requeriments.

- Ubuntu 14.04


## How to Install
Just run the following lines on your server:

```
sudo su -c "apt-get install git-core"
sudo su -c "cd /tmp && rm -rf ./Easy-CKAN && git clone https://github.com/thenets/Easy-CKAN.git && cd ./Easy-CKAN && ./ckan_installer.sh"
```

## Have questions?
Just let me know here, on "Issues", or send me an email: luiz@thenets.org


## For future
I want to add some additional features:

- Support to Ubuntu 16.04
- More plugins
- Better bash interface
