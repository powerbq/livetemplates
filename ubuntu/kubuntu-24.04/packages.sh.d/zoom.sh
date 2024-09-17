#!/bin/bash

dpkg-divert --package im-config --rename /usr/bin/ibus-daemon
