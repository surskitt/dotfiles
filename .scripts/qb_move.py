#!/usr/bin/env python

import subprocess
import pprint

import qbittorrentapi

hash = "b6767d00b1239014bb7eaabcd5589b5d3df6c80f"
# hash = "9dad584f4e7d7c9fb4cf06f1bed96e508b2a5f17"

mallard_domain = subprocess.run(["gopass", "mallard_domain"], capture_output=True, encoding="utf-8").stdout.strip()
qb_host = f"https://qb.{mallard_domain}"

mallard_domain = subprocess.run(["gopass", "mallard_domain"], capture_output=True, encoding="utf-8").stdout.strip()
qb_host = f"https://qb.{mallard_domain}"

client = qbittorrentapi.Client(host=qb_host)

# print(client.torrents_files(hash))

torrents = client.torrents_info(torrent_hashes=hash, include_files=True)

pprint.pp(dict(torrents[0]))
