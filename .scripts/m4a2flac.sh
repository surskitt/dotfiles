#!/usr/bin/env bash

if [[ "${#}" -eq 0 ]] ; then
    m4as=(*.m4a)
else
    m4as=("${@}")
fi

mediainfo="$(mediainfo --Output=JSON "${m4as[@]}")"

if [[ "${#m4as[@]}" -eq 1 ]] ; then
    mediainfo="[${mediainfo}]"
fi

ERROR=false

if jq -r '.[].media.track[1].Format' <<< "${mediainfo}" | grep -q AAC ; then
        echo "Error: m4a files contain AAC files" >&2
        ERROR=true
fi

if jq -r '.[].media.track[1].CodecID' <<< "${mediainfo}" | grep -E -q 'mp4a.*' ; then
        echo "Error: m4a files contain mp4a files" >&2
        ERROR=true
fi

if jq -r '.[].media.track[1].Compression_Mode' <<< "${mediainfo}" | grep -q Lossy ; then
        echo "Error: m4a files contain lossy files" >&2
        ERROR=true
fi

if "${ERROR}" ; then
    exit 1
fi

parallel --tag --progress --unsafe \
    ffmpeg -hide_banner -loglevel error -y -i "{}" -map 0 -map_metadata 0 -c:a flac -compression_level 8 -c:v copy "{.}.flac" \
    ::: "${m4as[@]}"
