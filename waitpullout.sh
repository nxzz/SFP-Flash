#!/bin/bash

source ./settings.sh

while true; do
    if [ "$(sudo i2cdetect -y ${I2CBUS} 0x50 0x51 | grep 50 | grep -e '-- --')" ]; then
        echo "detect sfp pullout"
        break
    fi
done
