#!/bin/bash

set -e

cd $(dirname $0)

git clone $(git remote get-url origin) new

find . -mindepth 1 -maxdepth 1 ! -name build ! -name new ! -name $(basename $0) -exec rm -Rf {} \;

mv new/.git .git

rm -Rf new

git reset --hard

echo Done
