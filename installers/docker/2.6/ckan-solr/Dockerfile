FROM ubuntu:14.04

# Metadata
LABEL vendor="TheNets.org EasyCKAN"
LABEL org.thenets.easyckan.version="2.6"
LABEL org.thenets.easyckan.release-date="2017-04-06"

# Variables
ENV CKAN_BASE_VERSION 2.6
ENV CKAN_HOME /usr/lib/ckan/default
ENV SOLR_HOME /opt/solr/example/solr
ENV SOLR_VERSION 4.10.3
ENV SOLR solr-$SOLR_VERSION

# Install Java
RUN apt-get -q -y update
RUN DEBIAN_FRONTEND=noninteractive apt-get -q -y install default-jre-headless

# Install Solr
RUN mkdir -p /opt/solr
ADD https://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz /opt/$SOLR.tgz
RUN tar zxf /opt/$SOLR.tgz -C /opt/solr --strip-components 1

# Install CKAN Solr core
RUN mv $SOLR_HOME/collection1/ $SOLR_HOME/ckan/
RUN echo name=ckan > $SOLR_HOME/ckan/core.properties
ADD https://raw.githubusercontent.com/ckan/ckan/release-v$CKAN_BASE_VERSION-latest/ckan/config/solr/schema.xml $CKAN_HOME/src/ckan/ckan/config/solr/schema.xml
RUN rm $SOLR_HOME/ckan/conf/schema.xml
RUN ln -s $CKAN_HOME/src/ckan/ckan/config/solr/schema.xml $SOLR_HOME/ckan/conf/schema.xml

EXPOSE 8983
WORKDIR /opt/solr/example
CMD ["java", "-jar", "start.jar"]