#!/usr/bin/env bash

TEXT="${*}"

if [[ -z "${TEXT}" ]] ; then
    read -p "Home assistant: " TEXT
fi

# AUTH="$(
# cat << EOF
# {
#     "Authorization": "Bearer ${HASS_API_KEY}",
#     "content-type": "application/json"
# }
# EOF
# )"

curl -X POST \
    -H "Authorization: Bearer ${HASS_API_KEY}" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"${TEXT}\"}" \
    "${HASS_URL}/api/services/conversation/process"
