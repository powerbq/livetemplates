#!/bin/bash

add-apt-repository ppa:xtradeb/apps

apt-get update

apt-get install -y pinta ungoogled-chromium

add-apt-repository -r ppa:xtradeb/apps
