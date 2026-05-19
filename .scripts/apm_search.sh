#!/usr/bin/env bash

artist="$(metaflac --show-tag=ALBUMARTIST 01*.flac | cut -d '=' -f 2)"
album="$(metaflac --show-tag=ALBUM 01*.flac | cut -d '=' -f 2)"

firefox "https://music.apple.com/us/search?term=${artist} ${album}"
