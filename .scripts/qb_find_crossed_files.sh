#!/usr/bin/env bash

if [[ "${#}" -lt 1 ]] ; then
    echo "Error: missing torrent hash" >&2
    exit 1
fi

REMOTE_ROOT="/downloads"
LOCAL_ROOT="/mnt/nfs/mallard/media/downloads/torrents"

hash="${1}"

mallard_domain="$(gopass mallard_domain)"
qb_host="https://qb.${mallard_domain}"

properties="$(curl -s "${qb_host}/api/v2/torrents/properties?hash=${hash}")"
contents="$(curl -s "${qb_host}/api/v2/torrents/files?hash=${hash}")"

# jq . <<< "${contents}"

main_file="$(jq -r '. | sort_by(.size) | .[-1] | .name' <<< "${contents}")"

root_dir="$(jq -r '.save_path' <<< "${properties}")"
local_root_dir="${LOCAL_ROOT}/${root_dir#"${REMOTE_ROOT}"}"

fl="${local_root_dir}/${main_file}"
find /mnt/nfs/mallard -samefile "${fl}"
