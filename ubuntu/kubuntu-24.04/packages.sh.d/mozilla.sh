#!/bin/bash

apt-get purge -y snapd

add-apt-repository ppa:mozillateam/ppa

apt-get update
apt-get install -y firefox-esr
