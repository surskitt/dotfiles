#!/usr/bin/env bash

WIFI_PASS="$(gopass wifi)"

nmcli -f 'ssid' --color no device wifi list --rescan yes | \
    tail -n +2 | \
    cut -d ' ' -f 1 | \
    tofi | 
    xargs -I {} sudo nmcli device wifi connect {} --ask

# xargs -I {} sudo nmcli device wifi connect {} password "${WIFI_PASS}"
