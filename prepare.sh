#!/bin/bash

set -e

cd $(dirname $0)

export PATH="$(pwd)/bin:$PATH"


rm -Rf ubuntu/*/debs


if ! which makepkg
then
	echo 'makepkg is missing. install makepkg'

	exit 1
fi

if ! which bsdtar
then
	echo 'bsdtar is missing. install libarchive or libarchive-tools'

	exit 1
fi

cd download-deb && env SRCDEST="$(pwd)/../cache/download-deb" makepkg --nodeps --nobuild && cd ..

mkdir ubuntu/kubuntu-24.04/debs
cp -L download-deb/src/*.deb ubuntu/kubuntu-24.04/debs/
rm -Rf download-deb/src


if ! which dpkg-deb
then
	echo 'dpkg-deb is missing. install dpkg'

	exit 1
fi

cd makepkg-dpkg-deb/aws-cli-v2        && env SRCDEST="$(pwd)/../../cache/makepkg-dpkg-deb/aws-cli-v2"        PKGDEST="$(pwd)/../../ubuntu/kubuntu-24.04/debs"               makepkg -c && cd ../..
cd makepkg-dpkg-deb/composer          && env SRCDEST="$(pwd)/../../cache/makepkg-dpkg-deb/composer"          PKGDEST="$(pwd)/../../ubuntu/kubuntu-24.04/debs"               makepkg -c && cd ../..
cd makepkg-dpkg-deb/phpstorm          && env SRCDEST="$(pwd)/../../cache/makepkg-dpkg-deb/phpstorm"          PKGDEST="$(pwd)/../../ubuntu/kubuntu-24.04/debs"               makepkg -c && cd ../..
cd makepkg-dpkg-deb/pycharm-community && env SRCDEST="$(pwd)/../../cache/makepkg-dpkg-deb/pycharm-community" PKGDEST="$(pwd)/../../ubuntu/kubuntu-24.04/debs"               makepkg -c && cd ../..
cd makepkg-dpkg-deb/telegram-desktop  && env SRCDEST="$(pwd)/../../cache/makepkg-dpkg-deb/telegram-desktop"  PKGDEST="$(pwd)/../../ubuntu/kubuntu-24.04/debs"               makepkg -c && cd ../..

cd makepkg-dpkg-deb/oh-my-zsh         && env SRCDEST="$(pwd)/../../cache/makepkg-dpkg-deb/oh-my-zsh"         PKGDEST="$(pwd)/../../ubuntu/kubuntu-24.04/debs"               makepkg -c && cd ../..
cd makepkg-dpkg-deb/oh-my-zsh         && env SRCDEST="$(pwd)/../../cache/makepkg-dpkg-deb/oh-my-zsh"         PKGDEST="$(pwd)/../../ubuntu/ubuntu-24.04-server-rescue/debs"  makepkg -c && cd ../..
cd makepkg-dpkg-deb/oh-my-zsh         && env SRCDEST="$(pwd)/../../cache/makepkg-dpkg-deb/oh-my-zsh"         PKGDEST="$(pwd)/../../ubuntu/ubuntu-24.04-server-secured/debs" makepkg -c && cd ../..


echo Done
