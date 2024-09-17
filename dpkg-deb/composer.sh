#!/bin/bash

set -e

umask 022

if ! which php
then
	sudo apt-get update
	sudo apt-get install -y php
fi

cd $(dirname $0)

COMPOSER_VERSION=2.7.6

if ! test -x composer/usr/bin/composer
then
	mkdir -p composer/usr/bin
	curl -L https://getcomposer.org/download/$COMPOSER_VERSION/composer.phar > composer/usr/bin/composer
	cat composer/usr/bin/composer | sha256sum | grep "$(curl -L https://getcomposer.org/download/$COMPOSER_VERSION/composer.phar.sha256sum | awk '{print $1}')  -"
	chmod 755 composer/usr/bin/composer
fi

COMPOSER_VERSION=$(composer/usr/bin/composer self-update 2>&1 | grep -Po ' version .+' | awk '{print $2}' | head -n 1)

sed -i "s/^Version: .*\$/Version: $COMPOSER_VERSION/" composer/DEBIAN/control

fakeroot dpkg-deb --build composer
