#!/usr/bin/env bash

# antiCheatMiddleware('buy_booster', { maxPerMinute: 5, maxPerHour: 50, minDelay: 2000 }),

source load-env.sh
source bash-colors.sh
source boosters.sh

WAIT_LONG=72 # 3600 / 50 (because limit is 50 packs per hour)
WAIT_MEDIUM=12 # 60 / 5 (because limit is 5 packs per minute)
WAIT_LOW=2 # because you have to wait at least 2s between each opening

WAIT=$WAIT_LONG
BEARER_EXPIRY=$((60 * 12)) # = 12 mins. Technically expires after 15 minutes but we invalidate early

SOUND_DIR="/usr/share/sounds/freedesktop/stereo"

echo "OP-TCG Auto OpenBooster" | figlet | lolcat
gum spin --title="🔐 User auto-login..." -- bash auth/login.sh

opening=1
money=$(bash auth/get-me.sh | jq '.user.berrys')

echo "✨ Opening boosters for pack: $PACK_ID"
while true; do
    if (( money < 500 )); then
        echo "Less than 500 🪙 - Exiting 👋"
        notify-send -u critical "System" \
            "👒 op-tcg-auto-open finished ✅" \
            -i "$HOME/Pictures/Memes/y-u-no.jpg" \
            -h string:x-canonical-private-synchronous:op-tcg-open-alert \
        && paplay "$SOUND_DIR/complete.oga"
        exit 0
    fi

    gum spin --title="Waiting $WAIT seconds..." -- sleep ${WAIT}s
    if [ $((opening * WAIT)) -gt $BEARER_EXPIRY ]; then
        gum spin --title="🔐 User auto-login refresh..." -- bash auth/login.sh
        money=$(bash auth/get-me.sh | jq '.user.berrys')
    fi

    echo "🎁 OPEN #$opening - $(date +%H:%M)"
    if ! gum spin --title="Opening booster $PACK_ID..." --show-output -- bash users/open-booster.sh $PACK_ID; then
        exit 1
    fi

    ((opening++))
    ((money -= 100))

    echo -e "Balance: ${FG_YELLOW}$money 🪙${COL_RESET}\n"
done
