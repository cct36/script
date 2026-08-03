#!/bin/bash

data=$(curl -s http://localhost:3002/weather?city=bracknell)
#echo $data

LOCATION=$(echo "$data" | jq -r '.name')
TEMP=$(echo "$data" | jq -r '.main.temp')
# Convert Unix timestamp to HH:MM
SUNSET=$(date -d "@$(echo "$data" | jq -r '.sys.sunset')" +"%H:%M")

output=$(printf "Flex Driving Forecast\nLocation: %s\n\n🌡 Temperature: %s°C\n🌅 Sunset: %s" \
    "$LOCATION" \
    "${TEMP%.*}" \
    "$SUNSET"
)

curl -G \
  --data-urlencode "msg=$output" \
  --data-urlencode "id=887274455" \
  "http://localhost:3001/bot/broadcast"

