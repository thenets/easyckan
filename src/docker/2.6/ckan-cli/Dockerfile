FROM easyckan/ckan:2.6

USER root

# Additional tools
RUN apt-get update && \
    apt-get install -y wget unzip zip htop fish-dbg

WORKDIR /usr/lib/ckan

ADD ./.bashrc /usr/lib/ckan/.bashrc
RUN chown 5000.5000 /usr/lib/ckan/.bashrc

USER ckan

#ENTRYPOINT ["bash"]