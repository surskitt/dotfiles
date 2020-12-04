#!/usr/bin/env bash

read -r d t ap < <(date +"%d/%m/%Y %I:%M %P")

now="${d} ${t} ${ap}"
eod="${d} 11:59 pm"

readarray -t events < <(khal list -f '{start-time} {end-time} {title}' "${now}" "${eod}" | egrep -v '^Today|No events')

case "${1}" in
    notify)
        notify-send "📅 Calendar" "$(
            if [[ "${#events[*]}" -eq 0 ]]; then
                echo "No events today"
            else
                for e in "${events[@]}"; do
                    if [[ "${e}" = [012]* ]]; then
                        read -r s sap e eap d <<< "${e}"

                        start="$(date -d "${s} ${sap}" +"%H:%M")"
                        end="$(date -d "${e} ${eap}" +"%H:%M")"

                        echo "${start}-${end}: ${d}"
                    else
                        echo "All day: ${e#  *}"
                    fi
                done
            fi
        )"
        ;;
    *)
        echo -n " "
        echo "${#events[*]}"
        ;;
esac
