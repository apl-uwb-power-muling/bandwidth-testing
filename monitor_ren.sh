#!/bin/sh

HOST=192.168.17.5

ssh admin@$HOST  "/interface wireless registration-table print detail stats without-paging interval=1" | ts
