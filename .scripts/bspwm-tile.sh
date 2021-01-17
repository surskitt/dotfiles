#!/usr/bin/env bash

desktop="$(bspc query -D -d '.focused' --names)"

mapfile -t nodes < <(bspc query -N -d "${desktop}" -n '.window')

ns() {
    bspc node "${3}" -o "${1}" -p "${2}"
    bspc node "${4}" -n "${3}"
}

hori() {
    ns "${1}" south "${2}" "${3}"
}

verti() {
    ns "${1}" east "${2}" "${3}"
}

verti3() {
    verti .333 "${1}" "${2}"
    verti .5 "${2}" "${3}"
}

hori3() {
    hori .333 "${1}" "${2}"
    hori .5 "${2}" "${3}"
}

case "${#nodes[@]}" in
    1)
        ;;
    2)
        ns 0.5 east "${nodes[0]}" "${nodes[1]}"
        ;;
    3)
        verti3 "${nodes[0]}" "${nodes[1]}" "${nodes[2]}"
        ;;
    4)
        ns 0.5 east "${nodes[0]}" "${nodes[1]}"
        ns 0.5 east "${nodes[2]}" "${nodes[3]}"

        ns 0.5 south "${nodes[0]}" "${nodes[2]}"
        ns 0.5 south "${nodes[1]}" "${nodes[3]}"
        ;;
    5)
        ;;
    6)
        ;;
    7)
        ;;
    8)
        ;;
    9)
        verti3 "${nodes[0]}" "${nodes[3]}" "${nodes[6]}"
        verti3 "${nodes[1]}" "${nodes[4]}" "${nodes[7]}"
        verti3 "${nodes[2]}" "${nodes[5]}" "${nodes[8]}"

        hori3 "${nodes[0]}" "${nodes[1]}" "${nodes[2]}"
        hori3 "${nodes[3]}" "${nodes[4]}" "${nodes[5]}"
        hori3 "${nodes[6]}" "${nodes[7]}" "${nodes[8]}"
        ;;
esac
