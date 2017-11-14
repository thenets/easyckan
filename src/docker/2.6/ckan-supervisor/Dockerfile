FROM easyckan/ckan:2.6

# Install supervisor and dependences
RUN apt-get update && apt-get install -y supervisor && \
    apt-get clean all && apt-get autoclean && \
    apt-get autoremove -y

# Create log dir and Set permissions
RUN mkdir -p /var/log/supervisor
RUN chown -R ckan /var/log/supervisor

# Add conf files
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Entrypoint
USER ckan
CMD ["/usr/bin/supervisord"]