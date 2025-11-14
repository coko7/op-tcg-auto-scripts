#!/usr/bin/env bash

source load-env.sh

[[ -z "$1" ]] && echo "error: provide ID of quest" && exit 1

curl "$OPBG_HOST/api/world/quests/$1/complete" \
  --silent --compressed -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $BEARER" \
  --data-raw '{}'
