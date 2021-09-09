#!/bin/bash

/usr/bin/sensors | grep "Core 0:" | awk '{print $3}' | sed -e 's/+//g' -e 's/°C//g'
#echo 50.12