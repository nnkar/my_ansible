#!/bin/bash

/sbin/zpool status | egrep -w "OFFLINE|FAULTED|UNAVAIL" | grep -c L

