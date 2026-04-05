#!/usr/bin/env bash

if [[ "${#}" -lt 2 ]] ; then
    echo "Usage: ${0} dir1 dir2" >&2
    exit 1
fi

if [[ ! -d "${1}" || ! -d "${2}" ]] ; then
    echo "Error: both args must be directories" >&2
    exit 1
fi

dir1="${1}"
dir2="${2}"

for flac in "${dir1}"/*.flac ; do
    flacfn="${flac##"${dir1}/"}"
    # d2flac="${dir2}/${flac#*/}"
    d2flac="${dir2}/${flacfn}"

    if [[ ! -f "${d2flac}" ]] ; then
        echo "No flac found in dir 2: ${d2flac}"
        continue
    fi

    metaflac --no-utf8-convert --export-tags-to=- "${flac}" | \
        metaflac --remove-all-tags --import-tags-from=- "${d2flac}"
done
