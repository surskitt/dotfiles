#!/usr/bin/env bash

playpause() {
    case "${1}" in
        ShairportSync)
            mpc -h mallard.lan toggle
            ;;
        spotify)
            playerctl -p spotify play-pause
            ;;
        *)
            echo "Error: player ${1} not handled" >&2
            ;;
    esac
}

previous() {
    case "${1}" in
        ShairportSync)
            mpc -h mallard.lan prev
            ;;
        spotify)
            playerctl -p spotify previous
            ;;
        *)
            echo "Error: player ${1} not handled" >&2
            ;;
    esac
}

next() {
    case "${1}" in
        ShairportSync)
            mpc -h mallard.lan next
            ;;
        spotify)
            playerctl -p spotify next
            ;;
        *)
            echo "Error: player ${1} not handled" >&2
            ;;
    esac
}

player="$(playerctl metadata -f "{{ playerName }}")"

case "${1}" in
    play-pause)
        playpause "${player}"
        ;;
    previous)
        previous "${player}"
        ;;
    next)
        next "${player}"
        ;;
    *)
        echo "Error: command ${1} not recognised" >&2
        ;;
esac
