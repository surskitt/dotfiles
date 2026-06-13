#!/usr/bin/env bash

TAG="${1}"
FLAC="${2}"

temp="$(mktemp)"
trap 'rm -- "${temp}"' EXIT

metaflac --show-tag="${TAG}" "${FLAC}" | cut -d = -f 2 >"${temp}"

line_count="$(wc -l <"${temp}")"

if [[ "${line_count}" -le 1 ]]; then
    exit
fi

while read line; do
    metaflac --remove-tag="${TAG}" "${FLAC}"
done <"${temp}"

vim "${temp}"

while read line; do
    metaflac --set-tag="${TAG}"="${line}" "${FLAC}"
done <"${temp}"
