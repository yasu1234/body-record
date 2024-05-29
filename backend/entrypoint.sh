#!/bin/bash
set -e

rm -f /${WORKDIR}/tmp/pids/server.pid

rails db:create
rails db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
