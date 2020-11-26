#!/usr/bin/env bash

usage() {
    echo "Usage:"
}

SELECT_DIR=false

while getopts 's:h' opt ; do
    case "${opt}" in
        s)
            SELECT_DIR=true
            ;;
        h)
            usage
            exit
            ;;
        ?)
            echo "${OPTARG}"
            ;;
    esac
done

shift $((OPTIND -2))

if [ "${#}" -lt 2 ]; then
    echo "Usage: $0 SRC_DIR DEST_DIR" >&2
    exit 1
fi

SRC_DIR="${1}"
DEST_DIR="${2}"

for d in "${SRC_DIR}" "${DEST_DIR}"; do
    if [ ! -d "${d}" ]; then
        echo "Error: ${d} is not a directory" >&2
        exit 1
    fi
done


selected=$(find "${SRC_DIR}" | sxiv -ftio 2>/dev/null)

if [ -z "${selected}" ]; then
    exit
fi

if "${SELECT_DIR}"; then
    DEST_DIR="$(find "${DEST_DIR}" -type d | fzf +m --layout=reverse-list)"
fi

if [ -z "${DEST_DIR}" ]; then
    exit
fi

while read -r f; do
    mv "${f}" "${DEST_DIR}"
done <<< "${selected}"
