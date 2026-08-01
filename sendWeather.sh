#/bin/bash

# Check that both parameters are supplied
if [ "$#" -ne 2 ]; then
    echo "Error: Missing required parameters."
    echo "Usage: $0 <user> <city>"
    exit 1
fi

user="$1"
city="$2"

#echo "User: $user"
#echo "City: $city"

data=$(curl -s http://localhost:3002/weather?city=$city)
#echo $data
output=$(echo "$data" |
jq -r '
  .name + "," + .sys.country + ":" + "\n" +
  (.main.temp | floor | tostring) + "° " + .weather[0].main + "\n" +
  "Feels like " + (.main.feels_like | floor | tostring) + "° " +
  "Humidity: " + (.main.humidity | tostring) + "%" + "\n" +
  "High: " + (.main.temp_max | floor | tostring) + "° " +
  "Low: " + (.main.temp_min | floor | tostring) + "°" + "\n" +
  "Wind: " + (.wind.speed | tostring) + "m/s " +
  (if .wind.deg >= 337.5 or .wind.deg < 22.5 then "N"
   elif .wind.deg < 67.5 then "NE"
   elif .wind.deg < 112.5 then "E"
   elif .wind.deg < 157.5 then "SE"
   elif .wind.deg < 202.5 then "S"
   elif .wind.deg < 247.5 then "SW"
   elif .wind.deg < 292.5 then "W"
   else "NW" end) +
  "  Visibility: " + ((.visibility / 1000) | tostring) + "km" + "\n"
'
)
#echo "$output"
curl -G \
  --data-urlencode "msg=$output" \
  --data-urlencode "id=$user" \
  "http://localhost:3001/bot/broadcast"

