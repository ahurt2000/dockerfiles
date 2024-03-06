FROM php:7.4-fpm

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
                          libpcre3-dev

RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl \
                              pdo_mysql \
                              mysqli \
                              zip \
                              calendar \
                              pcntl \
                              bcmath \
                              exif \
                              soap \
                              xmlrpc \
                              bz2

#mcrypt deprecated in 7.2

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

ENV LD_LIBRARY_PATH=/usr/lib/oracle/19.6/
ENV LD_LIBRARY_PATH=/usr/lib/oracle/19.6/client64/lib/:$LD_LIBRARY_PATH

COPY oracle/oracle-instantclient19.6-basic-19.6.0.0.0-1.x86_64.rpm /tmp/oracle-instantclient19.6-basic-19.6.0.0.0-1.x86_64.rpm
COPY oracle/oracle-instantclient19.6-devel-19.6.0.0.0-1.x86_64.rpm /tmp/oracle-instantclient19.6-devel-19.6.0.0.0-1.x86_64.rpm
RUN alien -i /tmp/oracle-instantclient19.6-basic-19.6.0.0.0-1.x86_64.rpm
RUN alien -i /tmp/oracle-instantclient19.6-devel-19.6.0.0.0-1.x86_64.rpm

# [A PECL release compatible with PHP 7 is pending](https://bugs.php.net/bug.php?id=71078)
RUN curl https://pecl.php.net/get/oci8-2.2.0.tgz > /tmp/oci8.tgz \
    && tar -xzvf /tmp/oci8.tgz \
    && mv oci8-2.2.0 /usr/src/php/ext \
    && docker-php-ext-install oci8-2.2.0

#Xdebug
RUN curl https://xdebug.org/files/xdebug-2.9.4.tgz > /tmp/xdebug.tgz \
    && tar -xpzf /tmp/xdebug.tgz \
    && mv xdebug-2.9.4 /usr/src/php/ext \
    && docker-php-ext-install xdebug-2.9.4

#redis
RUN curl https://pecl.php.net/get/redis-3.1.6.tgz > /tmp/redis.tgz \
    && tar -xpzf /tmp/redis.tgz \
    && mv redis-3.1.6 /usr/src/php/ext  \
    && docker-php-ext-install redis-3.1.6


#Stomp for AMPQ
RUN curl https://pecl.php.net/get/stomp-2.0.2.tgz > /tmp/stomp.tgz \
    && tar -xpzf /tmp/stomp.tgz \
    && mv stomp-2.0.2 /usr/src/php/ext \
    && docker-php-ext-install stomp-2.0.2

#LDAP
RUN apt-get update && apt-get install -y libldap-2.4-2 libsasl2-2 libldb-dev libldap2-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install ldap

#Oauth
RUN curl https://pecl.php.net/get/oauth-2.0.5.tgz > /tmp/oauth.tgz \
    && tar -xpzf /tmp/oauth.tgz \
    && mv oauth-2.0.5 /usr/src/php/ext \
    &&  docker-php-ext-install oauth-2.0.5

#MongoDB
RUN curl https://pecl.php.net/get/mongodb-1.3.4.tgz > /tmp/mongo.tgz \
    && tar -xpzf /tmp/mongo.tgz \
    && mv mongodb-1.3.4 /usr/src/php/ext \
    && docker-php-ext-install mongodb-1.3.4

# wkhtmltopdf
#RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.2.1/#wkhtmltox-0.12.2.1_linux-jessie-amd64.deb \
#    && apt-get -y install xfonts-base xfonts-75dpi xfonts-utils fontconfig libxext6 libfontconfig1 libjpeg62-turbo libx11-6 libxrender1 \
#    && dpkg -i wkhtmltox-0.12.2.1_linux-jessie-amd64.deb \
#    && rm wkhtmltox-0.12.2.1_linux-jessie-amd64.deb


# Install composer, this needs to be two steps to ensure we get the latest version
ADD http://getcomposer.org/installer /tmp/installer
RUN php /tmp/installer --install-dir=/usr/local/bin && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

ADD conf/30-custom.ini /usr/local/etc/php/conf.d/30-custom.ini

RUN apt-get -y install locales

# Set the locale
RUN locale-gen es_ES.utf8
ENV LANG es_ES.UTF-8
ENV LANGUAGE es_ES
#ENV LC_ALL es_ES.utf8

RUN apt-get -y purge

#ENTRYPOINT php-fpm --nodaemonize
