#!/usr/bin/env python

import argparse

import mutagen.flac


argparser = argparse.ArgumentParser(prog="flac_tagger", description="Simple flac tagger")

argparser.add_argument("-t", "--title", action="append")
argparser.add_argument("-a", "--artist", action="append")
argparser.add_argument("-A", "--albumartist", action="append")
argparser.add_argument("-b", "--album", action="append")
argparser.add_argument("-c", "--composer", action="append")
argparser.add_argument("-l", "--label", action="append")
argparser.add_argument("-g", "--genre", action="append")
argparser.add_argument("-d", "--date", action="append")
argparser.add_argument("-Y", "--year", action="append")
argparser.add_argument("-L", "--lyricist", action="append")
argparser.add_argument("-u", "--upc", action="append")
argparser.add_argument("-U", "--url", action="append")
argparser.add_argument("-v", "--version", action="append")
argparser.add_argument("flacs", nargs="+")

args = argparser.parse_args()

for f in args.flacs:
    flac = mutagen.flac.FLAC(f)

    if args.title:
        flac.tags["TITLE"] = args.title

    if args.artist:
        flac.tags["ARTIST"] = args.artist

    if args.albumartist:
        flac.tags["ALBUMARTIST"] = args.albumartist

    if args.album:
        flac.tags["ALBUM"] = args.album

    if args.composer:
        flac.tags["COMPOSER"] = args.composer

    if args.label:
        flac.tags["LABEL"] = args.label

    if args.genre:
        flac.tags["GENRE"] = args.genre

    if args.date:
        flac.tags["DATE"] = args.date
        flac.tags["RELEASEDATE"] = args.date

    if args.year:
        flac.tags["YEAR"] = args.year

    if args.lyricist:
        flac.tags["LYRICIST"] = args.lyricist

    if args.upc:
        flac.tags["UPC"] = args.upc

    if args.url:
        flac.tags["URL"] = args.url

    if args.version:
        flac.tags["VERSION"] = args.version

    flac.save()
