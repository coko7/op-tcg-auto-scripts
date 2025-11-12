#!/usr/bin/env bash

set -a # automatically export all variables
source .env
set +a

BEARER=$(cat data/bearer.secret)
export BEARER
