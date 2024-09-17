#!/bin/bash

if test -f /usr/share/oh-my-zsh/templates/zshrc.zsh-template
then
	cat /usr/share/oh-my-zsh/templates/zshrc.zsh-template > /etc/skel/.zshrc
fi

if which zsh
then
	sed -i 's|^#DSHELL=.*$|DSHELL=/bin/zsh|' /etc/adduser.conf
fi
