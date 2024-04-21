#!/usr/bin/env bash

BALATRO_DIR="${HOME}/.local/share/Steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro"

adb shell am force-stop com.unofficial.balatro

adb shell rm -rf /data/local/tmp/balatro
adb shell mkdir -p /data/local/tmp/balatro/files/save/game

adb push "${BALATRO_DIR}"/settings.jkr "${BALATRO_DIR}"/1 /data/local/tmp/balatro/files/save/game/

adb shell run-as com.unofficial.balatro cp -r /data/local/tmp/balatro/files .
