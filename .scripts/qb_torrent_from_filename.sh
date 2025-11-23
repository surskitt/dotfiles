#!/usr/bin/env bash

if [[ "${#}" -lt 1 ]] ; then
    echo "Error: missing file path" >&2
    exit 1
fi

REMOTE_ROOT="/downloads"
LOCAL_ROOT="/mnt/nfs/mallard/media/downloads/torrents"

fn="${1}"

remote_fn="${REMOTE_ROOT}${fn#"${LOCAL_ROOT}"}"

mallard_domain="$(gopass mallard_domain)"

torrents_info="$(curl -s "https://qb.${mallard_domain}/api/v2/torrents/info")"

# hashes="$(jq -r '.[].hash' <<< "${torrents_info}")"

# jq . <<< "${torrents_info}"

# for hash in ${hashes} ; do
#     echo "${hash}"
# done

# jq -c '.[]' <<< "${torrents_info}"

# for i in "$(jq -c '.[]' <<< "${torrents_info}")" ; do
#     echo yo
#     jq -r '.name' <<< "${i}"
# done

jq -c '.[]' <<< "${torrents_info}" | while read -r t ; do
    echo yo
    jq -r '.name' <<< "${t}"
done
