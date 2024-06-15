#!/usr/bin/env bash

selected="$(cut -d ',' -f 1 ~/.cache/ttvchecker.csv | fzf +m --layout=reverse-list)"

if [[ -z "${selected}" ]] ; then
    exit 1
fi

xdg-open "https://twitch.tv/${selected}"
