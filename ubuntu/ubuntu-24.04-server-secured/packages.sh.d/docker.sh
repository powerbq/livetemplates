#!/bin/bash

set -e

wget -q https://download.docker.com/linux/ubuntu/gpg -O- > /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

update-alternatives --install /usr/bin/docker-compose docker-compose /usr/libexec/docker/cli-plugins/docker-compose 1
