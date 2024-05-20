#!/usr/bin/env bash

activator send switch-off.com.PS.GrayscaleFS ;
activator send libactivator.system.vibrate ;

script_name=$(basename "$BASH_SOURCE")

# kill all instances of Quick_Color.sh (excluding self)
2>/dev/null kill $(ps -eo "pid,args" | grep "$script_name" | grep -v -e "grep" -e "$$" -e "$BASHPID" | awk "{ print \$1 }") ;

# TODO: replace above with below, split off into separate script. NEEDS TO ONLY DELETE OLDER INSTANCES

# SCREEN_NAME="Quick_Color"
# screens=$(screen -ls | grep "${SCREEN_NAME}"'\s*(Detached)$') && pids=$(echo -n "$screens" | cut -d. -f1 | awk '{print $1}' | tr '\n' '|' | sed 's/|$//') && ps -eo ppid,pid,args | grep -E "^($pids)" | awk '{print $2}' | xargs -r kill;

start=$(date +"%s")
stop=$((start + 10))
until [[ "$(date +'%s')" -gt "$stop" ]] ; do
    activator send switch-off.com.PS.GrayscaleFS;
    sleep 0.25;
done;

activator send switch-on.com.PS.GrayscaleFS;
# springcuts -r "Color Current App"