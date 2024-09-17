#!/bin/bash

set -e

cd $(dirname $0)

sudo find build -mindepth 3 -maxdepth 3 ! -name 'debootstrap' ! -name 'out' ! -name 'pkg' ! -name 'src' -exec rm -Rfv {} \;

echo "Done $0 $@"
