#!/usr/bin/env bash

usage() {
    echo "something"
}

TAB="	"

albums_json="$(curl -s http://mallard.lan:3689/api/library/albums)"

# echo "${albums_json}"

album_list="$(jq -r '.items[]|"\(.artist) - \(.name)	\(.uri)	\(.time_added)"' <<< "${albums_json}" | sort -t '	' -k 3 -r | shuf -n 50 )"

selected="$(fzf -m -d '	' --with-nth=1 --layout=reverse-list --bind ctrl-a:select-all <<< "${album_list}"|cut -d '	' -f 2)"

if [[ -z "${selected}" ]]; then
    exit 1
fi

args="$(tr '\n' ',' <<< "${selected}" ; echo)"

curl -s -X POST "http://mallard.lan:3689/api/queue/items/add?uris=${args}"
