#!/usr/bin/env bash

read -r d t ap < <(date +"%d/%m/%Y %I:%M %P")

now="${d} ${t} ${ap}"
eod="${d} 11:59 pm"

events() {
    khal list -f '{start-time} {end-time} {title}' "${now}" "${eod}"
}

case "${1}" in
    notify)
        notify-send "📅 Calendar" "$(
            events | grep '^[012]' | while read -r l; do
              read -r s sap e eap t <<< "${l}"

              echo 
              echo "${s} ${sap} -> ${e} ${eap}"
              echo "${t}"
            done
        )"
        ;;
    *)
        echo -n " "
        events | grep -c '^[012]'
        ;;
esac
