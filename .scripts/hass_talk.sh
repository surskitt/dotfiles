#!/usr/bin/env bash

TEXT="${*}"

if [[ -z "${TEXT}" ]] ; then
    read -p "Home assistant: " TEXT
fi

HASS_URL="hass.$(gopass mallard_domain)"
HASS_API_KEY="$(gopass hass_api_key)"

curl -L -X POST \
    -H "Authorization: Bearer ${HASS_API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"${TEXT}\"}" \
    "https://${HASS_URL}/api/services/conversation/process"
