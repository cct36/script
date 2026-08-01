#/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Error: Missing required parameters."
    echo "Usage: $0 <user>"
    exit 1
fi

user="$1"

indexData=$(curl -s http://localhost:3002/mindex)
index=$(echo "$indexData" |
  jq -r '.[] | [.desp, .last, (.changesign + .change)] | @tsv' |
  awk -F'\t' '{
    n = 4 - length($1)
    pad = ""
    for (i = 0; i < n; i++) pad = pad "　"
    printf "%s%s %6s %7s\n", $1, pad, $2, $3
  }'
)
#echo "$index"
curl -G \
  --data-urlencode "msg=<code>$index</code>" \
  --data-urlencode "id=$user" \
  "http://localhost:3001/bot/broadcast"

