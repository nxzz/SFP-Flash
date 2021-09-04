#!/bin/bash

source ./settings.sh
./unlock.sh

DATA=$(xxd -p -i -c 10000 $1 | head -n 2 | tail -n 1 | sed -r "s/,|\s//g" | sed -r "s/0x/ 0x/g" | sed -r "s/^\s//g")

array=()
for BYTE in $DATA; do
    array+=($BYTE)
done

i=0
for e in ${array[@]}; do
    sudo i2cset -y ${I2CBUS} 0x50 $(printf '0x%02x\n' $i) ${e}
    let i++
done
