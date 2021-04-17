#!/usr/bin/env bash

TAB="	"

if [[ -z "${NZB_API}" ]]; then
    echo "Error: NZB_API is not set" >&2
fi

if [[ -z "${NZBGET_USERNAME}" ]]; then
    echo "Error: NZBGET_USERNAME is not set" >&2
fi

if [[ -z "${NZBGET_PASSWORD}" ]]; then
    echo "Error: NZBGET_PASSWORD is not set" >&2
fi

SEARCH="${*}"

JSON="$(curl -s -L "https://api.drunkenslug.com/api?t=search&apikey=${NZB_API}&q=${SEARCH}&o=json")"

jq -r  'keys|.[]' <<< "${JSON}" | grep -q item || { echo "Search not found" >&2 ; exit 1; }

items="$(jq -r '.item[] | "\(.title) \(.enclosure._length|tonumber/1024/1024/1024*1000|round/1000)\t\(.link)"' <<< "${JSON}" 2>/dev/null ||
         jq -r '.item | "\(.title) \(.enclosure._length|tonumber/1024/1024/1024*1000|round/1000)\t\(.link)"' <<< "${JSON}")"

result="$(fzf --prompt="${SEARCH}: " -d "${TAB}" --with-nth 1 +m --layout=reverse-list <<< "${items}")"

if [[ -z "${result}" ]]; then
    exit 1
fi

url=$(cut -d "${TAB}" -f 2 <<< "${result}")

pod="$(kubectl -n media get po -l app.kubernetes.io/name=nzbget -o name)"

kubectl -n media exec -it "${pod}" -- /app/nzbget --configfile /config/nzbget.conf -A "${url}"
