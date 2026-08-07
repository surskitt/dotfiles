#!/usr/bin/env python

import argparse
import glob
import os
import pathlib
import sys

import mutagen.flac

argparser = argparse.ArgumentParser(
    prog="flac_tagger", description="Simple ops dir renamer"
)

working_dir = os.environ.get("PWD")
argparser.add_argument("dir", nargs="?", default=working_dir, type=pathlib.Path)
argparser.add_argument("-p", "--prefix", default="-")

args = argparser.parse_args()

flac_fns = args.dir.glob("**/*.flac")

flacs = [(i, mutagen.flac.FLAC(i)) for i in flac_fns]

if len(flacs) == 0:
    print("Error: no flacs found", file=sys.stderr)
    sys.exit(1)

album_artists = {
    (
        "Various Artists"
        if len(f.tags.get("ALBUMARTIST")) >= 3
        else " _ ".join(f.tags.get("ALBUMARTIST"))
    )
    for _, f in flacs
}

albums = {f.tags.get("ALBUM")[0] for _, f in flacs}
years = {f.tags.get("YEAR")[0] for _, f in flacs}
releaseyears = {
    f.tags.get("RELEASEYEAR")[0] for _, f in flacs if f.tags.get("RELEASEYEAR")
}
labels = {f.tags.get("LABEL")[0] for _, f in flacs}
upcs = {f.tags.get("UPC")[0] for _, f in flacs if f.tags.get("UPC")}
catnos = {
    f.tags.get("CATALOGNUMBER")[0] for _, f in flacs if f.tags.get("CATALOGNUMBER")
}
versions = {
    f.tags.get("ALBUMVERSION")[0] for _, f in flacs if f.tags.get("ALBUMVERSION")
}

for tags, msg in [
    (album_artists, "directory flacs contain more than one set of album artists"),
    (albums, "directory flacs contain more than one album"),
    (years, "directory flacs contain more than one year"),
    (releaseyears, "directory flacs contain more than one releaseyear"),
    (labels, "directory flacs contain more than one label"),
    (upcs, "directory flacs contain more than one upc"),
    (catnos, "directory flacs contain more than one upc"),
    (versions, "directory flacs contain more than one version"),
]:
    if len(tags) > 1:
        print(f"Error: {msg}", file=sys.stderr)
        sys.exit(1)

upccatnos = upcs or catnos or {""}
# ryears = releaseyears or years
ryears = years

album_artist = album_artists.pop()
album = albums.pop()
ryear = ryears.pop()
label = labels.pop()
upccatno = upccatnos.pop()

bit_depth = max(f.info.bits_per_sample for _, f in flacs)
sample_rate = str(
    round(max(f.info.sample_rate for _, f in flacs) / 1000, 1)
).removesuffix(".0")

if len(versions) == 1:
    version = versions.pop()

    album = f"{album} ({version})"

release_type = "WEB"
flac_info = f"FLAC {bit_depth}-{sample_rate}"

if len(list(args.dir.glob("**/*.log")) + list(args.dir.glob("**/*.cue"))) > 1:
    release_type = "CD"
    flac_info = "FLAC"

new_dir_name = f"{args.prefix}{album_artist} - {album} ({ryear}) {{{label}, {upccatno}}} [{release_type} {flac_info}]"

for i in ["/", "?", '"', "*", "|"]:
    new_dir_name = new_dir_name.replace(i, "_")

for i in [":"]:
    new_dir_name = new_dir_name.replace(i, "-")

new_dir = args.dir.parent.joinpath(new_dir_name)

if args.dir != new_dir:
    print(args.dir)
    print("->")
    print(new_dir)
    os.rename(args.dir, new_dir)
