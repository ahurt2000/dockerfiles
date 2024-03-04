FROM php:8.2-fpm

RUN usermod --non-unique --uid 1000 www-data
RUN groupmod --non-unique --gid 1000 www-data

RUN mkdir -p /usr/src/php/ext

RUN apt-get -qq update \
    && apt-get install -y apt-utils \
                          xmlsec1 \
                          git \
                          unzip \
                          vim \
                          wget \
                          libzip-dev \
                          libicu-dev \
                          g++ \
                          libmcrypt-dev \
                          libxml2-dev \
                          libbz2-dev \
                          libcurl4 \
                          libcurl4-gnutls-dev \
                          libssl-dev \
                          libgmp-dev \
                          libpcre3-dev\
                          libpq-dev

RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl \
                              zip \
                              calendar \
                              pcntl \
                              bcmath \
                              gmp \
                              exif \
                              soap \
                              bz2


#mysql
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

#postgres
#RUN docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql && docker-php-ext-install pdo pdo_pgsql pgsql

#GD
RUN apt-get update && apt-get install -y libvpx-dev libjpeg-dev libxpm-dev libpng-dev libfreetype6 libfreetype6-dev
RUN docker-php-ext-configure gd --with-jpeg=/usr/include/ --with-freetype=/usr/include/
RUN docker-php-ext-install gd

#xsl
RUN apt-get update && apt-get install -y libxslt1-dev \
    && docker-php-ext-configure xsl \
    && docker-php-ext-install xsl

##############################
# Oracle InstantClient && OCI8
##############################

RUN apt-get update -yqq && \
   apt-get -y install build-essential libaio1 alien

ENV LD_LIBRARY_PATH=/usr/lib/oracle/12.1/
ENV LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib/:$LD_LIBRARY_PATH

COPY oracle/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb /tmp/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
COPY oracle/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb /tmp/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb

# [A PECL release compatible with PHP 7 is pending](https://bugs.php.net/bug.php?id=71078)
RUN curl https://pecl.php.net/get/oci8-3.3.0.tgz > /tmp/oci8.tgz \
   && tar -xzvf /tmp/oci8.tgz \
   && mv oci8-3.3.0 /usr/src/php/ext \
   && docker-php-ext-install oci8-3.3.0

#Xdebug
RUN curl https://pecl.php.net/get/xdebug-3.3.1.tgz > /tmp/xdebug.tgz \
    && tar -xpzf /tmp/xdebug.tgz \
    && mv xdebug-3.3.1 /usr/src/php/ext \
    && docker-php-ext-install xdebug-3.3.1

#redis
RUN curl https://pecl.php.net/get/redis-5.3.6.tgz > /tmp/redis.tgz \
    && tar -xpzf /tmp/redis.tgz \
    && mv redis-5.3.6 /usr/src/php/ext  \
    && docker-php-ext-install redis-5.3.6


#Stomp for AMPQ
#RUN curl https://pecl.php.net/get/stomp-2.0.2.tgz > /tmp/stomp.tgz \
#    && tar -xpzf /tmp/stomp.tgz \
#    && mv stomp-2.0.2 /usr/src/php/ext \
#    && docker-php-ext-install stomp-2.0.2

#LDAP
#RUN apt-get update && apt-get install -y libldap-2.4-2 libsasl2-2 libldb-dev libldap2-dev \
#    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
#    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
#    && docker-php-ext-configure ldap \
#    && docker-php-ext-install ldap

#Oauth
RUN curl https://pecl.php.net/get/oauth-2.0.7.tgz > /tmp/oauth.tgz \
    && tar -xpzf /tmp/oauth.tgz \
    && mv oauth-2.0.7 /usr/src/php/ext \
    &&  docker-php-ext-install oauth-2.0.7

#MongoDB
#RUN curl https://pecl.php.net/get/mongodb-1.3.4.tgz > /tmp/mongo.tgz \
#    && tar -xpzf /tmp/mongo.tgz \
#    && mv mongodb-1.3.4 /usr/src/php/ext \
#    && docker-php-ext-install mongodb-1.3.4


# Install composer, this needs to be two steps to ensure we get the latest version
ADD http://getcomposer.org/installer /tmp/installer
RUN php /tmp/installer --install-dir=/usr/local/bin && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

#ADD conf/30-custom.ini /usr/local/etc/php/conf.d/30-custom.ini

RUN apt-get -y install locales

# Set the locale
RUN locale-gen es_ES.utf8
ENV LANG es_ES.UTF-8
ENV LANGUAGE es_ES
#ENV LC_ALL es_ES.utf8

RUN apt-get -y purge

#ENTRYPOINT php-fpm --nodaemonize
