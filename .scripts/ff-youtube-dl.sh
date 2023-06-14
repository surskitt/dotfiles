#!/usr/bin/env bash

TAB="	"

bt="$(brotab query +active)"
title="$(cut -d "${TAB}" -f 2 <<< "${bt}")"
url="$(cut -d "${TAB}" -f 3 <<< "${bt}")"

notify-send "Downloading video with yt-dlp" "${title}"

youtube-dl.sh "${url}"
