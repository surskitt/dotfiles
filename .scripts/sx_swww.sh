#!/usr/bin/env bash

img="$(fd . ~/pics/wallpapers -t f | nsxiv -ifto | head -n 1)"

if [[ -z "${img}" ]] ; then
    exit 1
fi

ln -sf "${img}" ~/.local/share/backgrounds/1.jpg

swww img --transition-type fade ~/.local/share/backgrounds/1.jpg
