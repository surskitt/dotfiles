#!/usr/bin/env python

import argparse
import json
import pathlib
import sys

import mutagen.flac

argparser = argparse.ArgumentParser(
    prog="flac_replace_tag_multi", description="Replace a tag in multiple files"
)

argparser.add_argument("-n", "--non-latin", action="store_true")
argparser.add_argument("-c", "--cache")
argparser.add_argument("tag")
argparser.add_argument("fns", nargs="+")

args = argparser.parse_args()

replacements = {}

if args.cache:
    json_file = pathlib.Path(args.cache)

    if not json_file.exists():
        print(f"Error: cache {args.cache} not found", file=sys.stderr)
        sys.exit(1)

    replacements = json.loads(json_file.read_text())

    print(f"Read {len(replacements)} replacements from cache")


flacs = [mutagen.flac.FLAC(i) for i in args.fns]

unique_vals = {val for flac in flacs for val in flac.tags.get(args.tag, [])}

if args.non_latin:
    unique_vals = [i for i in unique_vals if not all(j.isascii() for j in i)]

remaining = [i for i in unique_vals if i not in replacements]

print(f"{len(remaining)} replacements remaining")

for val in unique_vals:
    if val in replacements:
        print(f"Reading from cache: {val} -> {replacements[val]}")
        continue

    new_val = input(f"{val}: ")

    if new_val == "":
        replacements[val] = val
    else:
        replacements[val] = new_val

    if args.cache:
        json_file.write_text(json.dumps(replacements, indent=2))

for flac in flacs:
    vals = flac.tags.get(args.tag, [])

    new_vals = [replacements[i] if i in replacements else i for i in vals]

    flac.tags[args.tag] = new_vals

    flac.save()
