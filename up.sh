#!/bin/bash

set -e

cd $(dirname $0)

./prepare.sh
./build.sh

echo "Done $0 $@"
