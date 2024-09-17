#!/bin/bash

find /var/lib/rabbitmq -mindepth 1 -maxdepth 1 -exec rm -Rfv {} \;
