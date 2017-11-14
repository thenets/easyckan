FROM easyckan/ckan:2.6

# Apache + WSGI module
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-wsgi libapache2-mod-rpaf

# PageSpeed module
RUN apt-get install -y wget && \
    wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb && \
    dpkg -i mod-pagespeed-stable_current_amd64.deb && \
    rm -f mod-pagespeed-stable_current_amd64.deb

# Clean image
RUN apt-get remove -y wget curl links htop nano vim libnet-ifconfig-wrapper-perl redis-server gcc git-core postgresql-client && \
    apt-get clean all && apt-get autoclean && \
    apt-get autoremove -y
RUN rm -f /usr/lib/ckan/.bashrc /install.sh

# Setup WSGI
ADD ./easyckan.conf /etc/apache2/sites-available/easyckan.conf
ADD ./easyckan.wsgi /etc/apache2/easyckan.wsgi
RUN rm -f /etc/apache2/sites-enabled/* && a2ensite easyckan && \
    echo '' > /etc/apache2/ports.conf && \
    chown 5000.5000 -R /var/log/apache2/ /var/run/apache2/ /etc/apache2/ /var/cache/mod_pagespeed/ /var/log/pagespeed/

USER ckan
WORKDIR /usr/lib/ckan

ADD /entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]