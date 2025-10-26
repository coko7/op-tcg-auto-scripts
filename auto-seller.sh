#!/usr/bin/env bash

# antiCheatMiddleware('sell_card', { maxPerMinute: 20, maxPerHour: 200, minDelay: 500 }),

source "$SCRIPTS/bash-colors.sh"

WAIT=9

echo "OP-TCG AutoSeller" | figlet | lolcat

gum spin --title="🔐 User auto-login..." -- bash login.sh
gum spin --title="⬇️ Fetching collection..." -- bash ./fetch-collection.sh > data/collection.json

data=$(jq -c '
    .data |= (
        map(
            . + {sell_price: (
                if .rarity == "common" then 10
                elif .rarity == "rare" then 50
                elif .rarity == "leader" then 100
                elif .rarity == "super_rare" then 150
                elif .rarity == "secret_rare" then 500
                else -1 end)}
        )
        | map(select(
            .rarity == "common" or
            .rarity == "uncommon" or
            .rarity == "rare" or
            .rarity == "leader"))
        | map(select(.quantity > 2))
        | sort_by(.quantity * .sell_price) | reverse
    ) | .data
' data/collection.json)

echo "✨ Selling cards:"
echo "$data" | jq -c '.[]' | while read -r card; do
    card_id=$(echo "$card" | jq -r '.card_id')
    name=$(echo "$card" | jq -r '.name')
    rarity=$(echo "$card" | jq -r '.rarity')
    quantity=$(echo "$card" | jq -r '.quantity')

    to_sell=$((quantity - 1))
    echo -e "Selling: ${FG_BLUE}$name ×$to_sell${COL_RESET} $rarity (${FG_RED}$card_id${COL_RESET})"

    gum spin --title="Waiting $WAIT seconds..." -- sleep ${WAIT}s

    res=$(gum spin --title="Selling $to_sell copies..." -- bash sell-card.sh "$card_id" "$to_sell")
    success=$(echo "$res" | jq -r '.success')
    if [ "$success" != "true" ]; then
        echo "$res"
        exit 1
    fi
    earned=$(echo "$res" | jq -r '.data.berrys_earned')
    new_balance=$(echo "$res" | jq -r '.data.new_balance')

    echo -e "↳ sold $to_sell copies ${FG_YELLOW}+${earned} 🪙${COL_RESET} => ${FG_YELLOW}$new_balance${COL_RESET} 💰"
done;
