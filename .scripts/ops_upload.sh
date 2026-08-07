#!/usr/bin/env bash

set -euo pipefail

case "${PWD##*/}" in
-* | +* | =*)
    echo "Error: directory begins with symbol" >&2
    exit 1
    ;;
*)
    ;;
esac

album_summary.py

propolis \
    --metadata-root="$(mktemp -d)" \
    --no-overview \
    --no-specs \
    --only-problems \
    .

salmon check integrity .

case "${PWD}" in
*"WEB FLAC"*)
    upload_type=WEB
    ;;
*"CD FLAC"*)
    upload_type=CD
    ;;
*)
    echo "Error: could not figure out upload type" >&2
    exit 1
    ;;
esac

salmon up \
    --skip-up \
    --skip-mqa \
    --skip-integrity-check \
    -L $(for i in $(seq "$(ls *.flac | wc -l)"); do echo -n "-sp ${i} "; done) \
    -s "${upload_type}" \
    -t RED \
    "${PWD}"

echo

if [[ -f /tmp/red.txt ]]; then
    torrent_url="$(</tmp/red.txt)"

    red_api_key="$(gopass red_script_api_key)"
    imgbb_api_key="$(gopass imgbb_api_key)"

    update_gazelle_release_description.py -k "${red_api_key}" -i "${imgbb_api_key}" -u "${torrent_url}"
fi
