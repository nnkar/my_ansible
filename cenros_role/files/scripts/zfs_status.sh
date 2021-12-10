#!/bin/bash

/sbin/zpool status | grep DEGRADED | wc -l