#!/usr/bin/env bash

source load-env.sh

curl "$OPBG_HOST/api/world/map" \
    --silent \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $BEARER" \
    | jq -r '.activeQuests[] | "\(.quest_id) \(.completes_at)"'
