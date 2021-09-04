#!/bin/bash

DATA=$(xxd -p -i -c 10000 $1 | head -n 2 | tail -n 1 | sed -r "s/,|\s//g" | sed -r "s/0x/ 0x/g" | sed -r "s/^\s//g")

array=()
for BYTE in $DATA; do
    array+=($BYTE)
done

i=0
CCBASE=0
CCEXT=0
CCBASEORG=0
CCEXTORG=0

for e in ${array[@]}; do
    if [ $i -le 62 ]; then
        CCBASE=$((CCBASE + $(printf '%d' $e)))
    elif [ $i -eq 63 ]; then
        # echo "CCBASE $e"
        CCBASEORG=$(printf '%d' $e)
    elif [ $i -le 94 ]; then
        CCEXT=$((CCEXT + $(printf '%d' $e)))
    elif [ $i -eq 95 ]; then
        # echo "CCEXT $e"
        CCEXTORG=$(printf '%d' $e)
    fi
    let i++
done

CCBASE=$((CCBASE & 0xFF))
CCEXT=$((CCEXT & 0xFF))

if [ $CCBASE -eq $CCBASEORG ]; then
    echo "CCBASE OK"
fi
if [ $CCEXT -eq $CCEXTORG ]; then
    echo "CCEXT OK"
fi
