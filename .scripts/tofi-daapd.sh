#!/usr/bin/env bash

usage() {
    echo "something"
}

TAB="	"

if [[ "${#}" -eq 0 ]] ; then
    albums_json="$(curl -s http://mallard.lan:3689/api/library/albums)"

    albums="$(
        # jq -r '.items[]|"\(.artist) - \(.name)	\(.uri)	\(.time_added)"' <<< "${albums_json}" |
        jq -r '.items[]|select(.data_kind=="file")|"\(.artist) - \(.name)	\(.uri)	\(.time_added)"' <<< "${albums_json}" |
            sort -t "${TAB}" -k 3 -r |
            grep -v -e 'Various Artists' -e '^ - '
    )"
else
    albums="$(<"${1}")"
fi

names="$(cut -d "${TAB}" -f 1 <<< "${albums}")"

selected="$(tofi --prompt-text "  : " <<< "${names}")"

if [[ -z "${selected}" ]]; then
    if [[ "${#}" -eq 0 ]] ; then
        exit 1
    else
        exit 0
    fi
fi

uri="$(grep "^${selected}" <<< "${albums}" | cut -d "${TAB}" -f 2 | head -1)"

curl -s -X POST "http://mallard.lan:3689/api/queue/items/add?uris=${uri}"

"${0}" <(grep -A 999999 "^${selected}" <<< "${albums}" | tail -n+2)
