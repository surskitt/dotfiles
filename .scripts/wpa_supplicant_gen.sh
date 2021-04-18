#!/usr/bin/env bash

if [[ "${#}" -lt 2 ]]; then
    echo "Usage: ${0} WIFI_SSID WIFI_PASS [PATH]" >&2
    exit 1
fi

WIFI_SSID="${1}"
WIFI_PASS="${2}"
FILE_PATH="${3}"

w() {
    if [[ ! -z "${FILE_PATH}" ]]; then
        cat > "${FILE_PATH}/wpa_supplicant.conf"
    else
        cat
    fi
}

cat << EOF | w
country=gb
update_config=1
ctrl_interface=/var/run/wpa_supplicant

network={
  scan_ssid=1
  ssid="${WIFI_SSID}"
  psk="${WIFI_PASS}"
}
EOF
