#!/usr/bin/env bash

if (("$#" != 1)) || [[ ! "$1" =~ ^[0-9]*$ ]]; then
    echo "Usage: ${0##*/} <number>"
    exit 1
fi

a=$(("$1" % 3))
b=$(("$1" % 5))
c=$(("$1" % 7))

case "$a$b$c" in
000) echo "PlingPlangPlong" ;;
?00) echo "PlangPlong" ;;
0?0) echo "PlingPlong" ;;
00?) echo "PlingPlang" ;;
0??) echo "Pling" ;;
?0?) echo "Plang" ;;
??0) echo "Plong" ;;
  *) echo "$1" ;;
esac
