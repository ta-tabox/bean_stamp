#!/bin/bash
set -e

rm -f /beans_app/tmp/pids/server.pid

exec "$@"
