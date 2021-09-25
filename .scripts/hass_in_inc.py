#!/usr/bin/env python

import os
import sys

import requests


def main():
    url = os.environ.get("HASS_URL")
    if url is None:
        print("Error: HASS_URL is not set")
        sys.exit(1)

    api_key = os.environ.get("HASS_API_KEY")
    if api_key is None:
        print("Error: HASS_API_KEY is not set")
        sys.exit(1)

    if len(sys.argv) < 2:
        print("Error: pass the name of input number", file=sys.stderr)

    if len(sys.argv) < 3:
        print("Error: pass the value to increment by", file=sys.stderr)

    entity_id = "input_number.{}".format(sys.argv[1])
    inc_val = int(sys.argv[2])

    headers = {"Authorization": "Bearer {}".format(api_key)}
    get_url = f"{url}/api/states/{entity_id}"

    rg = requests.get(get_url, headers=headers)
    rgj = rg.json()
    current_val = float(rgj["state"])
    new_val = current_val + inc_val

    post_url = f"{url}/api/states/{entity_id}"
    data = {"state": str(new_val)}
    rp = requests.post(post_url, headers=headers, json=data)


if __name__ == "__main__":
    main()
