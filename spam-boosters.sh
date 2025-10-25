#!/usr/bin/env bash

WAIT=25
# PACK_ID=569301 # 16 secret
PACK_ID=569111 # Divine fist - 5 secret

for i in $(seq 1 10); do
    echo "🎁 OPEN #$i >>>"
    bash ./open-booster.sh $PACK_ID
    gum spin --title="Waiting $WAIT seconds..." -- sleep ${WAIT}s
done
