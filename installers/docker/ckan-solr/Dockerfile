FROM solr:5.5.3

# Thanks to 6aika ( https://github.com/6aika/sixodp-solr )

VOLUME ["/opt/solr/server/solr/configsets"]

EXPOSE 8983

COPY ckan_configs /opt/solr/server/solr/configsets/ckan_configs
USER root
RUN chown -R solr:solr /opt/solr/server/solr/configsets/ckan_configs
USER solr

CMD ["/opt/solr/bin/solr", "-f"]
