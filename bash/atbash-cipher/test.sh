#!/usr/bin/env bash

clear
for i in ./*_test.sh; do
    echo "$i"
    echo ""
    bats "$i"
done
