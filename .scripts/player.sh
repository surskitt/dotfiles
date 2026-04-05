#!/usr/bin/env bash

playpause() {
    player="${1}"
    case "${player}" in
        ShairportSync)
            mpc -h mallard.lan toggle
            ;;
        spotify|Feishin|mpd|firefox*)
            playerctl -p "${player}" play-pause
            ;;
        *)
            echo "Error: player ${1} not handled" >&2
            ;;
    esac
}

previous() {
    player="${1}"
    case "${player}" in
        ShairportSync)
            mpc -h mallard.lan prev
            ;;
        spotify|Feishin|mpd)
            playerctl -p "${player}" previous
            ;;
        *)
            echo "Error: player ${1} not handled" >&2
            ;;
    esac
}

next() {
    player="${1}"
    case "${player1}" in
        ShairportSync)
            mpc -h mallard.lan next
            ;;
        spotify|Feishin|mpd)
            playerctl -p "${player}" next
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
