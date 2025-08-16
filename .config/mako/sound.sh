#!/usr/bin/env bash

script_dir="$(dirname "${0}")"

mpv --loop=no --autocreate-playlist=no "${script_dir}"/ui_public_static_notification.ogg --volume=10
mpv --loop=no --autocreate-playlist=no "${script_dir}"/ui_public_static_notification.ogg
