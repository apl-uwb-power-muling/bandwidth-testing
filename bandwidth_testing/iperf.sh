#!/bin/sh

REN=192.168.17.5
STIMPY=192.168.17.6
ODROID=192.168.17.7

iperf3 --client $ODROID  -t 600 | ts
