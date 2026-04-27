#!/usr/bin/env python

import sys
import subprocess

import requests

filenames = sys.argv[1:]

if len(filenames) == 0:
    print("Error: missing filenames", file=sys.stderr)
    sys.exit(1)

api_key = subprocess.run(["gopass", "ra_api_key"], capture_output=True, encoding="utf-8").stdout.strip()

url = "https://thesungod.xyz/api/image/upload"

payload = {'api_key': api_key}
files = [('image', open(i, 'rb')) for i in filenames]

response = requests.post(url, data=payload, files=files)

for i in response.json()["links"]:
    print(i)
