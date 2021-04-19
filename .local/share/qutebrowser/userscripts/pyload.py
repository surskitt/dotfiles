#!/usr/bin/env python

import os
import sys

import requests

envs = [
    os.getenv("PYLOAD_USERNAME"),
    os.getenv("PYLOAD_PASSWORD"),
    os.getenv("PYLOAD_HOST"),
]

if not all(envs):
    print(
        "Err: PYLOAD_USERNAME, PYLOAD_PASSWORD, PYLOAD_HOST env vars not set",
        file=sys.stderr,
    )
    sys.exit(1)

if len(sys.argv) < 3:
    print(f"Usage: {sys.argv[0]} TITLE URL", file=sys.stderr)
    sys.exit(1)

title, url = sys.argv[1:3]
username, password, host = envs
fifo = os.getenv("QUTE_FIFO")

login_url = f"{host}/api/login"
auth_creds = {"username": username, "password": password}

session = requests.post(login_url, data=auth_creds).json()
add_url = f"{host}/api/addPackage"

add_url_creds = {
    "session": session,
    f"name": f"'{title}'",
    f"links": f"['{url}']",
}
out = requests.post(add_url, data=add_url_creds)

if fifo is not None:
    with open(fifo, "w") as f:
        f.write(f'jseval "{title} ({url}) added to pyload"')
