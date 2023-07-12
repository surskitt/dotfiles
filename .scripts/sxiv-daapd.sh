#!/usr/bin/env bash

DAAPD_HOST="192.168.2.5"

ACTION="${1}"
ARGS="${@:2}"

refresh() {
    mkdir -p ~/.cache/sxiv-daapd/{uri,name}

    json="$(curl -s http://${DAAPD_HOST}:3689/api/library/albums)"

    json_lines="$(jq -r '.items[]|"\(.artist) - \(.name)	\(.uri)	\(.time_added)	\(.artwork_url)	\(.media_kind)"' <<< "${json}")"

    while IFS="	" read name uri date url media_kind; do
        if [[ "${media_kind}" != "music" ]]; then
            continue
        fi

        name="${name//\//_}"

        if [[ -f ~/.cache/sxiv-daapd/uri/"${uri}" ]]; then
            continue
        fi

        curl -s "http://${DAAPD_HOST}:3689/${url}" -o ~/.cache/sxiv-daapd/uri/"${uri}"
        ln -s ~/.cache/sxiv-daapd/uri/"${uri}" ~/.cache/sxiv-daapd/name/"${name}"
        touch -d "${date}" ~/.cache/sxiv-daapd/uri/"${uri}"
        touch -h -d "${date}" ~/.cache/sxiv-daapd/name/"${name}"
    done <<< "${json_lines}"
}

selector() {
    cd ~/.cache/sxiv-daapd/name

    names="$(ls -t)"

    if [[ ! -z "${ARGS}" ]]; then
        names="$(grep -i "${ARGS}" <<< "${names}")"
    fi

    selected="$(sxiv -ftio 2>/dev/null <<< "${names}"|while read f; do readlink "${f}" | xargs basename; done)"

    if [[ -z "${selected}" ]]; then
        exit 1
    fi

    args="$(tr '\n' ',' <<< "${selected}" ; echo)"

    curl -s -X POST "http://${DAAPD_HOST}:3689/api/queue/items/add?uris=${args}"
}

if [[ "${ACTION}" == refresh ]]; then
    refresh
elif [[ "${ACTION}" == search ]]; then
    selector "${ARGS}"
else
    selector
fi
