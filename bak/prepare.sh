#!/bin/bash

set -e

cd $(dirname $0)

for TEMPLATE in ubuntu/*
do
	cd $TEMPLATE
	if ! test -f debs/urls.txt
	then
		cd ../..

		continue
	fi

	cd debs

	rm -f *.deb
	for ROW in $(cat urls.txt)
	do
		URL=$(echo $ROW | cut -d '|' -f 1)
		FILENAME=$(echo $ROW | cut -d '|' -f 2)
		curl -L $URL > $FILENAME
	done

	cd ..

	cd ../..
done

cd dpkg-deb

for PKG in composer oh-my-zsh telegram-desktop
do
	./$PKG.sh
done

cp --reflink=auto composer.deb ../ubuntu/kubuntu-24.04/debs/
cp --reflink=auto oh-my-zsh.deb ../ubuntu/kubuntu-24.04/debs/
cp --reflink=auto telegram-desktop.deb ../ubuntu/kubuntu-24.04/debs/

cp --reflink=auto oh-my-zsh.deb ../ubuntu/ubuntu-24.04-nas/debs/
cp --reflink=auto oh-my-zsh.deb ../ubuntu/ubuntu-24.04-server/debs/
cp --reflink=auto oh-my-zsh.deb ../ubuntu/ubuntu-24.04-vm/debs/

cd ..

echo Done