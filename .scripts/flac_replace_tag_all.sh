#!/usr/bin/env bash

tempdir="$(mktemp -d)"

for flac in *.flac ; do
    fn="${flac##*/}"
    tag_file="${tempdir}/${fn}.txt"

    metaflac --no-utf8-convert --export-tags-to="${tag_file}" "${flac}"
done

vim "${tempdir}"/*.txt

for flac in *.flac ; do
    fn="${flac##*/}"
    tag_file="${tempdir}/${fn}.txt"

    metaflac --remove-all-tags --import-tags-from="${tag_file}" "${flac}"
done
