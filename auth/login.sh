#!/usr/bin/env bash

source load-env.sh

USERNAME=$(cat data/username.secret)
PASSWORD=$(cat data/password.secret)

response=$(curl "$OPBG_HOST/api/auth/login" \
  --compressed --silent -X POST \
  --header 'Content-Type: application/json' \
  --data-raw '{"username":"'"$USERNAME"'","password":"'"$PASSWORD"'"}')

echo "$response" | jq -r '.accessToken' > data/bearer.secret
echo "$response" | jq -r '.refreshToken' > data/refresh.secret
