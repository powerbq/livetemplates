#!/bin/bash

#exit 0

add-apt-repository ppa:ondrej/php

apt-get update

#PHP_VERSION=8.2
#PHP_VERSION=8.3
PHP_VERSION=8.4

# for symfony cli
apt-get install -y php$PHP_VERSION-fpm

# for phpstan
apt-get install -y php$PHP_VERSION-xml

# other
apt-get install -y php$PHP_VERSION-amqp php$PHP_VERSION-curl php$PHP_VERSION-gd php$PHP_VERSION-imap php$PHP_VERSION-mailparse php$PHP_VERSION-mysqli php$PHP_VERSION-redis php$PHP_VERSION-soap php$PHP_VERSION-sqlite3 php$PHP_VERSION-zip

# pgsql
apt-get install -y php$PHP_VERSION-pgsql

# intl
apt-get install -y php$PHP_VERSION-intl

# xdebug
apt-get install -y php$PHP_VERSION-xdebug

# pecl
apt-get install -y php$PHP_VERSION-dev

# apcu
apt-get install -y php$PHP_VERSION-apcu

# event
apt-get install -y libevent-dev
pecl -d php_suffix=$PVP_VERSION install event
echo '; priority=90' > /etc/php/$PHP_VERSION/mods-available/event.ini
echo 'extension=event.so' >> /etc/php/$PHP_VERSION/mods-available/event.ini
phpenmod -v $PHP_VERSION event
