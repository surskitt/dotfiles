#!/usr/bin/env bash

ONE_MON_DESKTOPS=$(cat <<'EOF'
internet 0
coding 0
chat 0
music 0
video 0
books 0
files 0
files2 0
files3 0
windows 0
EOF
)

TWO_MON_DESKTOPS=$(cat <<'EOF'
internet 0
coding 1
chat 1
music 1
video 1
books 0
files 0
files2 1
files3 0
windows 1
EOF
)

THREE_MON_DESKTOPS=$(cat <<'EOF'
internet 0
coding 1
chat 2
music 2
video 2
books 2
files 0
files2 1
files3 2
windows 2
EOF
)

MON_DESKTOPS_ARRAY=(
    "${ONE_MON_DESKTOPS}"
    "${TWO_MON_DESKTOPS}"
    "${THREE_MON_DESKTOPS}"
)

MONITOR_COUNT="$(bspc query -M | wc -l)"

MON_DESKTOPS_INDEX="$(( "${MONITOR_COUNT}" - 1 ))"
MON_DESKTOPS="${MON_DESKTOPS_ARRAY[${MON_DESKTOPS_INDEX}]}"

mapfile -t MONITORS < <(bspc query -M --names)

while read -r d m; do
    if bspc query -D --names | grep -q "${d}" ; then
        bspc desktop "${d}" -m "${MONITORS[${m}]}"
    else
        bspc monitor "${MONITORS[${m}]}" -a "${d}"
    fi
done <<< "${MON_DESKTOPS}"

# remove default desktops
while bspc desktop Desktop -r 2>/dev/null ; do : ; done

# focus main desktops
bspc desktop -f chat
bspc desktop -f internet
bspc desktop -f coding
