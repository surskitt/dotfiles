#!/usr/bin/env bash

if [[ "${#}" -lt 1 ]] ; then
    echo "Error: missing cover art file name" >&2
    exit 1
fi

art_file="${1}"

for i in *.flac ; do
    metaflac --remove --block-type=PICTURE,PADDING --dont-use-padding "${i}"
    metaflac --import-picture-from="${art_file}" "${i}"
done
