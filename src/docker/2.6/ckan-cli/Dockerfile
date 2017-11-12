FROM easyckan/ckan:2.6

USER root

# Additional tools
RUN apt-get update && \
    apt-get install -y wget curl unzip zip htop fish-dbg libfontconfig && \
    curl -sSL https://deb.nodesource.com/setup_6.x | sh && \
    apt-get install -y nodejs && \
    npm install -g mocha-phantomjs@3.5.0 phantomjs@1.9.8

WORKDIR /usr/lib/ckan

ADD ./.bashrc /usr/lib/ckan/.bashrc
RUN chown 5000.5000 /usr/lib/ckan/.bashrc

USER ckan

#ENTRYPOINT ["bash"]