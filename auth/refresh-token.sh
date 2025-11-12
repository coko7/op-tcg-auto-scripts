#!/usr/bin/env bash

source load-env.sh

REFRESH_TOKEN=$(cat data/refresh.secret)

curl "$OPBG_HOST/api/auth/refresh" \
    --compressed --silent -X POST \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $BEARER" \
    --data-raw '{"refreshToken":"'"${REFRESH_TOKEN}"'"'
