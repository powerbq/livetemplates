#!/bin/bash

set -e

cd $(dirname $0)

mkdir -p build

if mountpoint build
then
	sudo umount build
fi

sudo mount -o bind,strictatime build build

for TEMPLATE in ubuntu/*
do
	if test -n "$1" && ! test "$1" = $TEMPLATE
	then
		continue
	fi

	mkdir -p $(dirname build/$TEMPLATE)

	sudo rm -Rf build/$TEMPLATE.bak

	if test -d build/$TEMPLATE
	then
		sudo find build/$TEMPLATE -mindepth 1 -maxdepth 1 ! -name 'pkg-*' -exec rm -Rf {} \;
		sudo mv build/$TEMPLATE build/$TEMPLATE.bak
	fi

	if test "$(git remote get-url origin | cut -d : -f 1)" = 'git@github.com'
	then
		git clone git@github.com:powerbq/liveubuntu.git build/$TEMPLATE
	else
		git clone https://github.com/powerbq/liveubuntu.git build/$TEMPLATE
	fi

	if test -d build/$TEMPLATE.bak
	then
		sudo cp -a --reflink=auto build/$TEMPLATE.bak/./ build/$TEMPLATE/
		sudo rm -Rf build/$TEMPLATE.bak
	fi

	cd build/$TEMPLATE

	cp -a --reflink=auto ../../../$TEMPLATE/./ ./

	REF_FILE=.ref

	rm -f $REF_FILE
	touch $REF_FILE

	mkdir -p out
	sudo chmod 777 out
	rm -f out/*.log

	./base.sh 2>&1 | tee out/build-base.log

	docker-compose build 2>&1 | tee out/build-init.log
	docker-compose up
	docker-compose logs ubuntu --no-color --no-log-prefix > out/build-ubuntu.log 2>&1
	docker-compose down

	(
	sudo find pkg-debootstrap -mindepth 1 -maxdepth 1 -not -neweraa $REF_FILE -exec rm -Rfv {} \;
	sudo find pkg-system -mindepth 1 -maxdepth 1 -not -neweraa $REF_FILE -exec rm -Rfv {} \;
	sudo rm -Rfv pkg-system/partial
	sudo rm -fv pkg-system/lock
	) 2>&1 | tee out/build-cleanup.log

	sudo chmod 755 out

	cd ../../..
done

sudo umount build

echo Done
