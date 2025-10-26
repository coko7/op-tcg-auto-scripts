#!/usr/bin/env bash

# antiCheatMiddleware('open_booster', { maxPerMinute: 10, maxPerHour: 100, minDelay: 1000 }),

source "bash-colors.sh"

WAIT=36

# PACK_ID=569301 # PRB-01
# PACK_ID=569302 # PRB-02
PACK_ID=569109 # OP-09
# PACK_ID=569111 # Divine fist - 5 secret

echo "OP-TCG Auto OpenBooster" | figlet | lolcat
gum spin --title="🔐 User auto-login..." -- bash login.sh

opening=1
money=$(bash get-me.sh | jq '.user.berrys')

while true; do
    gum spin --title="Waiting $WAIT seconds..." -- sleep ${WAIT}s
    if [ $((opening % 20)) -eq 0 ]; then
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
