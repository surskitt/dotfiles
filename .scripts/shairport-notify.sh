#!/usr/bin/env bash

export TAB="	"

playerctl -p ShairportSync metadata --format "{{ title }}${TAB}{{ artist }} - {{ album }}${TAB}{{ mpris:artUrl }}" --follow | \
    while IFS="${TAB}" read -r t a ar; do dunstify -r 3001 -i "${ar}" "${t}" "${a}"; done
