#!/usr/bin/env bash

export TS_SOCKET=/tmp/socket-ts.yt

_tsp() {
    if hash tsp 2>/dev/null; then
        tsp "${@}"
    else
        "${@}"
    fi
}

ytdl() {
        # --format 'bestvideo[height<=1080]+bestaudio/best[height<=1080]' \
    _tsp yt-dlp \
        --ignore-config \
        --no-color \
        --no-playlist \
        --mark-watched \
        --merge-output-format mkv \
        --ignore-errors \
        --retries 10 \
        --no-mtime \
        --sub-lang en,en_US \
        --write-sub \
        --embed-subs \
        --add-metadata \
        --output "${fn}" \
        --downloader aria2c \
        --download-archive "${outdir}/downloads.txt" \
        --cookies ~/.local/share/youtube-dl/cookies.txt \
        "${@}"
}

playlist_name() {
    yt-dlp \
        --playlist-items 1 \
         -s \
        --get-filename \
        --cookies ~/.local/share/youtube-dl/cookies.txt \
        -o '%(playlist_title)s - %(playlist_id)s' \
        ${@}
}

for f in ${@}; do
    echo "${pl}"

    if [ "${pl}" == "NA - NA" ]; then
        outdir="$HOME/ytdl"
    else
        outdir="$HOME/ytdl/playlists/${pl}"
        mkdir -p "${outdir}"
        echo "${f}" > "${outdir}/url.txt"
    fi

    fn="${outdir}/%(upload_date)s - %(title)s - %(id)s (%(extractor)s).%(ext)s"

    ytdl "${f}"
done
