#!/usr/bin/env bash

WIFI_PASS="$(gopass wifi)"

nmcli -f 'bssid,signal,bars,freq,ssid' --color yes device wifi list --rescan yes | \
    fzf --with-nth=2.. --ansi --height=40% --reverse --cycle --inline-info --header-lines=1  | \
    tr -s ' ' | \
    cut -d ' ' -f 6 | \
    xargs -I {} sudo nmcli device wifi connect {} password "${WIFI_PASS}"
