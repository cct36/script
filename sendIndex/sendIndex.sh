#!/bin/bash

indexData=$(curl -s "$APPSERVER_URL/mindex")

index=$(echo "$indexData" |
  jq -r '.[] | [.desp, .last, (.changesign + .change)] | @tsv' |
  awk -F'\t' '{
    n = 4 - length($1)
    pad = ""
    for (i = 0; i < n; i++) pad = pad "　"
    printf "%s%s %6s %7s\n", $1, pad, $2, $3
  }'
)

curl -G \
  --data-urlencode "msg=<code>$index</code>" \
  --data-urlencode "id=$USERID" \
  "$BOT_URL/bot/broadcast"

