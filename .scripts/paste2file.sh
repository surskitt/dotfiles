#!/usr/bin/env bash

export CLIPHIST_DB_PATH=/tmp/links.db

cliphist wipe
wl-copy -c
wl-paste --watch cliphist store
