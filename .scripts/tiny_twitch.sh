#!/usr/bin/env bash

if [[ "${#}" -lt 1 ]]; then
    echo "Usage: ${0} TWITCH_STREAMER" >&2
    exit 1
fi

TWITCH_STREAMER="${1}"
TWITCH_OAUTH=$(pass twitch_irc_oauth)

cat << EOF | envsubst > /tmp/tiny_twitch.yml
servers:
  - addr: irc.chat.twitch.tv
    port: 6697
    tls: true
    realname: sharktamer
    nicks: [sharktamer]

    join:
      - '#${TWITCH_STREAMER}'

    pass: ${TWITCH_OAUTH}

defaults:
  nicks: [sharktamer]
  realname: sharktamer
  join: []
  tls: false
EOF

tiny -c /tmp/tiny_twitch.yml
