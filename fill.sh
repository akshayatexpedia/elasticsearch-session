#!/usr/bin/env bash

set -o xtrace  # trace what gets executed
set -o errexit # exit when a command fails.
set -o nounset # exit when your script tries to use undeclared variables

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TMP_DATA_DIR="${__dir}"
ES_URL="http://localhost:9200"


for index in "search" "aggregations" "language" "geolocation" "geolocation-shape"
do
    curl -XPUT "${ES_URL}/${index}" -H 'Content-Type: application/json' -d "@${TMP_DATA_DIR}/mappings/${index}.json"
    curl -XPUT "${ES_URL}/${index}/_settings" -H 'Content-Type: application/json' -d "@${TMP_DATA_DIR}/payloads/stop-refresh.json"
done    

while IFS='' read -r line || [[ -n "$line" ]]; do
    for index in "search" "aggregations" "language"
    do
        curl -XPOST "${ES_URL}/${index}/hotels/" -H 'Content-Type: application/json' -d "$line"
    done    
done < "$1"

while IFS='' read -r line || [[ -n "$line" ]]; do
    curl -XPOST "${ES_URL}/geolocation/hotels/" -H 'Content-Type: application/json' -d "$line"
done < "data-location"

while IFS='' read -r line || [[ -n "$line" ]]; do
    curl -XPOST "${ES_URL}/geolocation-shape/hotels/" -H 'Content-Type: application/json' -d "$line"
done < "data-location-shape"

for index in "search" "aggregations" "language" "geolocation" "geolocation-shape"
do
    curl -XPOST "${ES_URL}/${index}/_refresh"
    curl -XPOST "${ES_URL}/${index}/_optimize"
    curl -XPUT -H 'Content-Type: application/json' "${ES_URL}/${index}/_settings" -d "@${TMP_DATA_DIR}/payloads/start-refresh.json"
done    
