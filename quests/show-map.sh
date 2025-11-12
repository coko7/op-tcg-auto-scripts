#!/usr/bin/env bash

jq -cr '.islands[].quests[]' data/map.json | while read -r quest; do
    island=$(echo "$quest" | jq -r '.island_id')
    quest_name=$(echo "$quest" | jq -r '.name')
    duration=$(echo "$quest" | jq '.duration_hours')
    reward=$(echo "$quest" | jq '.reward_berrys')
    members=$(echo "$quest" | jq '.required_crew_count')

    ratio=$((reward / (duration * members)))
    echo "$ratio => ${duration} ⏱️ / $reward 💰 / $members 🧑 ($island:$quest_name)"
done
