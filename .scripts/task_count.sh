#!/usr/bin/env bash

readarray -t tasks < <(todo --porcelain | jq -r '.[].summary' 2>/dev/null)

case "${1}" in
    notify)
        notify-send "✅ Tasks" "$(printf '%s\n' "${tasks[@]}")"
        ;;
    *)
        echo " ${#tasks[*]}"
esac
