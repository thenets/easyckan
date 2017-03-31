FROM ubuntu:16.04
MAINTAINER luiz@thenets.org


ENV CKAN_VERSION=2.6.0              \
    CKAN_HOME=/usr/lib/ckan         \
    CKAN_CONFIG=/etc/ckan/default   \
    CKAN_VIRTUALENV=default         \
    CKAN_DATA=/var/data/ckan        \
    CKAN_LOG=/var/log/ckan          \
    SETUP_TOOLS_VERSION=18.5        \
    HTML5LIB_VERSION=0.999

USER root

RUN groupadd -r -g 5000 ckan && \
    useradd -mr -c "CKAN User" -d $CKAN_HOME -g 5000 -u 5000 ckan && \
    apt-get update && apt-get upgrade -y && \
    apt-get install gcc git-core postgresql-client libpq-dev python-pip python-virtualenv python-dev -y && \
    apt-get clean all && apt-get autoclean && \
    pip install --force-reinstall --upgrade pip PasteDeploy PasteScript setuptools testrepository psycopg2 bleach && \
    mkdir -p $CKAN_CONFIG $CKAN_LOG $CKAN_DATA

USER ckan

WORKDIR /usr/lib/ckan

RUN virtualenv default && \
    . default/bin/activate && \
    pip install --upgrade pip && \
    pip install --upgrade PasteDeploy && \
    pip install --upgrade PasteScript && \
    pip install setuptools==$SETUP_TOOLS_VERSION && \
    pip install html5lib==$HTML5LIB_VERSION && \
    pip install --upgrade testrepository && \
    pip install --upgrade psycopg2 && \
    pip install --upgrade bleach && \
    deactivate

RUN virtualenv default && \
    . default/bin/activate && \
    pip install -e "git+https://github.com/ckan/ckan.git@ckan-$CKAN_VERSION#egg=ckan" && \
    pip install -r default/src/ckan/pip-requirements-docs.txt && \
    deactivate

VOLUME ["/etc/ckan", "/var/log/ckan", "/var/data/ckan", "/usr/lib/ckan/default/src"]

EXPOSE 5000


# FIX for CKAN 2.6.0
USER root
RUN apt-get install -y libmemcached-dev zlib1g-dev
USER ckan
RUN virtualenv default && \
    . default/bin/activate && \
    pip install setuptools==20.4


# DEBUG
USER root
RUN sed -i 's/archive.ubuntu.com/br.archive.ubuntu.com/g' /etc/apt/sources.list && cat /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y nano htop

# Reset permissions
USER root
RUN chown -R ckan.ckan /etc/ckan && \
    chown -R ckan.ckan /usr/lib/ckan

# Create entrypoint
USER root
COPY ./FILES/ckan-entrypoint.sh /
COPY ./FILES/entrypoint.sh /
RUN chmod +x $CKAN_HOME /ckan-entrypoint.sh && \
    chown -R ckan.ckan $CKAN_HOME $CKAN_CONFIG $CKAN_LOG $CKAN_DATA /ckan-entrypoint.sh


USER root
ENTRYPOINT ["/entrypoint.sh"]
