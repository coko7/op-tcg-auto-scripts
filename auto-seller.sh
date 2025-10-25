#!/usr/bin/env bash

source "$SCRIPTS/bash-colors.sh"

RARITY_FILTER='rare'
WAIT=13

echo "OP-TCG AutoSeller" | figlet | lolcat

gum spin --title="⬇️ Fetching collection..." -- bash ./fetch-collection.sh > collection.json

echo "✨ Selling $RARITY_FILTER cards:"
jq -c --arg rarity "$RARITY_FILTER" '.data[] |
    select(.rarity == $rarity or .rarity == "common" or .rarity == "uncommon") | .' collection.json \
    | jq -cs 'sort_by(-.quantity)[]' | while read -r card; do

    card_id=$(echo "$card" | jq -r '.card_id')
    name=$(echo "$card" | jq -r '.name')
    rarity=$(echo "$card" | jq -r '.rarity')
    quantity=$(echo "$card" | jq -r '.quantity')

    to_sell=$((quantity - 1))
    echo -e "Selling: ${FG_BLUE}$name ×$to_sell${COL_RESET} $rarity (${FG_RED}$card_id${COL_RESET})"

    gum spin --title="Waiting $WAIT seconds..." -- sleep ${WAIT}s

    res=$(gum spin --title="Selling $to_sell copies..." -- bash ./sell-card.sh "$card_id" "$to_sell")
    success=$(echo "$res" | jq -r '.success')
    if [ "$success" != "true" ]; then
        echo "$res"
        exit 1
    fi
    earned=$(echo "$res" | jq -r '.data.berrys_earned')
    new_balance=$(echo "$res" | jq -r '.data.new_balance')

    echo -e "↳ sold $to_sell copies ${FG_YELLOW}+${earned} 🪙${COL_RESET} => ${FG_YELLOW}$new_balance${COL_RESET} 💰"
done
