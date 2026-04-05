#!/usr/bin/env bash

title="${1}"
message="${2}"

shift 2

for i in "${@}" ; do
    echo "notify-send -u critical \"${title}\" \"${message}\"" | at "${i}"
done
