#!/usr/bin/env bash

if [[ "${#}" -lt 2 ]] ; then
    echo "Usage: ${0} TAG FLAC" >&2
    exit 1
fi

tag="${1}"
flac="${2}"

existing="$(metaflac --show-tag="${tag}" "${flac}" | cut -d '=' -f 2)"

if [[ -z "${existing}" ]] ; then
    echo "Error: tag ${tag} not found" >&2
    exit 1
fi

titlecased="$(titlecase <<< "${existing}")"

echo "File: ${flac}"
echo "Existing: ${existing}"
if [[ "${existing}" != "${titlecased}" ]] ; then
    echo "Title case: $(titlecase <<< "${existing}")"
fi
echo -n "New value: "
read -r new

if [[ -n "${new}" ]] ; then
    metaflac --remove-tag="${tag}" "${flac}"
    metaflac --set-tag="${tag}"="${new}" "${flac}"
fi
