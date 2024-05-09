#!/bin/bash
# modsn-onlymod.sh 加工対象 偽装対象

source ./settings.sh

# 吸いだす
DATAORG=$(xxd -p -i -c 10000 $1 | head -n 2 | tail -n 1 | sed -r "s/,|\s//g" | sed -r "s/0x/ 0x/g" | sed -r "s/^\s//g")

# オリジナル
DATABASE=$(xxd -p -i -c 10000 $2 | head -n 2 | tail -n 1 | sed -r "s/,|\s//g" | sed -r "s/0x/ 0x/g" | sed -r "s/^\s//g")

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

i=0
rm temp.hex
for e in ${arraybase[@]}; do
   printf "%02x" ${e} >> temp.hex
    let i++
done
cat temp.hex | xxd -r -p > patch.bin
rm temp.hex