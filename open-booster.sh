#!/usr/bin/env bash

source "bash-colors.sh"

BEARER=$(cat ./data/bearer.secret)
PACK_ID=$1

if [ -z "$PACK_ID" ]; then
    echo -e "${FG_RED}open-booster.sh: missing PACK_ID${COL_RESET}"
    exit 1
fi

function get_pretty_rarity_text() {
    rarity="$1"
    case $rarity in
        'common') echo "${FG_GRAY}Common${COL_RESET}" ;;
        'uncommon') echo "${FG_GREEN}Uncommon${COL_RESET}" ;;
        'rare') echo "${FG_BLUE}Rare${COL_RESET}" ;;
        'leader') echo "${FG_RED}Leader 👑${COL_RESET}" ;;
        'super_rare') echo "${FG_CYAN}⭐ Super Rare ⭐${COL_RESET}" ;;
        'secret_rare') echo "${FG_YELLOW}🌟🌈✨ Secret Rare ✨🌈🌟${COL_RESET}" ;;
        *) echo "${FG_RED}❓ ??? ❓${COL_RESET}" ;;
    esac
}

function print_separator() {
    echo -e "${FG_RED}<<<===<<<ooo<<<[[{0}]]>>>ooo>>>===>>>${COL_RESET}"
}

res=$(curl 'https://backend-optcg.polo2409.work/api/users/buy-booster' \
  --compressed --silent -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $BEARER" \
  --data-raw '{"boosterId":"'"$PACK_ID"'"}')

print_separator

if echo "$res" | jq -e 'has("error")' > /dev/null; then
    error=$(echo "$res" | jq -r '.error')
    echo -e "${FG_RED}$error${COL_RESET}"
    echo "$res"
    exit 1
fi

echo "$res" | jq -c '.data.cards.[]' | while read -r card; do
    id=$(echo "$card" | jq -r '.vegapull_id')
    name=$(echo "$card" | jq -r '.name')
    rarity=$(echo "$card" | jq -r '.rarity')

    pretty_rarity=$(get_pretty_rarity_text "$rarity")
    echo -e "$pretty_rarity: $name (${FG_GRAY}$id${COL_RESET})"
done

print_separator
