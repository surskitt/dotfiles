#!/usr/bin/env bash

# exit 127 is so ctpv knows the script failed

if [[ "${#}" -lt 2 ]]; then
    exit 127
fi

f="${1}"
o="${2}"

if [[ ! -f "${f}" ]]; then
    exit 127
fi

# get the directory of the file passed
d="${f%/*}"

# get the thumb directory
td="${d}/.thumbs"

# get the filename without the parent directory
fn="${f##*/}"

# get the filename without the parent directory or extension
fnn="${fn%\.*}"

# return the preview gif if it exists
pg="${td}/${fnn}.gif"
if [[ -f "${pg}" ]]; then
    cp "${pg}" "${o}"
    exit 0
fi

# return the preview image if it exists
pp="${td}/${fnn}.jpg"
if [[ -f "${pp}" ]]; then
    cp "${pp}" "${o}"
    exit 0
fi

exit 127
