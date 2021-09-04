#!/bin/bash

source ./settings.sh

sudo i2cdump -y -r 0x00-0x7F ${I2CBUS} 0x50 | tail -n 8 | sed -e "s/://g" | sed -e "s/^/00000/g" | xxd -r >$1

./checksum.sh $1