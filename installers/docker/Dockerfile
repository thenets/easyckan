FROM easyckan/ckan:v0.0.2
MAINTAINER Luiz Felipe F M Costa <luiz@thenets.org>

ENV CKAN_DOMAIN localhost
ENV POTSGRESQL_USER $DB_ENV_POSTGRES_USER 
ENV POTSGRESQL_PASS $DB_ENV_POSTGRES_PASS 
ENV POSTGRESQL_IP_PORT $DB_PORT_5432_TCP_ADDR 
ENV POTSGRESQL_DB $DB_ENV_POSTGRES_DB 
ENV SOLR_IP $SOLR_PORT_8983_TCP_ADDR 

# Install dependences
RUN apt-get install -y apt-utils libffi-dev 
RUN apt-get install -y apache2 libapache2-mod-wsgi libapache2-mod-rpaf nginx supervisor

# Update Easy CKAN
CMD ["easyckan","update","dev"]

# Reconfigure environment
CMD ["easyckan","docker"]

# Initialize databases
CMD ["easyckan","create","database"]

# FIX many problems (permissions, security) and Deploy
CMD ["easyckan","fix"]

# Create admin account (user: admin / password: password)
CMD ["easyckan","create","user","admin","password"]

# Volumes
VOLUME ["/etc/ckan/default"]
VOLUME ["/var/lib/ckan"]

EXPOSE 80
