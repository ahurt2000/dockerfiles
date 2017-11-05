#! /bin/bash

a2enmod proxy
a2enmod proxy_fcgi
a2enmod rewrite
a2enmod ssl
a2enmod env
a2enconf servername
a2ensite 000-default

/usr/sbin/apache2ctl -D FOREGROUND
