#!/usr/bin/env bash


jq -r '.data[] | select(.quantity > 1 and .rarity == "uncommon") | "\(.quantity) \(.name) \(.rarity) \(.card_id)"' collection.json | sort -n
