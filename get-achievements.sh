#!/usr/bin/env bash

BEARER=$(cat ./data/bearer.secret)

curl --silent 'https://backend-optcg.polo2409.work/api/users/achievements' \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $BEARER"
