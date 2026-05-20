#!/usr/bin/env bash

art_file="${1:-cover.jpg}"

if [[ ! -f "${art_file}" ]] ; then
    echo "Error: ${art_file} does not exist" >&2
    exit 1
fi

magick "${art_file}" -resize '1000x1000>' aa.jpg
jpegoptim -m 85 aa.jpg

album_art_size="$(wc -c < aa.jpg)"

ls -lh *.jpg

echo

for i in *.flac; do
    current_art_size="$(metaflac "${i}" --export-picture-to=- | wc -c)"

    if [[ "${current_art_size}" -eq "${album_art_size}" ]] ; then
        echo "${i} - Album art size unchanged"
        continue
    fi

    echo "${i} - Applying album art"

    metaflac --remove --block-type=PICTURE,PADDING --dont-use-padding "${i}"
    metaflac --import-picture-from=aa.jpg "${i}"
done

rm aa.jpg
