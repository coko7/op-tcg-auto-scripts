#!/usr/bin/env bash

# antiCheatMiddleware('open_booster', { maxPerMinute: 10, maxPerHour: 100, minDelay: 1000 }),

WAIT=12

# PACK_ID=569301 # 16 secret
PACK_ID=569111 # Divine fist - 5 secret

echo "OP-TCG AutoOpenBooster" | figlet | lolcat
gum spin --title="🔐 User auto-login..." -- bash login.sh

opened=0
money=$(bash get-me.sh | jq '.user.berrys')

# for i in $(seq 1 10); do
while true; do
    ((opened++))
    gum spin --title="Waiting $WAIT seconds..." -- sleep ${WAIT}s
    echo "🎁 OPEN #$opened >>>"
    bash open-booster.sh $PACK_ID
    ((money -= 100))

    # money=$(bash ./get-me.sh | jq '.user.berrys')
    echo -e "Berrys: ${FG_YELLOW}$money 🪙${COL_RESET}"

    if (( money < 500 )); then
        echo "Less than 500 🪙 - Exiting 👋"
        exit 0
    fi
done
