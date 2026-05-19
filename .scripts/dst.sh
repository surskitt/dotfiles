#!/usr/bin/env bash

downsampler-threaded.sh .

mkdir ../dst

find . -maxdepth 1 -type f \! -iname '*.flac' | while read -r f; do
    cp "${f}" ../dst/
done

mv */*.flac ../dst

for i in *.flac; do
    if metaflac --show-bps -- "${i}" | grep -q '16$'; then
        cp "${i}" ../dst
    fi
done

ops_dir_rename.sh ../dst
