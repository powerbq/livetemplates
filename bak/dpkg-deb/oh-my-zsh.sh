#!/bin/bash

set -e

umask 022

cd $(dirname $0)

rm -Rf oh-my-zsh/usr/share/oh-my-zsh

git clone https://github.com/ohmyzsh/ohmyzsh.git oh-my-zsh/usr/share/oh-my-zsh

rm -Rf oh-my-zsh/usr/share/oh-my-zsh/.git

sed -i 's|^export ZSH=.*$|export ZSH=/usr/share/oh-my-zsh|' oh-my-zsh/usr/share/oh-my-zsh/templates/zshrc.zsh-template

fakeroot dpkg-deb --build oh-my-zsh
