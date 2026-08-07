#!/usr/bin/env python

import argparse
import os
import pathlib
import sys

import mutagen.flac

MUSIC_DIR = "/mnt/nfs/mallard/media/music"

argparser = argparse.ArgumentParser(
    prog="flac_link", description="Link flacs to music dir"
)

argparser.add_argument("-d", "--dir", default=os.environ.get("PWD"), type=pathlib.Path)
argparser.add_argument("-o", "--dest", default=MUSIC_DIR, type=pathlib.Path)

args = argparser.parse_args()

fns = args.dir.glob("**/*.flac")

flacs = [(i, mutagen.flac.FLAC(i)) for i in fns]

album_artists = {
    j for _, i in flacs if i.tags.get("ALBUMARTIST") for j in i.tags.get("ALBUMARTIST")
}
artists = {j for _, i in flacs if i.tags.get("ARTIST") for j in i.tags.get("ARTIST")}
albums = {j for _, i in flacs if i.tags.get("ALBUM") for j in i.tags.get("ALBUM")}

if len(album_artists) > 1:
    print("Error: tags contain more than one ALBUMARTIST", file=sys.stderr)
    sys.exit(1)

if len(album_artists) == 0 and len(artists) > 1:
    print("Error: tags contain no ALBUMARTIST and multiple ARTIST", file=sys.stderr)
    sys.exit(1)

if len(album_artists) == 0 and len(artists) == 0:
    print("Error: tags contain no ALBUMARTIST or ARTIST tags", file=sys.stderr)
    sys.exit(1)

if len(albums) > 1:
    print("Error: tags contain more than one ALBUM", file=sys.stderr)
    sys.exit(1)

nos = [i.tags.get("TRACKNUMBER") for _, i in flacs]
titles = [i.tags.get("TITLE") for _, i in flacs]

for _, flac in flacs:
    for tag in ["TRACKNUMBER", "TITLE"]:
        tag_val = flac.tags.get(tag)
        if not tag_val or len(tag_val) > 1:
            print(
                f"Error: flacs have missing or invalid values for {tag}",
                file=sys.stderr,
            )

if album_artists:
    artist = album_artists.pop()
else:
    artist = artists.pop()

album = albums.pop()

if artist == "Various Artists":
    album_dest_path = args.dest.joinpath("#Compilations", album)
else:
    album_dest_path = args.dest.joinpath(artist, album)

album_dest_path.mkdir(parents=True, exist_ok=True)

for f, flac in flacs:
    no = flac.tags.get("TRACKNUMBER").pop()
    title = flac.tags.get("TITLE").pop().replace("/", "_")

    filename = f"{no:0>2} - {title}.flac"

    flac_dest = album_dest_path.joinpath(filename)

    if flac_dest.exists():
        continue

    print(f)
    print("->")
    print(flac_dest)
    print()

    flac_dest.hardlink_to(f)

for f in args.dir.glob("*.jpg"):
    dest = album_dest_path.joinpath(f.name)

    if dest.exists():
        continue

    print(f)
    print("->")
    print(dest)
    print()

    dest.hardlink_to(f)
