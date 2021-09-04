#!/bin/bash

source ./settings.sh

# 吸いだす
./dump.sh temp.bin
DATAORG=$(xxd -p -i -c 10000 temp.bin | head -n 2 | tail -n 1 | sed -r "s/,|\s//g" | sed -r "s/0x/ 0x/g" | sed -r "s/^\s//g")

# オリジナル
DATABASE=$(xxd -p -i -c 10000 $1 | head -n 2 | tail -n 1 | sed -r "s/,|\s//g" | sed -r "s/0x/ 0x/g" | sed -r "s/^\s//g")

arrayorg=()
for BYTE in $DATAORG; do
    arrayorg+=($BYTE)
done

arraybase=()
for BYTE in $DATABASE; do
    arraybase+=($BYTE)
done

for i in $(seq 68 83); do
    arraybase[$i]=${arrayorg[$i]}
done

i=0
CCBASE=0
CCEXT=0

for e in ${arraybase[@]}; do
    if [ $i -le 62 ]; then
        CCBASE=$((CCBASE + $(printf '%d' $e)))
    elif [ $i -eq 63 ]; then
        arraybase[63]=$((CCBASE & 0xFF))
    elif [ $i -le 94 ]; then
        CCEXT=$((CCEXT + $(printf '%d' $e)))
    elif [ $i -eq 95 ]; then
        arraybase[95]=$((CCEXT & 0xFF))
    fi
    let i++
done

./unlock.sh

i=0
for e in ${arraybase[@]}; do
    sudo i2cset -y ${I2CBUS} 0x50 $(printf '0x%02x\n' $i) ${e}
    let i++
done

sudo i2cdump -y -r 0x00-0x7F ${I2CBUS} 0x50 | tail -n 8 | sed -e "s/://g" | sed -e "s/^/00000/g" | xxd -r >temp.bin
./checksum.sh temp.bin

rm temp.bin
