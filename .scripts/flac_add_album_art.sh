#!/usr/bin/env bash

art_file="${1:-cover.jpg}"

if [[ ! -f "${art_file}" ]] ; then
    echo "Error: ${art_file} does not exist" >&2
    exit 1
fi

magick "${art_file}" -resize '1000x1000>' aa.jpg
jpegoptim -m 85 aa.jpg

ls -lh *.jpg

for i in *.flac; do
    metaflac --remove --block-type=PICTURE,PADDING --dont-use-padding "${i}"
    metaflac --import-picture-from=aa.jpg "${i}"
done

rm aa.jpg
