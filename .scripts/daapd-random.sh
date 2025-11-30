#!/usr/bin/env bash

usage() {
    echo "something"
}

TAB="	"

albums_json="$(curl -s http://mallard.lan:3689/api/library/albums)"

# albums="$(jq -r '.items[].uri' <<< "${albums_json}" | shuf -n 50)"
albums="$(jq -r '.items[]|select(.data_kind=="file").uri' <<< "${albums_json}" | shuf -n 50)"

args="$(tr '\n' ',' <<< "${albums}" ; echo)"

curl -s -X POST "http://mallard.lan:3689/api/queue/items/add?uris=${args}"
