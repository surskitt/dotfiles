#!/usr/bin/env python

import os
import sys

#  import threading
import time

import paho.mqtt.client as mqtt
import requests

CLIENT = "hass_sensor"
BROKER = "localhost"
TOPIC = "polybar/hass"
TIMER = 30


def errcheck(p, msg):
    if p:
        print(msg, file=sys.stderr)
        sys.exit(1)


def arg_dict(id, icon=None, attribute=None, suffix=""):
    return {
        "id": id,
        "icon": icon or "",
        "attribute": attribute,
        "suffix": suffix,
    }


def fmt_sensor(sensor_dict, arg_dict):
    if arg_dict["attribute"]:
        value = sensor_dict["attributes"][arg_dict["attribute"]]
    else:
        value = sensor_dict["state"]

    try:
        vf = float(value)
        value = "{:0.1f}".format(vf)
    except ValueError:
        pass

    icon = arg_dict["icon"]
    suffix = arg_dict["suffix"]

    return "{} {}{}".format(icon, value, suffix)


class HassSensors(object):
    def __init__(self, sensor_args, headers, request_url, client):
        self.sensors = [arg_dict(i) for i in sensor_args]
        self.headers = headers
        self.request_url = request_url
        self.client = client

    def fetch(self):
        r = requests.get(self.request_url, headers=self.headers)
        entities = {i["entity_id"]: i for i in r.json()}

        arg_dicts = [arg_dict(*s.split(":")) for s in sys.argv[1:]]
        outputs = [fmt_sensor(entities[i["id"]], i) for i in arg_dicts]

        return " ".join(outputs)

    def publish(self):
        self.client.publish(TOPIC + "/out", self.fetch())


def main():
    url = os.environ.get("HASS_URL")
    api_key = os.environ.get("HASS_API_KEY")

    errcheck(url is None, "Error: HASS_URL is not set")
    errcheck(api_key is None, "Error: HASS_API_KEY is not set")
    errcheck(len(sys.argv) < 2, "Error: pass the name of at least one sensor")

    headers = {"Authorization": "Bearer {}".format(api_key)}
    request_url = "{}/api/states".format(url)

    client = mqtt.Client(CLIENT)
    client.connect(BROKER)

    client.loop_start()

    hs = HassSensors(sys.argv[1:], headers, request_url, client)

    def refresh(client, userdata, message):
        hs.publish()

    client.subscribe(TOPIC + "/refresh")
    client.on_message = refresh

    while True:
        hs.publish()

        time.sleep(TIMER)

    client.loop_stop()


if __name__ == "__main__":
    main()
