#!/bin/bash

pvecm status | grep -oP "Quorate:\s+\K\w+"