#!/usr/bin/env bash

# antiCheatMiddleware('sell_card', { maxPerMinute: 20, maxPerHour: 200, minDelay: 500 }),

source "bash-colors.sh"

WAIT_LONG=18 # 3600 / 200 (because limit is 200 sell actions per hour)
WAIT_MEDIUM=3 # 60 / 20 (because limit is 20 sell actions per minute)
WAIT_LOW=1 # because you have to wait at least 0.5s between each sell (and i am lazy to convert all that shit to ms).

WAIT=$WAIT_LONG
BEARER_EXPIRY=$((60 * 12)) # = 12 mins. Technically expires after 15 minutes but we invalidate early

echo "OP-TCG Auto Seller" | figlet | lolcat

gum spin --title="🔐 User auto-login..." -- bash login.sh
gum spin --title="⬇️ Fetching collection..." -- bash ./fetch-collection.sh > data/collection.json

data=$(jq -c '
    .data |= (
        map(
            . + {sell_price: (
                if .rarity == "common" then 10
                elif .rarity == "uncommon" then 25
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
            .rarity == "super_rare" or
            .rarity == "leader"))
        | map(select(((.quantity - 2) * .sell_price) > 10))
        | sort_by((.quantity - 2) * .sell_price) | reverse
    ) | .data
' data/collection.json)

iteration=1

echo "✨ Selling cards:"
echo "$data" | jq -c '.[]' | while read -r card; do
    if [ $((iteration * WAIT)) -gt $BEARER_EXPIRY ]; then
        gum spin --title="🔐 User auto-login refresh..." -- bash login.sh
    fi

    card_id=$(echo "$card" | jq -r '.card_id')
    name=$(echo "$card" | jq -r '.name')
    rarity=$(echo "$card" | jq -r '.rarity')
    quantity=$(echo "$card" | jq -r '.quantity')

    to_sell=$((quantity - 2))
    echo -e "Selling: ${FG_BLUE}$name ×$to_sell${COL_RESET} $rarity (${FG_RED}$card_id${COL_RESET})"

    gum spin --title="Waiting $WAIT seconds..." -- sleep ${WAIT}s

    res=$(gum spin --title="Selling $to_sell copies..." -- bash sell-card.sh "$card_id" "$to_sell")
    success=$(echo "$res" | jq -r '.success')
    if [ "$success" != "true" ]; then
        echo -e "${FG_RED}$res${COL_RESET}"
        if ! gum spin --title="🔐 Try user auto-login again..." -- bash login.sh; then
            exit 1
        fi
        echo "skipping this card sell..."
        continue;
    fi

    earned=$(echo "$res" | jq -r '.data.berrys_earned')
    new_balance=$(echo "$res" | jq -r '.data.new_balance')

    echo -e "↳ sold $to_sell copies ${FG_YELLOW}+${earned} 🪙${COL_RESET} => ${FG_YELLOW}$new_balance${COL_RESET} 💰"
    ((iteration++))
done;
