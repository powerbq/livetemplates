#!/bin/bash

find /var/lib/postgresql/16/main -mindepth 1 -maxdepth 1 -exec rm -Rfv {} \;

sed -i 's/^port = [0-9]*/port = 5432/' /etc/postgresql/16/main/postgresql.conf
