FROM php:5.6.40-fpm

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

RUN usermod --non-unique --uid 1000 www-data
RUN groupmod --non-unique --gid 1000 www-data

RUN mkdir -p /usr/src/php/ext

RUN apt-get update \
    && apt-get install -y xmlsec1 \
                          git \
                          unzip \
                          vim \
                          wget \
                          zlib1g-dev \
                          libicu-dev \
                          g++ \
                          libmcrypt-dev \
                          libxml2-dev \
                          libbz2-dev \
                          libcurl3 \
                          libcurl4-gnutls-dev

RUN docker-php-ext-configure intl \
    && docker-php-ext-install intl \
                              mbstring \
                              pdo_mysql \
                              mcrypt \
                              mysql \
                              mysqli \
                              zip \
                              calendar \
                              pcntl \
                              bcmath \
                              exif \
                              soap \
                              xmlrpc \
                              bz2
#GD
RUN apt-get update && apt-get install -y libvpx-dev libjpeg-dev libxpm-dev  libfreetype6 libfreetype6-dev
RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/
RUN docker-php-ext-install gd

#xsl
RUN apt-get update && apt-get install -y libxslt1-dev
RUN docker-php-ext-configure xsl --with-jpeg-dir=/usr/include/ --with-freetype-dir=/usr/include/
RUN docker-php-ext-install xsl

#Xdebug
RUN curl https://xdebug.org/files/xdebug-2.4.1.tgz > /tmp/xdebug.tgz \
    && tar -xpzf /tmp/xdebug.tgz \
    && mv xdebug-2.4.1 /usr/src/php/ext \
    && docker-php-ext-install xdebug-2.4.1

#Oracle
#RUN apt-get update
RUN apt-get -y install build-essential libaio1
COPY oracle/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb /tmp/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
COPY oracle/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb /tmp/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-basic_12.1.0.2.0-2_amd64.deb
RUN dpkg -i /tmp/oracle-instantclient12.1-devel_12.1.0.2.0-2_amd64.deb

# Oracle oci8
RUN curl https://pecl.php.net/get/oci8-2.0.8.tgz > /tmp/oci8.tgz \
    && tar -xzvf /tmp/oci8.tgz \
    && mv oci8-2.0.8 /usr/src/php/ext \
    && docker-php-ext-install oci8-2.0.8

#redis
RUN curl https://pecl.php.net/get/redis-2.2.8.tgz > /tmp/redis.tgz \
    && tar -xpzf /tmp/redis.tgz \
    && mv redis-2.2.8 /usr/src/php/ext  \
    && docker-php-ext-install redis-2.2.8

#Stomp for AMPQ
RUN curl https://pecl.php.net/get/stomp-1.0.9.tgz > /tmp/stomp.tgz \
    && tar -xpzf /tmp/stomp.tgz \
    && mv stomp-1.0.9 /usr/src/php/ext \
    && docker-php-ext-install stomp-1.0.9

#LDAP
RUN apt-get update && apt-get install -y libldap-2.4-2 libsasl2-2 libldb-dev libldap2-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
    && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
    && docker-php-ext-configure ldap \
    && docker-php-ext-install ldap

#Oauth
RUN curl https://pecl.php.net/get/oauth-1.2.3.tgz > /tmp/oauth.tgz \
    && tar -xpzf /tmp/oauth.tgz \
    && mv oauth-1.2.3 /usr/src/php/ext \
    &&  docker-php-ext-install oauth-1.2.3

#MongoDB
RUN curl https://pecl.php.net/get/mongo-1.5.8.tgz > /tmp/mongo.tgz \
    && tar -xpzf /tmp/mongo.tgz \
    && mv mongo-1.5.8 /usr/src/php/ext \
    && docker-php-ext-install mongo-1.5.8

# wkhtmltopdf
#RUN wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2.1/wkhtmltox-0.12.2.1_linux-jessie-amd64.deb \
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.2.1/wkhtmltox-0.12.2.1_linux-jessie-amd64.deb
RUN apt-get -y install xfonts-base xfonts-75dpi xfonts-utils fontconfig libxext6 libfontconfig1 libjpeg62-turbo libx11-6 libxrender1 

RUN apt autoremove libpng-dev -y
RUN apt purge libpng-dev -y

RUN wget https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/15108504/+files/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
RUN dpkg -i libpng12-0_1.2.54-1ubuntu1.1_amd64.deb

RUN wget http://archive.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb
RUN dpkg -i libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb

RUN dpkg -i wkhtmltox-0.12.2.1_linux-jessie-amd64.deb
RUN rm wkhtmltox-0.12.2.1_linux-jessie-amd64.deb
   

# Install composer, this needs to be two steps to ensure we get the latest version
ADD http://getcomposer.org/installer /tmp/installer
RUN php /tmp/installer --install-dir=/usr/local/bin && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

ADD conf/30-custom.ini /usr/local/etc/php/conf.d/30-custom.ini

RUN apt-get -y install locales
# Set the locale
RUN locale-gen es_ES.utf8
ENV LANG es_ES.utf8
ENV LANGUAGE es_ES:fr
ENV LC_ALL es_ES.utf8

RUN apt-get -y purge

#ENTRYPOINT php-fpm --nodaemonize
