#!/usr/bin/env python

import argparse

import rich
import rich.console
import titlecase
import mutagen.flac


TABLE_STYLE = {
    "box": rich.box.ROUNDED,
    "style": "blue",
    "row_styles": ["on black", ""],
}

argparser = argparse.ArgumentParser(prog="flac_titlecase_tag", description="Convert given tag to titlecase")

argparser.add_argument("-y", "--confirm", action="store_true")
argparser.add_argument("-l", "--lowercase", action="store_true")
argparser.add_argument("-u", "--uppercase", action="store_true")
argparser.add_argument("-q", "--quiet", action="store_true")
argparser.add_argument("-j", "--japanese", action="store_true")
argparser.add_argument("tag")
argparser.add_argument("flacs", nargs="+")

args = argparser.parse_args()

console = rich.console.Console()
table = rich.table.Table("Filename", "Current", "New", title=f"{args.tag} Tag Changes", **TABLE_STYLE)

def titlecase_callback(word, **kwargs):
    if args.japanese:
        if word.lower() in ["no", "wo", "na", "ni", "e", "ga", "de", "ha", "wa", "yo", "mo"]:
            return word.lower()

for f in args.flacs:
    flac = mutagen.flac.FLAC(f)

    val = flac.tags.get(args.tag)

    if val is None:
        table.add_row(f, "-", "-")
        continue

    if (not args.lowercase) and [i.lower() for i in val] == val:
        table.add_row(f, "\n".join(val), "-")
        continue

    if (not args.uppercase) and [i.upper() for i in val] == val:
        table.add_row(f, "\n".join(val), "-")
        continue

    new_val = [titlecase.titlecase(i, callback=titlecase_callback) for i in val]

    if val == new_val:
        table.add_row(f, "\n".join(val), "-")
        continue

    table.add_row(f, "\n".join(val), "\n".join(new_val))

    if args.confirm:
        flac.tags[args.tag] = new_val
        flac.save()

if not args.quiet:
    console.print(table)
