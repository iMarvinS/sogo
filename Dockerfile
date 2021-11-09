FROM debian:buster

RUN apt-get update -qq && \
    apt-get install -yq --no-install-recommends apt-transport-https ca-certificates dirmngr gnupg2 && \
    mkdir ~/.gnupg && \
    echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf && \
    gpg --keyserver keyserver.ubuntu.com --recv 19CDA6A9810273C4 && \
    gpg --export --armor 19CDA6A9810273C4 | apt-key add - && \
    echo "deb https://packages.inverse.ca/SOGo/nightly/5/debian/ buster buster" > /etc/apt/sources.list.d/SOGo.list && \
    apt-get update -qq && \
    apt-get install -yq --no-install-recommends sogo=5.2.0* sope4.9-gdl1-postgresql sope4.9-gdl1-mysql supervisor memcached apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    a2enmod headers proxy proxy_http rewrite ssl && \
    usermod --home /srv/lib/sogo sogo && \
    mkdir -p /var/run/memcached/ && \
    chown memcache:memcache /var/run/memcached

EXPOSE 80 443

COPY etc /etc

CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
