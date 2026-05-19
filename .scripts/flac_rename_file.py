#!/usr/bin/env python

import argparse
import os
import sys

import mutagen.flac

argparser = argparse.ArgumentParser(
    prog="flac_tagger", description="Simple flac renamer"
)

argparser.add_argument("flacs", nargs="+")

args = argparser.parse_args()

flacs = [(i, mutagen.flac.FLAC(i)) for i in args.flacs]

disc_count = len(
    {i.tags.get("DISCNUMBER")[0] for _, i in flacs if i.tags.get("DISCNUMBER")}
)

for fn, flac in flacs:
    track_number = flac.tags.get("TRACKNUMBER")

    if not track_number:
        print("Error: TRACKNUMBER tag is missing", file=sys.stderr)
        sys.exit(1)

    track_number = track_number[0].zfill(2)

    title = flac.tags.get("TITLE")

    if not title:
        print("Error: TITLE tag is missing", file=sys.stderr)
        sys.exit(1)

    title = title[0].replace("/", "_")

    output = f"{track_number} - {title}"

    if disc_count > 1:
        disc_number = flac.tags.get("DISCNUMBER")[0]

        output = f"{disc_number}.{output}"

    if len(flac.tags.get("ARTIST")) > len(flac.tags.get("ALBUMARTIST")):
        album_artist = flac.tags.get("ALBUMARTIST")
        artist = flac.tags.get("ARTIST")
        featured = ", ".join(i for i in artist if i not in album_artist)

        output = f"{output} (feat. {featured})"

    output = f"{output}.flac"

    if fn == output:
        continue

    print(f'Renaming "{fn}"')
    print(f"-> {output}")
    print()

    os.rename(fn, output)
