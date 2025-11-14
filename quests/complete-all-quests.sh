#!/usr/bin/env bash

source load-env.sh

res=$(curl "$OPBG_HOST/api/world/map" \
    --silent \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $BEARER" \
    | jq -r '.activeQuests')

echo "$res" | jq -c '.[]' | while read -r quest; do
    id=$(echo "$quest" | jq -r '.id')
    quest_id=$(echo "$quest" | jq -r '.quest_id')
    echo "Claiming quest: $quest_id ($id)"
    bash quests/complete-quest.sh "$id"
done
