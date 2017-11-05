FROM debian:latest

RUN usermod --non-unique --uid 1000 www-data
RUN groupmod --non-unique --gid 1000 www-data

RUN echo 'deb http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list \
    && echo 'deb-src http://ftp.fr.debian.org/debian/ jessie non-free' >> /etc/apt/sources.list
RUN apt-get update \
    && apt-get -y install apt-utils apache2 libapache2-mod-fastcgi

RUN rm /etc/apache2/sites-enabled/*

ENV VIRTUALHOST localhost

ADD conf-available /etc/apache2/conf-available
ADD sites-available /etc/apache2/sites-available
ADD ssl /etc/apache2/ssl
#ADD mods-available /etc/apache2/mods-available


ADD apache.sh /usr/bin/apache.sh
RUN chmod +x /usr/bin/apache.sh
ENTRYPOINT apache.sh
