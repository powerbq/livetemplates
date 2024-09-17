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
		sudo find build/$1 -mindepth 1 -maxdepth 1 ! -name 'debootstrap' ! -name 'out' ! -name 'pkg' ! -name 'src' -exec rm -Rf {} \;
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
}

process_end() {
	cd ../../..
}

cd $(dirname $0)

mkdir -p build

for TEMPLATE in arch/* ubuntu/*
do
	if process_skip "$1" $TEMPLATE
	then
		continue
	fi

	if echo $TEMPLATE | grep '^arch/' > /dev/null
	then
		process_start $TEMPLATE livearch
	else
		process_start $TEMPLATE liveubuntu
	fi

	docker-compose build
	docker-compose up
	docker-compose down

	process_end
done

echo "Done $0 $@"
