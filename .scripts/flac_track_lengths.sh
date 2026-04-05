#!/usr/bin/env bash

TAB="	"

for i in "${@}" ; do 
    duration="$(mediainfo --Output=JSON "${i}" | jq -r '.media.track[0].Duration')"

    output="${duration%.*}"

    if [[ "${output}" -ge 60 ]] ; then
        minutes="$(echo "${output}/60" | bc)"
        printf -v minutes "%02d" "${minutes}"
    else
        minutes="00"
    fi

    seconds="$(echo "${output}%60" | bc)"
    printf -v seconds "%02d" "${seconds}"

    output="${minutes}:${seconds}"

    echo "${i}${TAB}${output}"
done | rich --csv -
