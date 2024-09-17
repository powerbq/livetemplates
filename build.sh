#!/bin/bash

set -e

process_skip() {
	if test -n "$1" && ! test "$1" = $2
	then
		return 0
	fi

	return 1
}

process_start() {
	mkdir -p $(dirname build/$1)

	sudo rm -Rf build/$1.bak

	if test -d build/$1
	then
		sudo find build/$1 -mindepth 1 -maxdepth 1 ! -name 'pkg-*' -exec rm -Rf {} \;
		sudo mv build/$1 build/$1.bak
	fi

	if test "$(git remote get-url origin | cut -d : -f 1)" = 'git@github.com'
	then
		git clone git@github.com:powerbq/$2.git build/$1
	else
		git clone https://github.com/powerbq/$2.git build/$1
	fi

	if test -d build/$1.bak
	then
		sudo cp -a --reflink=auto build/$1.bak/./ build/$1/
		sudo rm -Rf build/$1.bak
	fi

	cd build/$TEMPLATE

	cp -a --reflink=auto ../../../$1/./ ./

	mkdir -p out
	sudo chmod 777 out
	rm -f out/*.log
}

process_end() {
	sudo chmod 755 out

	cd ../../..
}

cd $(dirname $0)

mkdir -p build

if mountpoint build
then
	sudo umount build
fi

sudo mount -o bind,strictatime build build

for TEMPLATE in arch/*
do
	if process_skip "$1" $TEMPLATE
	then
		continue
	fi

	process_start $TEMPLATE livearch

	docker-compose build 2>&1 | sudo tee out/build-init.log > /dev/null
	docker-compose up
	docker-compose logs --no-color --no-log-prefix livearch-boot 2>&1 | sudo tee out/build-boot.log > /dev/null
	docker-compose logs --no-color --no-log-prefix livearch-system 2>&1 | sudo tee out/build-system.log > /dev/null
	docker-compose down

	process_end
done

for TEMPLATE in ubuntu/*
do
	if process_skip "$1" $TEMPLATE
	then
		continue
	fi

	process_start $TEMPLATE liveubuntu

	REF_FILE=.ref

	rm -f $REF_FILE
	touch $REF_FILE

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

	process_end
done

sudo umount build

echo Done
