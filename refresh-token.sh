#!/usr/bin/env bash

BEARER=$(cat ./data/bearer.secret)
REFRESH_TOKEN=$(cat ./data/refresh.secret)

curl 'https://backend-optcg.polo2409.work/api/auth/refresh' \
    --compressed --silent -X POST \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $BEARER" \
    --data-raw '{"refreshToken":"'"${REFRESH_TOKEN}"'"'
