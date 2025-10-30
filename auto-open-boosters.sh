#!/usr/bin/env bash

# antiCheatMiddleware('buy_booster', { maxPerMinute: 5, maxPerHour: 50, minDelay: 2000 }),

source "bash-colors.sh"

WAIT_LONG=72 # 3600 / 50 (because limit is 50 packs per hour)
WAIT_MEDIUM=12 # 60 / 5 (because limit is 5 packs per minute)
WAIT_LOW=2 # because you have to wait at least 2s between each opening

WAIT=$WAIT_LONG
BEARER_EXPIRY=$((60 * 12)) # = 12 mins. Technically expires after 15 minutes but we invalidate early

PACK_ID=569201 # 2 🌟 0 / 17 ⭐ 0 EXTRA BOOSTER -MEMORIAL COLLECTION- [EB-01] => 80

echo "OP-TCG Auto OpenBooster" | figlet | lolcat
gum spin --title="🔐 User auto-login..." -- bash login.sh

opening=1
money=$(bash get-me.sh | jq '.user.berrys')

echo "✨ Opening boosters for pack: $PACK_ID"
while true; do
    gum spin --title="Waiting $WAIT seconds..." -- sleep ${WAIT}s
    if [ $((opening * WAIT)) -gt $BEARER_EXPIRY ]; then
        gum spin --title="🔐 User auto-login refresh..." -- bash login.sh
    fi

    echo "🎁 OPEN #$opening >>>"
    if ! gum spin --title="Opening booster $PACK_ID..." --show-output -- bash open-booster.sh $PACK_ID; then
        exit 1
    fi

    ((opening++))
    ((money -= 100))

    echo -e "Balance: ${FG_YELLOW}$money 🪙${COL_RESET}\n"

    if (( money < 500 )); then
        echo "Less than 500 🪙 - Exiting 👋"
        exit 0
    fi
done
