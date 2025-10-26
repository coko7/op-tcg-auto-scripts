#!/usr/bin/env bash

BEARER=$(cat ./data/bearer.secret)
CARD_ID=$1
QUANTITY=$2

if [ -z "$CARD_ID" ]; then
    echo "sell-card.sh: missing CARD_ID"
    exit 1
fi

if [ -z "$QUANTITY" ]; then
    QUANTITY=1
fi

curl 'https://backend-optcg.polo2409.work/api/users/sell-card' \
    --compressed --silent -X POST \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $BEARER" \
    --data-raw '{"cardId":"'"${CARD_ID}"'","quantity":'"$QUANTITY"'}'
