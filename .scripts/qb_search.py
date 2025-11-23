#!/usr/bin/env python

import argparse
import subprocess

import qbittorrentapi

parser = argparse.ArgumentParser(prog="qb_add", description="add torrent files to qbittorrent")

parser.add_argument("-q", "--quiet", action="store_true")
parser.add_argument("query")

args = parser.parse_args()

mallard_domain = subprocess.run(["gopass", "mallard_domain"], capture_output=True, encoding="utf-8").stdout.strip()
qb_host = f"https://qb.{mallard_domain}"

client = qbittorrentapi.Client(host=qb_host)

torrents = client.torrents_info()

for t in torrents:
    if args.query.lower() in t.name.lower():
        if args.quiet:
            print(t.hash)
        else:
            print(t.name)
