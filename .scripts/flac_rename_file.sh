#!/usr/bin/env bash

discs=$(mediainfo --Output=JSON -- ./*.flac | jq -r '.[].media.track[0].Part' | sort -u | wc -l)

for i in "${PWD}"/*.flac ; do
    json="$(mediainfo --Output=JSON "${i}")"
    no="$(jq -r '.media.track[0].Track_Position' <<< "${json}")"
    title="$(jq -r '.media.track[0].Title' <<< "${json}" | sed 's#/#_#g')"
    disc="$(jq -r '.media.track[0].Part' <<< "${json}" | sed 's#/#_#g')"

    printf -v no "%02d" "${no#0}"

    fn="${no} - ${title}.flac"

    if [[ "${discs}" -gt 1 ]] ; then
        fn="${disc}.${fn}"
    fi

    if [[ ! -f "${fn}" ]] ; then
        mv "${i}" "${fn}"
    fi
done
