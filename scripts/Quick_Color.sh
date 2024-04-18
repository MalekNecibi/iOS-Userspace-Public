#!/usr/bin/env bash

activator send switch-off.com.PS.GrayscaleFS &
activator send libactivator.system.vibrate &

script_name=$(basename "$BASH_SOURCE")

# kill all instances of Quick_Color.sh (excluding self)
2>/dev/null kill $(ps -eo "pid,args" | grep "$script_name" | grep -v -e "grep" -e "$$" -e "$BASHPID" | awk "{ print \$1 }") ;

start=$(date +"%s")
stop=$((start + 10))
until [[ "$(date +'%s')" -gt "$stop" ]] ; do
    activator send switch-off.com.PS.GrayscaleFS;
    sleep 0.1;
done;

activator send switch-on.com.PS.GrayscaleFS;
