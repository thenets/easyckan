FROM easyckan/ckan:2.6

# Install supervisor and dependences
RUN apt-get update && apt-get install -y supervisor

# Create log dir and Set permissions
RUN mkdir -p /var/log/supervisor
RUN chown -R ckan /var/log/supervisor

# Add conf files
COPY supervisord.conf /etc/supervisor/supervisord.conf
#COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
#COPY my_first_process my_first_process
#COPY my_second_process my_second_process

# Entrypoint
USER ckan
CMD ["/usr/bin/supervisord"]