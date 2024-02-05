#!/usr/bin/env bash

TAB="	"

bt="$(brotab query +active)"
title="$(cut -d "${TAB}" -f 2 <<< "${bt}")"
url="$(cut -d "${TAB}" -f 3 <<< "${bt}")"

METUBE_URL="https://metube.$(gopass paddlepond/cname_host)"

metube_code="$(curl -is "${METUBE_URL}" | head -1)"

if [[ "${metube_code}" == "HTTP/2 200 " ]] ; then
    notify-send "Downloading video with metube" "${title}"
    curl -X POST \
        --data "{\"url\":\"${url}\", \"quality\":\"best\"}" \
        "${METUBE_URL}/add"
else
    notify-send "Downloading video with yt-dlp" "${title}"
    youtube-dl.sh "${url}"
fi
