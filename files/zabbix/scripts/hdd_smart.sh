#!/bin/bash

/usr/sbin/smartctl -H /dev/$1 |grep "test"| cut -f2 -d: |tr -d " "