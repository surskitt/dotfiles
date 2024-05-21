#!/usr/bin/env bash

BALATRO_DIR="${HOME}/.local/share/Steam/steamapps/compatdata/2379780/pfx/drive_c/users/steamuser/AppData/Roaming/Balatro"
BACKUP_DIR="${HOME}/backups/balatro/saves/$(date "+%Y%m%d_%H%M%S")"

mkdir -p "${BACKUP_DIR}"

cp -v "${BALATRO_DIR}/settings.jkr" "${BACKUP_DIR}"/
cp -v -r "${BALATRO_DIR}"/[123] "${BACKUP_DIR}"/
