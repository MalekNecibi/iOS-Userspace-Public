#!/usr/bin/env bash

RUNTIME=300

activator send switch-off.com.PS.GrayscaleFS ;
activator send libactivator.system.vibrate ;

script_name=$(basename "$BASH_SOURCE")
# TODO: Verify script_name

runtime="${RUNTIME}"


# kill all instances of Quick_Color_hold.sh (excluding self)
2>/dev/null kill $(ps -eo "pid,args" | grep "$script_name" | grep -v -e "grep" -e "$$" -e "$BASHPID" | awk "{ print \$1 }") ;



start=$(date +"%s")
stop=$((start + "${runtime}"))
until [[ "$(date +'%s')" -gt "$stop" ]] ; do
    activator send switch-off.com.PS.GrayscaleFS;
    sleep 0.5;
done;


/private/var/mobile/Malek/scripts/Color_Current_App.sh
# activator send switch-on.com.PS.GrayscaleFS;