#!/bin/bash

set -o nounset
set -o errexit

redis-server /cfgs/redis.conf

echo "Run following commands for testing"
echo "exec [redis-cli]"
echo "exec [set master HelloWorld]"
echo "exec [get master ]"

