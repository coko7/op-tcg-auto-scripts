#!/usr/bin/env bash

source load-env.sh

curl "$OPBG_HOST/api/users/daily-reward/claim" \
  --silent --compressed -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $BEARER"
