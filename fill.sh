#!/usr/bin/env bash

set -o xtrace  # trace what gets executed
set -o errexit # exit when a command fails.
set -o nounset # exit when your script tries to use undeclared variables

__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TMP_DATA_DIR="${__dir}"
ES_URL="http://localhost:9200"

curl -XPUT "${ES_URL}/search" -H 'Content-Type: application/json' -d "@${TMP_DATA_DIR}/mappings/search.json"
curl -XPUT "${ES_URL}/search/_settings" -H 'Content-Type: application/json' -d "@${TMP_DATA_DIR}/payloads/stop-refresh.json"

curl -XPUT "${ES_URL}/aggregations" -H 'Content-Type: application/json' -d "@${TMP_DATA_DIR}/mappings/aggregations.json"
curl -XPUT "${ES_URL}/aggregations/_settings" -H 'Content-Type: application/json' -d "@${TMP_DATA_DIR}/payloads/stop-refresh.json"

curl -XPUT "${ES_URL}/language" -H 'Content-Type: application/json' -d "@${TMP_DATA_DIR}/mappings/language.json"
curl -XPUT "${ES_URL}/language/_settings" -H 'Content-Type: application/json' -d "@${TMP_DATA_DIR}/payloads/stop-refresh.json"

curl -XPUT "${ES_URL}/geolocation" -H 'Content-Type: application/json' -d "@${TMP_DATA_DIR}/mappings/geolocation.json"
curl -XPUT "${ES_URL}/geolocation/_settings" -H 'Content-Type: application/json' -d "@${TMP_DATA_DIR}/payloads/stop-refresh.json"

while IFS='' read -r line || [[ -n "$line" ]]; do
    curl -XPOST "${ES_URL}/search/hotels/" -H 'Content-Type: application/json' -d "$line"
    curl -XPOST "${ES_URL}/aggregations/hotels/" -H 'Content-Type: application/json' -d "$line"
    curl -XPOST "${ES_URL}/language/hotels/" -H 'Content-Type: application/json' -d "$line"
    curl -XPOST "${ES_URL}/geolocation/hotels/" -H 'Content-Type: application/json' -d "$line"
    echo "Text read from file: $line"
done < "$1"

curl -XPOST -H "${ES_URL}/search/_refresh"
curl -XPOST -H "${ES_URL}/search/_optimize"
curl -XPUT "${ES_URL}/search/_settings" -d "@${TMP_DATA_DIR}/payloads/start-refresh.json"


curl -XPOST -H "${ES_URL}/aggregations/_refresh"
curl -XPOST -H "${ES_URL}/aggregations/_optimize"
curl -XPUT "${ES_URL}/aggregations/_settings" -d "@${TMP_DATA_DIR}/payloads/start-refresh.json"

curl -XPOST -H "${ES_URL}/language/_refresh"
curl -XPOST -H "${ES_URL}/language/_optimize"
curl -XPUT "${ES_URL}/language/_settings" -d "@${TMP_DATA_DIR}/payloads/start-refresh.json"

curl -XPOST -H "${ES_URL}/geolocation/_refresh"
curl -XPOST -H "${ES_URL}/geolocation/_optimize"
curl -XPUT "${ES_URL}/geolocation/_settings" -d "@${TMP_DATA_DIR}/payloads/start-refresh.json"
