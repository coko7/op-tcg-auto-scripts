#!/usr/bin/env bash

source load-env.sh

CARD_ID=$1
QUANTITY=$2

if [ -z "$CARD_ID" ]; then
    echo "sell-card.sh: missing CARD_ID"
    exit 1
fi

[[ -z "$QUANTITY" ]] && QUANTITY=1

curl "$OPBG_HOST/api/users/sell-card" \
    --compressed --silent -X POST \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $BEARER" \
    --data-raw '{"cardId":"'"${CARD_ID}"'","quantity":'"$QUANTITY"'}'
