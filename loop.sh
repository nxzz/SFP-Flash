#!/bin/bash

while true; do
    ./waitinsert.sh
    ./modsn.sh $1
    echo "please insert next sfp module"
    ./waitpullout.sh
done
