#!/bin/bash

set -e

cd $(dirname $0)

./oh-my-zsh.sh
./composer.sh
./telegram-desktop.sh

chown -R --reference=. .
