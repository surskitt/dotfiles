#!/usr/bin/env bash

SOURCE_DIR="${HOME}/downloads/Telegram Desktop"
DEST_DIR="/mnt/nfs/mallard/media/downloads/torrents/uploads/music"

for i in "${SOURCE_DIR}"/*.flac ; do
    artist="$(metaflac --show-tag=ALBUMARTIST "${i}" | cut -d = -f 2)"
    album="$(metaflac --show-tag=ALBUM "${i}" | cut -d = -f 2)"
    trackno="$(metaflac --show-tag=TRACKNUMBER "${i}" | cut -d = -f 2)"
    title="$(metaflac --show-tag=TITLE "${i}" | cut -d = -f 2)"

    title="${title//\//_}"

    trackno="${trackno%/*}"
    printf -v trackno "%02d" "${trackno}"

    dest_subdir="+${artist}_${album}"
    dest_subdir="${dest_subdir// /_}"
    dest_subdir="${dest_subdir//\//_}"

    dest_fn="${trackno} - ${title}.flac"

    echo "${i} -> ${DEST_DIR}/${dest_subdir}/${dest_fn}"

    mkdir -p "${DEST_DIR}/${dest_subdir}"
    mv "${i}" "${DEST_DIR}/${dest_subdir}/${dest_fn}"
done
