#!/usr/bin/env bash

bash load-env.sh

BEARER=$(cat data/bearer.secret)
QUEST_ID=$1
CREW_MEMBERS=$2

[[ -z "$QUEST_ID" ]] && echo "error: provide quest_id" && exit 1
[[ -z "$CREW_MEMBERS" ]] && echo "error: provide crew members list" && exit 1

curl "$OPBG_HOST/api/world/quests/start" \
  --compressed -X POST \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $BEARER" \
  --data-raw '{"questId":"'"$QUEST_ID"'","crewMemberIds":'"$CREW_MEMBERS"'}'
