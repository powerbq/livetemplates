#!/bin/bash

exit 0

dpkg-divert --package im-config --rename /usr/bin/ibus-daemon
