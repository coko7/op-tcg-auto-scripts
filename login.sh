#!/usr/bin/env bash

USERNAME=$(cat ./data/username.secret)
PASSWORD=$(cat ./data/password.secret)

response=$(curl 'https://backend-optcg.polo2409.work/api/auth/login' \
  --compressed --silent -X POST \
  -H 'Content-Type: application/json' \
  --data-raw '{"username":"'"$USERNAME"'","password":"'"$PASSWORD"'"}')

echo "$response" | jq -r '.accessToken' > ./data/bearer.secret
echo "$response" | jq -r '.refreshToken' > ./data/refresh.secret
