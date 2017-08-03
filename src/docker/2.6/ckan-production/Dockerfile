FROM easyckan/ckan:2.6

# Apache + WSGI module
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-wsgi libapache2-mod-rpaf

# PageSpeed module
RUN apt-get install -y wget && \
    wget https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb && \
    dpkg -i mod-pagespeed-stable_current_amd64.deb && \
    rm -f mod-pagespeed-stable_current_amd64.deb

# Clean container
# RUN apt-get remove -y wget links htop nano vim libnet-ifconfig-wrapper-perl redis-server gcc git-core postgresql-client && \
#     apt-get clean all && apt-get autoclean && \
#     apt-get autoremove -y
RUN rm -f /usr/lib/ckan/.bashrc /install.sh

# Install Ubuntu updates (security reasons)
# RUN apt-get update && apt-get upgrade -y

# USER ckan
# WORKDIR /usr/lib/ckan

ADD ./ckan-entrypoint.sh /ckan-entrypoint.sh
CMD ["ckan-entrypoint.sh"]