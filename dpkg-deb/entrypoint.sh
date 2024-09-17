#!/bin/bash

cd $(dirname $0)

./all.sh

EXITCODE=$?

chown -R --reference=. .

exit $EXITCODE
