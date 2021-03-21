#!/bin/bash

# gallery_dl() {
#     tempdir=$(mktemp -d)
#     echo "jseval \"Downloading gallery... \"" >> "$QUTE_FIFO" 
#     gallery-dl -d "${tempdir}" "${1}"
#     for i in "${tempdir}"/*/*; do
#         mv "${i}" "${i// /_}"
#     done
#     # echo "jseval \"Combining images... \"" >> "$QUTE_FIFO"
#     # find "${tempdir}" -type f|sort|tail -n +2|xargs -n2|while read a b; do
#     # find "${tempdir}" -type f|sort|xargs -n2|while read a b; do
#     #    convert "$b" "$a" +append "$a"
#     #    rm "$b"
#     # done
#     feh -Z -Y -r -F "${tempdir}"
# }

# gallery_dl "$1"

echo "jseval \"Opening $1 using gallery-dl... \"" >> "$QUTE_FIFO"
gallery-dl -g "${1}" | feh -f -
# gallery_dl "$1" || echo "jseval \"Opening $1 using gallery-dl... failed\"" >> "$QUTE_FIFO"
