#!/usr/bin/env bash

TAB="	"

if [ "${#}" -eq 0 ]; then
    dir="."
else
    dir="${1}"
fi

if ! [ -d "${dir}" ]; then
    echo "error: ${dir} is not a directory" >&2
    exit 1
fi

mkdir -p "${dir}/.thumbs"
THUMB_FILE=${dir}/.thumbs/thumbs.tsv

no_refresh=true

current="$(ls -l1 "${dir}" "${dir}"/*/.folder 2>/dev/null)"
if [ -f "${dir}/.thumbs/last.txt" ]; then
    last="$(< "${dir}/.thumbs/last.txt")"
fi

if [[ "${last}" != "${current}" ]]; then
    no_refresh=false
fi

echo "${current}" > "${dir}/.thumbs/last.txt"

if [[ -f "${THUMB_FILE}" && $no_refresh == true ]]; then
    fl=$(sort -t "${TAB}" -k 2 "${THUMB_FILE}")
else
    f=$(find "${dir}" -maxdepth 1 -not -path '*/\.*' -not -path "${dir}" -not -iname '*-pt[2-9]*')
    
    fl=$(echo "${f}"|while read -r fn; do
        p=$(previewer.sh "${fn}")

        echo "${p}${TAB}${fn##*/}"
    done|sort -t "${TAB}" -k 2)

    echo "${fl}" > "${THUMB_FILE}"
fi

s=$(echo "${fl}"|while IFS=$"${TAB}" read -r fn _; do echo "${fn}"; done|sxiv -ftio|head -1)

if [[ "${s}" == "" ]]; then
    exit
fi

grep "${s}" <<< "${fl}"|cut -d "${TAB}" -f 2
