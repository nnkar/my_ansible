#!/usr/bin/python
import os
import json
import re

if __name__ == "__main__":
    # Iterate over all block devices, but ignore them if they are in the
    # skippable set
    skippable = ("sr", "loop", "ram", "dm", "cdrom")
    devices = (device for device in os.listdir("/sys/class/block")
               if not any(ignore in device for ignore in skippable))
    data = [{"{#DEVICENAME}": device} for device in devices if device and not device[-1].isdigit()]
    print(json.dumps({"data": data}, indent=4))
