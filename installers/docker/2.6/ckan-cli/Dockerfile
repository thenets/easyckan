FROM easyckan/ckan:2.6

USER root

ADD ./entrypoint.sh /
RUN chown ckan.ckan /entrypoint.sh

USER ckan

WORKDIR /usr/lib/ckan/default

ENTRYPOINT ["bash", "&&", ". bin/activate", "&&", "/entrypoint.sh"]
CMD ["--help"]