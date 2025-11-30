#!/usr/bin/env bash

if [[ "${#}" -lt 2 ]] ; then
    echo "Usage: ${0} width command" >&2
    exit 1
fi

width="${1}"
cmd="${*:2}"

output_info="$(niri msg --json focused-output)"
output_width="$(jq -r '.logical.width' <<< "${output_info}")"
output_height="$(jq -r '.logical.height' <<< "${output_info}")"

if [[ "${output_width}" -gt "${output_height}" ]] ; then
    sed -i "s/default-column-width.*/default-column-width { proportion ${width} ; }/" ~/.config/niri/config.kdl

    niri msg action load-config-file
fi

niri msg action spawn -- ${cmd[*]}

sed -i "s/default-column-width.*/default-column-width { proportion 1.0 ; }/" ~/.config/niri/config.kdl
