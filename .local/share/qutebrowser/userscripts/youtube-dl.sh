#!/bin/bash

rawurlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    local pos c o
    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Zа-яА-я0-9] ) o="${c}" ;;
            [\[\]] ) o="|" ;;
            * )               printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

# site=$(awk -F [/.] '{print $3}' <<< $1)
# [[ $site == www ]] && site=$(awk -F [/.] '{print $4}' <<< $1)
# mkdir -p ~/ytdl/${site}

rawurlencode "$1"
LINK="$REPLY"

# echo "jseval \"Downloading $LINK via youtube-dl... \"" >> "$QUTE_FIFO" && tsp youtube-dl --mark-watched -o "~/ytdl/%(title)s.%(ext)s" "$1" && echo "jseval \"Downloading $LINK via youtube-dl... done\"" >> "$QUTE_FIFO" || echo "jseval \"Downloading $LINK via youtube-dl... failed\"" >> "$QUTE_FIFO"
# echo "jseval \"Downloading $LINK via youtube-dl... \"" >> "$QUTE_FIFO" && TS_SOCKET=/tmp/socket-ts.yt tsp youtube-dl -o "~/ytdl/${site}/%(title)s.%(ext)s" "$1"
echo "jseval \"Downloading $LINK via youtube-dl... \"" >> "$QUTE_FIFO" && ~/.scripts/youtube-dl.sh "${1}"
