#!/usr/bin/env bash

source load-env.sh

[[ -z "$1" ]] && echo "error: provide boosterId" && exit 1

curl "$OPBG_HOST/api/users/open-booster" \
  --silent --compressed -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $BEARER" \
  --data-raw '{"boosterId":"'"$1"'"}'
