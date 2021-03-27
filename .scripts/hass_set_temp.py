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
        print("Error: pass the name of climate to control", file=sys.stderr)

    if len(sys.argv) < 3:
        print("Error: pass the value to set climate to", file=sys.stderr)

    entity_id = "climate.{}".format(sys.argv[1])
    temperature = sys.argv[2]

    headers = {"Authorization": "Bearer {}".format(api_key)}
    data = {"entity_id": entity_id, "temperature": temperature}

    request_url = "{}/api/services/climate/set_temperature".format(url)

    r = requests.post(request_url, headers=headers, json=data)


if __name__ == "__main__":
    main()
