#!/bin/bash
curl -s "https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" > aviation.json
total_temp=0
count=0
cloudy_count=0
receipt_times=()


for ((i=0; i<6; i++)); do
  receipt_time=$(jq -r ".[$i].receiptTime" aviation.json)
  receipt_times+=("$receipt_time")
  temp=$(jq -r ".[$i].temp" aviation.json)
total_temp=$(echo "$total_temp + $temp" | bc)  count=$((count + 1))
  cloud=$(jq -r ".[$i].clouds | map(.cover) | join(\", \")" aviation.json)
  if [[ "$cloud" != *"CLR"* ]]; then
    cloudy_count=$((cloudy_count + 1))
  fi
done

for time in "${receipt_times[@]:0:6}"; do
  echo "\"$time\""
done

average_temp=$(echo "scale=2; $total_temp / $count" | bc)
echo "\"Average Temperature: $average_temp\""
if [ $cloudy_count -gt 6 ]; then
  echo "\"Mostly Cloudy: true\""
else
  echo "\"Mostly Cloudy: false\""
fi
