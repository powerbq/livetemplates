#!/bin/bash

set -e

cat /usr/share/oh-my-zsh/templates/zshrc.zsh-template > /etc/skel/.zshrc

sed -i 's|^#DSHELL=.*$|DSHELL=/bin/zsh|' /etc/adduser.conf
