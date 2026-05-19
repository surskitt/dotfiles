#!/usr/bin/env python

import argparse
import json
import sys

import bs4
import mutagen.flac
import requests


def parse_args():
    argparser = argparse.ArgumentParser(
        prog="flac_deezer_tagger", description="tag flacs using deezer api"
    )

    argparser.add_argument("-U", "--url")
    argparser.add_argument("-y", "--confirm", action="store_true")
    argparser.add_argument("flacs", nargs="+")

    return argparser.parse_args()


args = parse_args()

flacs = [(fn, mutagen.flac.FLAC(fn)) for fn in args.flacs]

artists = {" ".join(f.tags.get("ALBUMARTIST")) for _, f in flacs}
albums = {f.tags.get("ALBUM")[0] for _, f in flacs}

if any(len(i) > 1 for i in (artists, albums)):
    print("Error: flacs have difference album artists or album names", file=sys.stderr)
    sys.exit(1)

artist = artists.pop()
album = albums.pop()

album_search_url = f"https://music.apple.com/us/search?term={artist} {album}"

r = requests.get(album_search_url)

soup = bs4.BeautifulSoup(r.content, features="lxml")
script_res = soup.find_all("script", id="serialized-server-data")

if len(script_res) != 1:
    print("Error: could not find a single data dict", file=sys.stderr)
    sys.exit(1)

j = json.loads(script_res[0].contents[0])

albums_section = j["data"][0]["data"]["sections"][2]

if len(albums_section["items"]) == 0:
    print("Error: no album results found", file=sys.stderr)
    sys.exit(1)

albums = []
for n, i in enumerate(albums_section["items"], 1):
    artist = i["subtitleLinks"][0]["title"]
    title = i["titleLinks"][0]["title"]
    cover = i["artwork"]["dictionary"]["url"].format(w=9999, h=9999, f="jpg")
    url = i["contentDescriptor"]["url"]

    print(f"{n}: {artist} - {title} - {url}")

    albums += [(artist, title, cover, url)]


if len(albums) == 1:
    album = albums[0]
else:
    print()
    choice = input(f"Result [1-{len(albums)}]: ")

    try:
        choice_i = int(choice) - 1
    except ValueError:
        print("Error: invalid choice", file=sys.stderr)
        sys.exit(1)

    try:
        album = albums[choice_i]
    except IndexError:
        print("Error: invalid choice", file=sys.stderr)
        sys.exit(1)

print()
artist, title, cover, url = album

print(f'Adding URL tag "{url}" to flac tags')

for _, flac in flacs:
    flac.tags["URL"] = url
    flac.save()

print(f'Downloading "{cover}" to cover.jpg')

r = requests.get(cover)
with open("cover.jpg", "wb") as f:
    f.write(r.content)
