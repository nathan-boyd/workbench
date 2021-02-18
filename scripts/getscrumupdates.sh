#!/bin/bash

# usage
# get updated from the last 10 days
#     ./scripts/getscrumupdates.sh -d=10

for i in "$@"
do
case $i in
    -d=*|--days=*)
    DAYS="${i#*=}"
    shift # past argument=value
    ;;
    *)
    # unknown option
    ;;
esac
done

now=$(date '+%Y-%m-%d %H:%M:%S')
from=$(date -d "$DAYS days ago" '+%Y-%m-%d %H:%M:%S')

printf "\nStandup updates: \n  from: $from\n  to:   $now\n"

jrnl @standup --format fancy -from "$from" -to "$now"
