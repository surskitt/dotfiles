#!/usr/bin/env python

import os
import sys
import argparse
import pathlib
import urllib.parse
import itertools

import mutagen.flac
import requests
import rich
import rich.console

TABLE_STYLE = {
    "box": rich.box.ROUNDED,
    "style": "blue",
    "row_styles": ["on black", ""],
}


def parse_args():
    argparser = argparse.ArgumentParser(prog="flac_deezer_tagger", description="tag flacs using deezer api")

    argparser.add_argument("-U", "--url")
    argparser.add_argument("-y", "--confirm", action="store_true")
    argparser.add_argument("flacs", nargs="+")

    return argparser.parse_args()


def get_tags_all(flacs, tag):
    return {i for s in flacs for i in s.get(tag, [])}


def get_tag(flacs, tag):
    tags = get_tags_all(flacs, tag)

    if len(tags) != 1:
        return None

    return tags.pop()


def get_tags_joined(flacs, tag):
    tags = get_tags_all(flacs, tag)

    return " ".join(tags)


def get_id_from_url(url):
    if url is None:
        return None

    u = urllib.parse.urlsplit(url)

    if not u.hostname.endswith("deezer.com"):
        return None

    path_split = u.path.split("/")

    if len(path_split) < 2:
        return None

    t = path_split[-2]
    id = path_split[-1]

    if t != "album" and not id.isdigit():
        return None

    return id


def get_api_albums(artist, album):
    if not all([artist, album]):
        return None

    r = requests.get("https://api.deezer.com/search/album", params={"q": f"{artist} {album}"})
    rj = r.json()
    return rj["data"]


def pick_from_list(l):
    length = len(l)

    if length == 0:
        return None

    if length == 1:
        return 0

    for n, i in enumerate(l, 1):
        print(f"{n}: {i}")

    choice = input(f"Result [1-{length}]: ")

    try:
        choice_i = int(choice) - 1
    except ValueError:
        return None

    try:
        result = l[choice_i]
    except IndexError:
        return None

    return choice_i


def format_album_result(res):
        res_artist = res["artist"]["name"]
        res_album = res["title"]
        link = res["link"]

        return f"{res_artist} - {res_album} ({link})"


def set_tags(tag_name, tag_value, tag_dict, table):
    tag_dict[tag_name] = tag_value
    if type(tag_value) is list:
        tag_value = "\n".join(tag_value)
    table.add_row(tag_name, tag_value)


def main():
    args = parse_args()

    url = args.url
    album_id = get_id_from_url(url)

    flacs = {i: mutagen.flac.FLAC(i) for i in args.flacs}

    if not album_id:
        url = get_tag(flacs.values(), "URL")
        album_id = get_id_from_url(url)

    if not album_id:
        artists = get_tags_all(flacs.values(), "ALBUMARTIST")
        album = get_tag(flacs.values(), "ALBUM")

        artists = [s for i in artists for s in i.split(",")]

        results = []
        for artist in artists:
            r = requests.get("https://api.deezer.com/search/album", params={"q": f"{artist} {album}"})
            rj = r.json()
            results += rj["data"]

        rd = {res["id"]: res for res in results}
        results = list(rd.values())

        if len(results) == 0:
            print("Error: no results found", file=sys.stderr)
            sys.exit(1)

        choice = pick_from_list([format_album_result(r) for r in results])

        if choice is None:
            print("Invalid choice", file=sys.stderr)
            sys.exit(1)

        url = results[choice].get("link")
        album_id = results[choice].get("id")

    if not album_id:
        print("Error: could not get album id", file=sys.stderr)
        sys.exit(1)

    album_api_url = f"https://api.deezer.com/album/{album_id}"
    ar = requests.get(album_api_url)
    arj = ar.json()

    console = rich.console.Console()
    album_table = rich.table.Table("Tag", "Value", title="Album tags", **TABLE_STYLE)

    new_tags = {"URL": url}

    set_tags("ALBUMARTIST", [i["name"] for i in arj["contributors"]], new_tags, album_table)
    set_tags("ALBUM", arj["title"], new_tags, album_table)
    set_tags("DATE", arj["release_date"], new_tags, album_table)
    set_tags("YEAR", arj["release_date"].split("-")[0], new_tags, album_table)
    set_tags("RELEASEDATE", arj["release_date"], new_tags, album_table)
    set_tags("UPC", arj["upc"], new_tags, album_table)
    set_tags("GENRE", [i for s in arj["genres"]["data"] for i in s["name"].split("/")], new_tags, album_table)
    set_tags("LABEL", arj["label"], new_tags, album_table)

    album_table.add_row("URL", url)

    console.print(album_table)

    tracks_api_url = f"{album_api_url}/tracks?limit=200"
    tr = requests.get(tracks_api_url)
    trj = tr.json()

    gb = itertools.groupby(trj["data"], key=lambda x: x["disk_number"])
    disc_track_totals = {k: len(list(g)) for k, g in gb}
    disc_total = str(len(disc_track_totals.keys()))

    tracks = {(t["disk_number"], t["track_position"]): t for t in trj["data"]}

    new_track_tags = {}
    tracks_table = rich.table.Table("FILENAME", "TRACKNUMBER", "ARTIST", "TITLE", "TRACKTOTAL", "DISCNUMBER", "DISCTOTAL", title="Track tags", **TABLE_STYLE)

    for fn, f in flacs.items():
        disc_number = int(f.tags.get("DISCNUMBER", ["1"])[0])
        track_number = int(f.tags.get("TRACKNUMBER", ["0"])[0].split("/")[0])
        album_track = tracks.get((disc_number, track_number))

        if album_track is None:
            print(f"Error: Could not find \"{fn}\" using {disc_number}x{track_number} in api")
            continue

        sr = requests.get(album_track["link"].replace("www", "api"))
        srj = sr.json()

        track_number = str(srj["track_position"])
        title = srj["title"]
        track_total = str(disc_track_totals[disc_number])
        artist = [i["name"] for i in srj["contributors"]]
        disc_number = str(srj["disk_number"])

        new_track_tags[fn] = {"TRACKNUMBER": track_number, "ARTIST": artist, "TITLE": title, "TRACKTOTAL": track_total, "DISCNUMBER": disc_number, "DISCTOTAL": disc_total}
        tracks_table.add_row(fn, track_number, "\n".join(artist), title, track_total, disc_number, disc_total)

    console.print(tracks_table)

    if not args.confirm:
        apply_choice = input("Apply [y/n]: ")

        if apply_choice != "y":
            sys.exit(1)

    print("Writing tags to files")

    for fn, f in flacs.items():
        for k, v in itertools.chain(new_tags.items(),  new_track_tags[fn].items()):
            f.tags[k] = v
        f.save()

    r = requests.get(arj["cover_xl"])
    with open("cover.jpg", "wb") as f:
        f.write(r.content)
    print("Saved cover to cover.jpg")


if __name__ == "__main__":
    main()
