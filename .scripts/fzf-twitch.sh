#!/usr/bin/env bash

if [[ "${1}" == "cached" ]]; then
    if [[ -f /tmp/twitch_subes ]]; then
        chans="$(tail -1 /tmp/twitch_subes | xargs -n 1)"
    else
        chans="$(twitchnotifier -c sharktamer -n|cut -d ':' -f 1)"
    fi
else
    chans="$(twitchnotifier -c sharktamer -n|cut -d ':' -f 1)"
fi

t=$(fzf --layout=reverse-list <<< "${chans}")

if [ -z "${t}" ]; then
    exit 1
fi

disown.sh streamlink --twitch-low-latency --player mpv "https://twitch.tv/${t}" best
disown.sh floater.sh st -g 60x40+20-50 tiny_twitch.sh "${t}"
