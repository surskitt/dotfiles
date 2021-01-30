#!/usr/bin/env bash

usage() {
    echo "nah"
}

export TAB="	"

MPD_HOST=localhost

while getopts 'H:h' opt; do
    case "${opt}" in
        H)
            MPD_HOST="${OPTARG}"
            ;;
        h)
            usage
            exit
            ;;
        ?)
            usage >&2
            exit 1
    esac
done
shift $(( OPTIND - 1 ))

mpc -h "${MPD_HOST}" listall -f "[%albumartist%|%artist%] - %album%${TAB}%mdate%${TAB}%file%" | \
    while read -r a; do echo "${a%/*}"; done | \
    sort -u | \
    sort -t "${TAB}" -k 2.7n -k 2.8n -k 2.1n -k 2.2n -k 2.4n -k 2.5n | \
    tac | \
    fzf +s --layout=reverse-list -m -d "${TAB}" --with-nth 1 | \
    cut -d "${TAB}" -f 3 | \
    while read -r s; do
        mpc -h "${MPD_HOST}" add "${s}"
    done
