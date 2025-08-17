#!/usr/bin/env bash

if [[ "${#}" -lt 1 ]] ; then
    exit 1
fi

win="$(hyprctl clients -j | jq '.[]|select(.focusHistoryID==0)')"

x="$(jq -r '.at[0]' <<< "${win}")"
y="$(jq -r '.at[1]' <<< "${win}")"
w="$(jq -r '.size[0]' <<< "${win}")"
h="$(jq -r '.size[1]' <<< "${win}")"

x="$(( "${x}" - 20))"
y="$(( "${y}" - 20))"
w="$(( "${w}" + 40))"
h="$(( "${h}" + 40))"

grim -g "${x},${y} ${w}x${h}" "${1}"

notify-send -i "${1}" "Screenshot taken"
