#!/usr/bin/env bash

RUNTIME_INITIAL=10
RUNTIME_EXTEND=15

activator send switch-off.com.PS.GrayscaleFS ;
activator send libactivator.system.vibrate ;

script_name=$(basename "$BASH_SOURCE")
# TODO: Verify script_name

runtime="${RUNTIME_INITIAL}"


# kill all instances of Quick_Color.sh (excluding self)
2>/dev/null kill $(ps -eo "pid,args" | grep "$script_name" | grep -v -e "grep" -e "$$" -e "$BASHPID" | awk "{ print \$1 }") ;

# if last instance was still running, extend runtime
if [[ $? -eq 0 ]] ;
then
  runtime="${RUNTIME_EXTEND}"
fi

# TODO: replace above with below, split off into separate script. NEEDS TO ONLY DELETE OLDER INSTANCES

# SCREEN_NAME="Quick_Color"
# screens=$(screen -ls | grep "${SCREEN_NAME}"'\s*(Detached)$') && pids=$(echo -n "$screens" | cut -d. -f1 | awk '{print $1}' | tr '\n' '|' | sed 's/|$//') && ps -eo ppid,pid,args | grep -E "^($pids)" | awk '{print $2}' | xargs -r kill;

start=$(date +"%s")
stop=$((start + "${runtime}"))
until [[ "$(date +'%s')" -gt "$stop" ]] ; do
    activator send switch-off.com.PS.GrayscaleFS;
    sleep 0.25;
done;


/private/var/mobile/Malek/scripts/Color_Current_App.sh
# activator send switch-on.com.PS.GrayscaleFS;