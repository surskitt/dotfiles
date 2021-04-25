#!/usr/bin/env bash

WHITE="#e5e9f0"
PINK="#bf616a"
BROWN="#ebcb8b"

echo ""

# if [[ "${1}" == monitor ]]; then
case "${1}" in
    monitor)
        mosquitto_sub -t noise/control | while read -r m; do
            case "${m}" in
                whitenoise)
                    echo "%{F${WHITE}}"
                    ;;
                pinknoise)
                    echo "%{F${PINK}}"
                    ;;
                brownnoise)
                    echo "%{F${BROWN}}"
                    ;;
                stop)
                    echo ""
                    ;;
                *)
            esac
        done
        ;;
    stop)
        noise.sh stop
        ;;
    *)
        noise.sh next
        ;;
esac
