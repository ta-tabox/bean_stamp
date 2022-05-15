#!/bin/bash
set -e

rm -f /bean_stamp/tmp/pids/server.pid

exec "$@"
