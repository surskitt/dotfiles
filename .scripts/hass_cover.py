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
        print("Error: pass the name of the switch to toggle")
        sys.exit(1)

    if sys.argv[2] == "position" and len(sys.argv) < 4:
        print("Error: pass the desired position of the cover")
        sys.exit(1)

    #  if len(sys.argv) < 3 or sys.argv[2] not in ("open", "close", "position"):
    #      action = "toggle"
    #  else:
    #      action = "{}_cover".format(sys.argv[2])

    entity_id = sys.argv[1]

    if len(sys.argv) < 3:
        action = "toggle"
    else:
        action = sys.argv[2]

    if action == "open":
        service = "open_cover"
    elif action == "close":
        service = "close_cover"
    elif action == "position":
        service = "set_cover_position"
        position = sys.argv[3]
    else:
        service = "toggle"

    if action == "position":
        data = {"entity_id": entity_id, "position": position}
    else:
        data = {"entity_id": entity_id}

    headers = {"Authorization": "Bearer {}".format(api_key)}
    #  data = {"entity_id": entity_id}

    request_url = "{}/api/services/cover/{}".format(url, service)

    r = requests.post(request_url, headers=headers, json=data)


if __name__ == "__main__":
    main()
