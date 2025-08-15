#!/usr/bin/env bash

TAB="	"

outputs=$(curl -s http://mallard.lan:3689/api/outputs)
list=$(jq -r '.outputs[]|"\(.name)	\(.id)"' <<< "${outputs}")

names="$(cut -d "${TAB}" -f 1 <<< "${list}")"

selected="$(tofi --prompt-text "outputs: " <<< "${names}")"

if [[ -z "${selected}" ]]; then
    exit 1
fi

id="$(grep "^${selected}" <<< "${list}" | cut -d "${TAB}" -f 2 | head -1)"

current="$(jq '.outputs[] | select(.selected == true)|.id' <<< "${outputs}" | sort | paste -sd ,)"

if [[ "${current}" != "${id}" ]] ; then
    curl -X PUT "http://mallard.lan:3689/api/outputs/set" --data "{\"outputs\":[]}"
fi

curl -X PUT "http://mallard.lan:3689/api/outputs/set" --data "{\"outputs\":[${id}]}"
