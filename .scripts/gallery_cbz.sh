#!/usr/bin/env bash

tempdir=$(mktemp -d)
gallery-dl -d "${tempdir}" "${1}"

for i in "${tempdir}"/*/*; do
    mv "${i}" "${i// /_}"
done

d="$(ls -d "${tempdir}"/*/*)"
name="${d##*/}"

if [ -f ~/downloads/"${name}".cbz ]; then
    exit
fi

zip -ryq ~/downloads/"${name}".cbz "${d}"
echo ~/downloads/"${name}".cbz
