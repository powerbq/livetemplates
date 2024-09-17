#!/bin/sh

echo Booting

symfony server:ca:install

shutdown() {
	symfony proxy:stop

	touch /tmp/.shutdown
}

trap 'shutdown' 1 2 3 15

symfony proxy:start

echo Working

while true
do
	if test -f /tmp/.shutdown
	then
		rm /tmp/.shutdown

		break
	fi

	sleep 1
done

echo Stopped
