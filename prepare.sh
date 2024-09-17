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

mkdir ubuntu/kubuntu-24.04-nodev/debs
cp -L download-deb/src/google-chrome-stable_*.deb ubuntu/kubuntu-24.04-nodev/debs/

rm -Rf download-deb/src


if ! which dpkg-deb
then
	echo 'dpkg-deb is missing. install dpkg'

	exit 1
fi

run() {
	cd makepkg-dpkg-deb/$1

	env SRCDEST="$(pwd)/../../cache/makepkg-dpkg-deb/$1" PKGDEST="$(pwd)/../../ubuntu/$2/debs" makepkg -c

	cd ../..
}

run aws-cli-v2         kubuntu-24.04
run composer           kubuntu-24.04
run phpstorm           kubuntu-24.04
run pycharm-community  kubuntu-24.04
run telegram-desktop   kubuntu-24.04
run oh-my-zsh          kubuntu-24.04

run oh-my-zsh          ubuntu-24.04-server-rescue

run oh-my-zsh          ubuntu-24.04-server-secured

run oh-my-zsh          ubuntu-24.04-server-nas

echo Done
