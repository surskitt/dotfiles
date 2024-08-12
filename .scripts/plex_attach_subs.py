#!/usr/bin/env python

import argparse
import os
import sys
import pathlib

import plexapi.server
import plexapi.exceptions

parser = argparse.ArgumentParser()
parser.add_argument("--token", "-t", required=True)
parser.add_argument("--url", "-u", required=True)
parser.add_argument("--path", "-p", required=True)
args = parser.parse_args()

name = pathlib.Path(args.path).stem

plex = plexapi.server.PlexServer(args.url, args.token)

try:
    series = plex.library.section("TV").get(name)
except plexapi.exceptions.NotFound:
    print(f"Error: {args.series} not found", file=sys.stderr)
    sys.exit(1)

print(f"Attaching subs for \"{series.title}\"")

for e in series.episodes():
    loc = os.path.basename(e.locations[0])
    sub = pathlib.Path(loc).stem + ".ass"

    print(f"Attaching {sub} to {loc}")

    e.uploadSubtitles(sub)
