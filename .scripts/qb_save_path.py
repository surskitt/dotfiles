#!/usr/bin/env python

import subprocess
import sys

import qbittorrentapi

mallard_domain = subprocess.run(["gopass", "mallard_domain"], capture_output=True, encoding="utf-8").stdout.strip()
qb_host = f"https://qb.{mallard_domain}"

client = qbittorrentapi.Client(host=qb_host)

client.torrents_set_save_path(save_path=sys.argv[1], torrent_hashes=sys.argv[2:])
