#!/usr/bin/env python

import os
import sys
import threading
import signal
import time
import subprocess
import select

import requests


FIFO = "/tmp/poly_hass_sensor.fifo"


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


def run():
    url = os.environ.get("HASS_URL")
    api_key = os.environ.get("HASS_API_KEY")

    errcheck(url is None, "Error: HASS_URL is not set")
    errcheck(api_key is None, "Error: HASS_API_KEY is not set")
    errcheck(len(sys.argv) < 2, "Error: pass the name of at least one sensor")

    headers = {"Authorization": "Bearer {}".format(api_key)}
    request_url = "{}/api/states".format(url)

    exit = threading.Event()

    def interrupt_wait(signo, _frame):
        exit.set()

    signal.signal(signal.SIGUSR1, interrupt_wait)

    with open(FIFO, "w") as f:
        f.write("{}\n".format(os.getpid()))

    while True:
        r = requests.get(request_url, headers=headers)
        entities = {i["entity_id"]: i for i in r.json()}

        arg_dicts = [arg_dict(*s.split(":")) for s in sys.argv[1:]]
        outputs = [fmt_sensor(entities[i["id"]], i) for i in arg_dicts]

        out = " ".join(outputs)
        print(out)
        sys.stdout.flush()
        with open(FIFO, "a") as f:
            f.write("{}\n".format(out))

        exit.wait(300)
        exit.clear()


def tail():
    with open(FIFO) as f:
        pid = int(f.readline().strip())

    def send_usr1(signo, _frame):
        os.kill(pid, signal.SIGUSR1)

    signal.signal(signal.SIGUSR1, send_usr1)

    f = subprocess.Popen(
        ["tail", "-f", "-n", "1", FIFO],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    p = select.poll()
    p.register(f.stdout)

    while True:
        if p.poll(1):
            print(str(f.stdout.readline(), encoding="utf-8").strip())
            sys.stdout.flush()
        time.sleep(1)


def main():
    monitor_id = os.environ.get("MONITOR_ID")
    errcheck(monitor_id is None, "Error: MONITOR_ID is not set")

    if monitor_id == "1":
        run()
    else:
        tail()


if __name__ == "__main__":
    main()
