#!/bin/bash
################################################################################################################
# name: docker-entrypoint.sh
# description: this is the entrypoint script for the backend service it is used to init the service.
################################################################################################################

set -e

#TODO: db check and init if something is needed

exec "$@"
