#!/usr/bin/env bash

export CLIPHIST_DB_PATH=/tmp/links.db

lines="$(cliphist list | cut -d '	' -f 2)"

n="$(wc -l <<< "${lines}")"

for i in $(seq 1 "${n}") ; do
    link="$(sed "${i}q;d" <<< "${lines}")"

    echo "copying ${link} to clipboard"
    wl-copy "${link}"

    read -r
done
