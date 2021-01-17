#!/usr/bin/env bash

# monitor 1 writes to log
# monitors 2 and 3 read from log

trap 'kill $(jobs -p)' EXIT

ACTIVE_C="#d8dee9"
INACTIVE_C="#4c566a"
SELECTED_C="#ebcb8b"

while getopts "ua:i:s:" flag; do
    case "${flag}" in
        u)
            USER_ARG="--user "
            ;;
        a)
            ACTIVE_C="${OPTARG}"
            ;;
        i)
            INACTIVE_C="${OPTARG}"
            ;;
        s)
            SELECTED_C="${OPTARG}"
            ;;
        *)
            ;;
    esac
done
shift $(( OPTIND-1 ))

services=()
icons=()
for i in "${@}"; do
    services+=("${i%=*}")
    icons+=("${i#*=}")
done

service_count=$(( "${#services[@]}" - 1 ))

FIFO="/tmp/poly_systemctl_monitor.fifo"
touch "${FIFO}"

selected=0

bump_preselect() {
    case "${selected}" in
        [0-${service_count}])
            selected=$(( selected + 1))
            ;;
        *)
            selected=1
            ;;
    esac
}

j_states() {
    svc_out=

    for s in $(seq ${#services[@]}); do
        svc="${services[${s}-1]}"
        icon="${icons[${s}-1]}"

        # shellcheck disable=2086
        state="$(systemctl ${USER_ARG} is-active "${svc}")"

        case "${state}" in
            active)
                svc_out="${svc_out}+${icon}"
                ;;
            inactive)
                svc_out="${svc_out}-${icon}"
                ;;
        esac
    done

    echo "${svc_out}"
}

unit_args() {
    for i in "${@}"; do
        echo -n "--unit ${i} "
    done
    echo
}

process_journalctl() {
    # shellcheck disable=2046,2086
    journalctl -n 1 ${USER_ARG} -f -o cat $(unit_args "${services[@]}") | while read -r; do
        s="$(j_states)"
        # shellcheck disable=2001
        ns=$(sed "s/[+-]//g" <<< "${s}")
        
        if [[ "${ns}" != "" ]]; then
            echo "log:${s}" >> "${FIFO}"
        fi
    done
}

preselect_n() {
    n="$(( ${2} + (1*(${2}-1)) - 1 ))"
    echo "${1}" | sed -E -e "s/(.{${n}})(.)(.*)/\1_\3/"
}

colour() {
    echo "${1}" | sed "s/+/ %{F${ACTIVE_C}}/g;s/-/ %{F${INACTIVE_C}}/g;s/_/ %{F${SELECTED_C}}/g" | cut -c2-
}

write_log() {
    process_journalctl &

    tail -n 1 -f "${FIFO}" | while read -r line; do
        command="${line%:*}"
        args="${line#*:}"

        case "${command}" in
            log)
                colour "${args}"
                ;;
            preselect_next)
                bump_preselect
                ps=$(preselect_n "$(j_states)" "${selected}")
                echo "log:${ps}" >> "${FIFO}"
                ;;
            select)
                if [[ "${selected}" != 0 ]]; then
                    systemctl_toggle.sh -u "${services[${selected}-1]}"
                fi
                selected=0
                ;;
        esac
    done
}

read_log() {
    tail -n 1 -f "${FIFO}" | while read -r line; do
        command="${line%:*}"
        args="${line#*:}"

        if [[ "${command}" == "log" ]]; then
            colour "${args}"
        fi
    done
}

if [[ "${MONITOR_ID}" -eq 1 ]]; then
    write_log
else
    read_log
fi
