#!/usr/bin/env bash

TAB="	"

bt="$(brotab query +active)"
title="$(cut -d "${TAB}" -f 2 <<< "${bt}")"
url="$(cut -d "${TAB}" -f 3 <<< "${bt}")"

notify-send "Fetching image urls" "${url}"

f="$(gallery-dl -g --cookies-from-browser firefox --user-agent browser "${url}")"

if [[ -z "${f}" ]] ; then
    echo "Error: could not download gallery" >&2
    exit 1
fi

feh -F -Z -f <(echo "${f}")
