#!/usr/bin/env bash

SOURCE_DIR="${HOME}/downloads"
DEST_DIR="/mnt/nfs/mallard/media/downloads/torrents/uploads/music"

for i in "${SOURCE_DIR}"/*.m4a ; do
    artist="$(mediainfo --Output=JSON "${i}" | jq -r '.media.track[0].Album_Performer')"
    album="$(mediainfo --Output=JSON "${i}" | jq -r '.media.track[0].Album')"
    trackno="$(mediainfo --Output=JSON "${i}" | jq -r '.media.track[0].Track_Position')"
    title="$(mediainfo --Output=JSON "${i}" | jq -r '.media.track[0].Track')"
    year="$(mediainfo --Output=JSON "${i}" | jq -r '.media.track[0].Recorded_Date' | cut -d '-' -f 1)"

    title="${title//\//_}"

    trackno="${trackno%/*}"
    printf -v trackno "%02d" "${trackno}"

    dest_subdir="+${artist}_${album}_${year}"
    dest_subdir="${dest_subdir// /_}"
    dest_subdir="${dest_subdir//\//_}"

    dest_fn="${trackno} - ${title}.m4a"

    echo "${i} -> ${DEST_DIR}/${dest_subdir}/${dest_fn}"

    mkdir -p "${DEST_DIR}/${dest_subdir}"
    mv "${i}" "${DEST_DIR}/${dest_subdir}/${dest_fn}"
done
