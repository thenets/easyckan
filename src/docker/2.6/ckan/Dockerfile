FROM ubuntu:16.04

# Metadata
LABEL vendor="TheNets.org EasyCKAN"
LABEL org.thenets.easyckan.version="2.6"
LABEL org.thenets.easyckan.release-date="2017-04-06"

# Variables
ENV CKAN_HOME /usr/lib/ckan
ENV CKAN_CONFIG /etc/ckan/default
ENV CKAN_DATA /var/lib/ckan/default
ENV CKAN_VIRTUALENV default

USER root

# Set best mirror for Ubuntu packages
#RUN sed -i -e 's/http:\/\/archive/mirror:\/\/mirrors/' -e 's/\/ubuntu\//\/mirrors.txt/' /etc/apt/sources.list

# Install Ubuntu updates
RUN apt-get update && apt-get upgrade -y

# Create CKAN user
RUN groupadd -r -g 5000 ckan && \
    useradd -mr -c "CKAN User" -d $CKAN_HOME -g 5000 -u 5000 ckan

# Install CKAN dependences
RUN apt-get install -y sudo gcc git-core postgresql-client libpq-dev python-pip \
            python-virtualenv python-dev python-paste libmemcached-dev zlib1g-dev redis-server && \
    apt-get clean all && apt-get autoclean && \
    apt-get autoremove -y

# Create CKAN dirs
RUN mkdir -p $CKAN_CONFIG $CKAN_LOG $CKAN_DATA

# Upgrading Python to 2.7.13
# RUN apt-get install -y build-essential checkinstall  && \
#     apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev && \
#     apt-get autoremove -y && \
#     cd /usr/src && \
#     wget https://www.python.org/ftp/python/2.7.13/Python-2.7.13.tgz && \
#     tar xzf Python-2.7.13.tgz && \
#     cd Python-2.7.13 && \
#     sudo ./configure && \
#     sudo make install

# DEBUG
RUN apt-get install -y links htop nano vim libnet-ifconfig-wrapper-perl 
    apt-get clean all && apt-get autoclean && \
    apt-get autoremove -y

# Add CKAN installer
ADD ./install.sh /
RUN chmod +x ./install.sh

RUN python --version

VOLUME [$CKAN_CONFIG, $CKAN_LOG, $CKAN_DATA]
#ENTRYPOINT ["/entrypoint.sh"]
