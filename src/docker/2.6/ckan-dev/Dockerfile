FROM easyckan/ckan:2.6

# Metadata
LABEL vendor="TheNets.org EasyCKAN"
LABEL org.thenets.easyckan.version="2.6"
LABEL org.thenets.easyckan.release-date="2017-04-06"

USER root
COPY ./entrypoint.sh /
RUN chown ckan.ckan /entrypoint.sh && chmod +x entrypoint.sh


EXPOSE 8983
EXPOSE 5432
EXPOSE 80
EXPOSE 5000

USER root
ENTRYPOINT ["/entrypoint.sh"]