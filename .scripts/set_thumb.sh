#!/usr/bin/env bash

if [[ "${#}" -lt 2 ]]; then
    echo "Usage: $0 [FILE] [THUMB]" >&2
    exit 1
fi

FILE="${1}"
THUMB="${2}"

for i in "${FILE}" "${THUMB}"; do
    if [[ ! -f "${i}" ]]; then
        echo "Error: ${i} does not exist" >&2
        exit 1
    fi
done

FILE_DIR="$(dirname "${FILE}")"

mkdir -p "${FILE_DIR}/.thumbs"

SUM="$( echo -n "${FILE##*/}" | sha1sum | cut -d ' ' -f 1)"

echo "creating ${FILE_DIR}/.thumbs/${SUM}.jpg"

cp "${THUMB}" "${FILE_DIR}/.thumbs/${SUM}.jpg"
