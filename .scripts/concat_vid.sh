#!/usr/bin/env bash

output="${1}"
shift 1

for f in "${@}"; do
    echo "file '${f}'"
done > concat_vid

ffmpeg -f concat -safe 0 -i concat_vid -c copy "${output}"

rm concat_vid
