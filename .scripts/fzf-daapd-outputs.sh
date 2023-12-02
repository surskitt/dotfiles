#!/usr/bin/env bash

outputs=$(curl -s http://mallard.lan:3689/api/outputs)
list=$(jq -r '.outputs[]|"\(.id)	\(.name)"' <<< "${outputs}")

selected="$(fzf -m -d '	' --with-nth=2 --layout=reverse-list <<< "${list}" | cut -d '	' -f 1 | sort)"

if [[ -z "${selected}" ]]; then
    exit 1
fi

current="$(jq '.outputs[] | select(.selected == true)|.id' <<< "${outputs}" | sort | paste -sd ,)"
new="$(for i in ${selected}; do echo \"${i}\"; done | paste -s -d, -)"

if [[ "${current}" == "${new}" ]] ; then
    curl -X PUT "http://mallard.lan:3689/api/outputs/set" --data "{\"outputs\":[]}"
fi

curl -X PUT "http://mallard.lan:3689/api/outputs/set" --data "{\"outputs\":[${new}]}"
