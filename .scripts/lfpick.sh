#!/usr/bin/bash

OUTFILE="${1}"

temp_file="$(mktemp --suffix .lf-browse)"
lf -selection-path "$temp_file" > /dev/null
picked_filename=$(<"$temp_file")
rm "$temp_file"

if [[ -z "${OUTFILE}" ]]; then
    echo "$picked_filename"
else
    echo "$picked_filename" > "${OUTFILE}"
fi
