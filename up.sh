#!/bin/bash

set -e

cd $(dirname $0)

#./prepare.sh
./build.sh arch/plasma

echo Done
