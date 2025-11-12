#!/usr/bin/env bash

source load-env.sh

curl --silent "$OPBG_HOST/api/users/achievements" \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $BEARER"
