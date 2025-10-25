#!/usr/bin/env bash

source "$SCRIPTS/bash-colors.sh"

BEARER=$(cat ./bearer.secret)
PACK_ID=$1

if [ -z "$PACK_ID" ]; then
    echo -e "${FG_RED}open-booster.sh: missing PACK_ID${COL_RESET}"
    exit 1
fi

echo -e "${FG_RED}<<<===<<<ooo<<<[[{0}]]>>>ooo>>>===>>>${COL_RESET}"

res=$(curl 'https://backend-optcg.polo2409.work/api/users/buy-booster' \
  --compressed --silent -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $BEARER" \
  --data-raw '{"boosterId":"'"$PACK_ID"'"}')

if echo "$res" | jq -e 'has("error")' > /dev/null; then
    error=$(echo "$res" | jq -r '.error')
    echo -e "${FG_RED}$error${COL_RESET}"
    echo "$res"
    exit 1
fi

res=$(echo "$res" | jq -r '.data.cards.[] | "\(.name): \(.rarity) (\(.vegapull_id))"')
res=$(echo "$res" \
    | sed "s| leader| \\${FG_RED}Leader\\${COL_RESET}|g" \
    | sed "s| uncommon| \\${FG_GREEN}Uncommon\\${COL_RESET}|g" \
    | sed "s| secret_rare| \\${FG_YELLOW}✨ SECRET Rare ✨\\${COL_RESET}|g" \
    | sed "s| super_rare| \\${FG_PURPLE}Super Rare\\${COL_RESET}|g" \
    | sed "s| common| \\${FG_GRAY}Common\\${COL_RESET}|g" \
    | sed "s| rare| \\${FG_BLUE}Rare\\${COL_RESET}|g")

echo -e "$res"

money=$(bash ./get-me.sh | jq '.user.berrys')

echo -e "${FG_RED}<<<===<<<ooo<<<[[{0}]]>>>ooo>>>===>>>${COL_RESET}"
echo -e "Berrys: ${FG_YELLOW}$money 🪙${COL_RESET}"
