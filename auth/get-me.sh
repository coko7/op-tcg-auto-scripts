#!/usr/bin/env bash

source load-env.sh

curl --silent "$OPBG_HOST/api/auth/me" \
    --header "Authorization: Bearer $BEARER"

