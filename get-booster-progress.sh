#!/usr/bin/env bash

all_achievements=$(bash get-achievements.sh)

[ -z "$1" ] && echo "error: expects a booster ID to be passed" && exit 1

echo "$all_achievements" | jq --arg bid "$1" --raw-output \
    '.data[]
    | select(.booster_id == $bid and .reward_berrys == 1000)
    | "\(.booster_id) - \(.name): \(.progress) / \(.threshold)"'
