#!/usr/bin/env bash

if [[ "${#}" -lt 3 ]]; then
    echo "Usage: ${0} TEMPLATE MSG1 MSG2" >&2
    exit 1
fi

if [[ -z "${IMGFLIP_USERNAME}" ]]; then
    echo "IMGFLIP_USERNAME is not set" >&2
    exit 1
fi

if [[ -z "${IMGFLIP_PASSWORD}" ]]; then
    echo "IMGFLIP_PASSWORD is not set" >&2
    exit 1
fi


TEMPLATE="${1}"
MSG1="${2}"
MSG2="${3}"

data="{'template_id': '${TEMPLATE}', 'username': '${IMGFLIP_USERNAME}', 'password': '${IMGFLIP_PASSWORD}', 'text0': '${MSG1}', 'text1': '${MSG2}'}"

# echo "${data}"

curl -s -X POST \
    -d "template_id=${TEMPLATE}" \
    -d "username=${IMGFLIP_USERNAME}" \
    -d "password=${IMGFLIP_PASSWORD}" \
    -d "text0=${MSG1}" \
    -d "text1=${MSG2}" \
    https://api.imgflip.com/caption_image | \
    jq -r .data.url
