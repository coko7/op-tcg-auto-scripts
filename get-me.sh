#!/usr/bin/env bash

BEARER=$(cat ./data/bearer.secret)

curlie --silent 'https://backend-optcg.polo2409.work/api/auth/me' \
    -H "Authorization: Bearer $BEARER"

