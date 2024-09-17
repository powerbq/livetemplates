#!/bin/bash

set -e

umask 022

cd $(dirname $0)

cd telegram-desktop

rm -Rf usr/share/telegram-desktop
mkdir -p usr/share/telegram-desktop

cd usr/share/telegram-desktop

URL=https://telegram.org/dl/desktop/linux

curl -L $URL | xz -d  | tar -xp -f - --strip-components=1

cd ../../..

pkgver() {
	curl -D - $URL | grep -P '^location: ' | awk -F 'location: ' '{print $2}' | tr -d '\r\n' | xargs -rn1 basename | sed -r 's/^tsetup\.(.*)\.tar\.xz$/\1/'
}

sed -i "s/^Version: .*\$/Version: $(pkgver)/" DEBIAN/control

cd ..

fakeroot dpkg-deb --build telegram-desktop
