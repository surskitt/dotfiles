#!/usr/bin/env bash

current_alpha="$(xrdb -query -get alpha)"

if [[ "${current_alpha}" != 1 ]]; then
    new_alpha=1
else
    new_alpha=0.85
fi

cat << EOF > ~/.Xresources.d/xst_alpha.Xresources
*.alpha: ${new_alpha}
EOF

xrdb ~/.Xresources
killall -USR1 st
