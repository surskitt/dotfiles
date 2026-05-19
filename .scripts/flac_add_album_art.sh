#!/usr/bin/env bash

if [[ "${#}" -lt 1 ]]; then
    echo "Error: missing cover art file name" >&2
    exit 1
fi

art_file="${1}"

magick "${art_file}" -resize '1000x1000>' aa.jpg
jpegoptim -m 85 aa.jpg

ls -lh *.jpg

for i in *.flac; do
    metaflac --remove --block-type=PICTURE,PADDING --dont-use-padding "${i}"
    metaflac --import-picture-from=aa.jpg "${i}"
done

rm aa.jpg
