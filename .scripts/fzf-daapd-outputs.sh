#!/usr/bin/env bash

outputs=$(curl -s http://mallard.lan:3689/api/outputs|jq -r '.outputs[]|"\(.id)	\(.name)"')

selected="$(fzf -m -d '	' --with-nth=2 --layout=reverse-list <<< "${outputs}"|cut -d '	' -f 1)"

if [[ -z "${selected}" ]]; then
    exit 1
fi

list="$(for i in ${selected}; do echo \"${i}\"; done | paste -s -d, -)"

curl -X PUT "http://mallard.lan:3689/api/outputs/set" --data "{\"outputs\":[${list}]}"
