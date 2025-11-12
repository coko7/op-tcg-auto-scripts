#!/usr/bin/env bash

source load-env.sh

curl --silent "$OPBG_HOST/api/users/collection" \
  -H "Authorization: Bearer $BEARER"
