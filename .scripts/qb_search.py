#!/usr/bin/env python

import argparse
import subprocess

import qbittorrentapi
import humanize

parser = argparse.ArgumentParser(prog="qb_add", description="add torrent files to qbittorrent")

parser.add_argument("-q", "--quiet", action="store_true")
parser.add_argument("-c", "--category")
parser.add_argument("-t", "--tag")
parser.add_argument("query")

args = parser.parse_args()

mallard_domain = subprocess.run(["gopass", "mallard_domain"], capture_output=True, encoding="utf-8").stdout.strip()
qb_host = f"https://qb.{mallard_domain}"

client = qbittorrentapi.Client(host=qb_host)

torrents = client.torrents_info(category=args.category, tag=args.tag)

searched_torrents = [t for t in torrents if args.query.lower() in t.name.lower()]

for n, t in enumerate(searched_torrents, 1):
    if args.quiet:
        print(t.hash)
        continue

    print(t.name)
    print(humanize.naturalsize(t.size, binary=True))
    print(t.category)
    print(t.save_path)
    print(t.hash)

    if n < len(searched_torrents):
        print()
