#!/usr/bin/env bash

abs() {
    local -i x="$1"
    if ((x < 0)); then
        ((x = -x))
    fi
    echo "$x"
}

gcd() {
    local -i x
    local -i y
    local -i rem=0
    x=$(abs "$1")
    y=$(abs "$2")
    while ((y != 0)); do
        ((rem = x % y))
        ((x = y))
        ((y = rem))
    done
    echo "$x"
}

status() {
    local -i size="$1"
    local -i liters="$2"
    if ((liters == size)); then
        echo "full"
    elif ((liters == 0)); then
        echo "empty"
    else
        echo "not_empty"
    fi
}

fill() {
    local -i size="$1"
    local -i liters="$2"
    echo "$size"
}

empty() {
    echo 0
}

pour_from_to() {
    local -i size1="$1"
    local -i liters1="$2"
    local -i size2="$3"
    local -i liters2="$4"

    local -i volume1=liters1
    local -i volume2=$((size2 - liters2))
    local -i min_volume=$((volume1 < volume2 ? volume1 : volume2))

    ((liters1 -= min_volume))
    ((liters2 += min_volume))

    echo "$liters1 $liters2"
}

solve() {
    local -i size1="$1"
    local -i size2="$2"
    local -i goal="$3"
    local first="$4"

    if ((size1 < goal && size2 < goal)); then
        echo "invalid goal"
        exit 1
    fi

    if (((goal % $(gcd size1 size2)) != 0)); then
        echo "invalid goal"
        exit 1
    fi

    if [[ "$first" == "two" ]]; then
        local -i swap
        swap="$size1"
        size1="$size2"
        size2="$swap"
    fi

    local -i liters1=0
    local -i liters2=0

    local some_size_eq_goal=false
    if ((size1 == goal || size2 == goal)); then
        some_size_eq_goal=true
    fi

    local -i moves=0

    local status1
    local status2

    while true; do
        if ((liters1 == goal || liters2 == goal)); then
            break
        fi

        ((moves++))

        status1=$(status "$size1" "$liters1")
        status2=$(status "$size2" "$liters2")

        if [[ "$status1" == "empty" ]]; then
            # fill 1
            liters1=$(fill "$size1" "$liters1")
        elif [[ "$some_size_eq_goal" == true ]]; then
            # fill 2
            liters2=$(fill "$size2" "$liters2")
        elif [[ "$status2" == "full" ]]; then
            # empty
            liters2=$(empty)
        else
            # pour from 1 to 2
            local tmp
            local -a tmp_arr
            tmp=$(pour_from_to "$size1" "$liters1" "$size2" "$liters2")
            tmp_arr=($tmp)
            liters1="${tmp_arr[0]}"
            liters2="${tmp_arr[1]}"
        fi
    done

    if [[ "$first" == "two" ]]; then
        local -i swap
        swap="$liters1"
        liters1="$liters2"
        liters2="$swap"
    fi

    fmt "$liters1" "$liters2" "$goal" "$moves"
}

fmt() {
    local -i liters1="$1"
    local -i liters2="$2"
    local -i goal="$3"
    local -i moves="$4"

    local goal_bucket=""
    local -i other_bucket=0
    if [[ "$goal" == "$liters1" ]]; then
        goal_bucket="one"
        other_bucket="$liters2"
    else
        goal_bucket="two"
        other_bucket="$liters1"
    fi

    echo "moves: $moves, goalBucket: $goal_bucket, otherBucket: $other_bucket"
}

help() {
    echo "Usage: ${0##*/} <size1> <size2> <goal> <first>"
}

error() {
    echo "error: $1"
}

if (($# != 4)); then
    help
    exit 1
fi

size1="$1"
size2="$2"
goal="$3"
first="$4"

if [[ "$size1" =~ [^0-9] ]]; then
    error "invalid size1"
    help
    exit 1
fi
if [[ "$size2" =~ [^0-9] ]]; then
    error "invalid size2"
    help
    exit 1
fi
if [[ "$goal" =~ [^0-9] ]]; then
    error "invalid goal"
    help
    exit 1
fi
if [[ ! "$first" =~ one|two ]]; then
    error "invalid first"
    help
    exit 1
fi

solve "$size1" "$size2" "$goal" "$first"
