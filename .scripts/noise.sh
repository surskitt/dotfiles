#!/usr/bin/env bash

if [[ "${#}" -lt 1 ]]; then
    CMD=daemon
else
    CMD="${1}"
fi

cycle() {
    case "${1}" in
        whitenoise)
            echo "pinknoise"
            ;;
        pinknoise)
            echo "brownnoise"
            ;;
        brownnoise)
            echo "whitenoise"
            ;;
        *)
            echo "whitenoise"
            ;;
    esac
}

daemon() {
    if [[ "$(fuser "${0}" 2>/dev/null)" != " ${BASHPID}" ]]; then
        echo "Error: daemon is already running" >&2
        exit 1
    fi

    echo "Listening for commands"

    sox_pid=
    colour=

    mosquitto_sub -t noise/control | while read -r m; do
        if [[ "${m}" == "next" ]]; then
            colour="$(cycle ${colour})"
            mosquitto_pub -t noise/control -m "${colour}"
            continue
        else
            colour="${m}"
        fi

        if [[ -n "${sox_pid}" ]]; then
            kill "${sox_pid}"
        fi

        if [[ "${m}" == "stop" ]]; then
            continue
        fi

        sleep .5

        play -n -n --combine merge synth '24:00:00' "${colour}" &
        sox_pid=$!
    done
}

case "${CMD}" in
    daemon)
        daemon
        ;;
    white)
        mosquitto_pub -t noise/control -m whitenoise
        ;;
    pink)
        mosquitto_pub -t noise/control -m pinknoise
        ;;
    brown)
        mosquitto_pub -t noise/control -m brownnoise
        ;;
    next)
        mosquitto_pub -t noise/control -m next
        ;;
    stop)
        mosquitto_pub -t noise/control -m stop
        ;;
    *)
        exit 1
        ;;
esac
