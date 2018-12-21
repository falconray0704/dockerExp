#!/bin/bash

set -o nounset
set -o errexit

set -x

cd /usr/local/sbin
cp haproxy.cfg.org haproxy.cfg
#haproxy haproxy-systemd-wrapper haproxy.cfg
haproxy -f haproxy.cfg

