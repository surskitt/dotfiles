#!/usr/bin/env bash

PULL_DIR="${PWD}/pulled/$(date "+%Y%m%d_%H%M%S")"

mkdir -p "${PULL_DIR}"

adb shell rm -rf /data/local/tmp/balatro

adb shell mkdir -p /data/local/tmp/balatro/files/1

# adb shell touch /data/local/tmp/balatro/files/settings.jkr
# adb shell touch /data/local/tmp/balatro/files/1/{meta,save,profile}.jkr

for f in settings.jkr 1/{meta,save,profile}.jkr ; do
    adb shell touch /data/local/tmp/balatro/files/"${f}"
    adb shell run-as com.unofficial.balatro "cat files/save/game/${f} > /data/local/tmp/balatro/files/${f}"
done

adb pull /data/local/tmp/balatro/files/. "${PULL_DIR}"/
find "${PULL_DIR}" -type f -empty -delete
