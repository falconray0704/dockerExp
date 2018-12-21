#!/bin/bash

set -o nounset
set -o errexit

redis-server /cfgs/redis.conf

echo "Run following commands for testing"
echo "exec [redis-cli]"
echo "exec [get master ]"

