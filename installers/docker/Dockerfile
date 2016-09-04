FROM easyckan/ckan:v0.0.2
MAINTAINER Luiz Felipe F M Costa <luiz@thenets.org>

# Update Easy CKAN
RUN easyckan update dev

# Variables
ENV CKAN_DOMAIN localhost

# Create configuration file
RUN mkdir -p /etc/ckan/default
RUN chown -R ckan.ckan /etc/ckan
RUN su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && paster make-config ckan /etc/ckan/default/development.ini"

# Set domain
RUN sed -i "s/ckan.site_url =/ckan.site_url = http:\/\/$CKAN_DOMAIN/g" /etc/ckan/default/development.ini

# PostgreSQL
RUN sed -i "s/ckan_default:pass@localhost\/ckan_default/$DB_ENV_POSTGRES_USER:$DB_ENV_POSTGRES_PASS@$DB_PORT_5432_TCP_ADDR\/$DB_ENV_POSTGRES_DB/g" /etc/ckan/default/development.ini
RUN chown ckan.33 -R /etc/ckan/default

# Solr
RUN sed -i "s/#solr_url/solr_url/g" /etc/ckan/default/development.ini
RUN sed -i "s/127.0.0.1:8983\/solr/$SOLR_PORT_8983_TCP_ADDR:8983\/solr\/ckan/g" /etc/ckan/default/development.ini

# Setup storage path for upload support
RUN mkdir -p /var/lib/ckan
RUN chown -R ckan.33 /var/lib/ckan
RUN sed -i 's/#ckan.storage_path/ckan.storage_path/g' /etc/ckan/default/development.ini

# Set DEBUB mode
RUN sed -i 's/debug = false/debug = true/g' /etc/ckan/default/development.ini

# Copy "who.ini" file
RUN ln -s /usr/lib/ckan/default/src/ckan/who.ini /etc/ckan/default/who.ini

# Initialize databases
RUN su -s /bin/bash - ckan -c ". /usr/lib/ckan/default/bin/activate && cd /usr/lib/ckan/default/src/ckan && paster db init -c /etc/ckan/default/development.ini"

# FIX many problems (permissions, security)
RUN easyckan fix

# Volumes
VOLUME ["/etc/ckan/default"]
VOLUME ["/var/lib/ckan"]

EXPOSE 80