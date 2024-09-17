#!/bin/bash

if ! test -x /etc/cron.daily/slack
then
	exit 0
fi

/etc/cron.daily/slack

rm -v /etc/cron.daily/slack
