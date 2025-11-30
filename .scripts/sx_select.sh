#!/usr/bin/env bash

TAB="	"

shopt -s extglob
shopt -s nullglob

# if [ "${#}" -eq 0 ]; then
#     dir="${PWD}"
# else
#     dir="${1}"
# fi

fs=(
    */.folder
    *.jpg
    *.gif
    *.png
    .thumbs/!(*-pt[2-9]).jpg
    .thumbs/*.gif
)

if [[ "${#fs[@]}" -eq 0 ]] ; then
    echo "No thumbs found"
    exit
fi

# selected="$(
#     for img in "${fs[@]}" ; do
#         echo "${img}"
#     done | sxiv -ftio | head -1
# )"

selected="$(sxiv -afto -- "${fs[@]}" | head -1)"

if [[ -z "${selected}" ]] ; then
    echo "No thumb selected"
    exit
fi

case "${selected}" in
    */.folder)
        echo "${selected%/.folder}"
        ;;
    .thumbs/*)
        fn="${selected#*/}"
        fnn="${fn%.*}"
        ls "${fnn}".* 2>/dev/null | head -1
        ;;
    *)
        echo "${selected}"
        ;;
esac
