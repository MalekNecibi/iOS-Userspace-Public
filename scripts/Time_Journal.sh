#!/usr/bin/env bash

: '
check for other instances of script
check the /tmp/ mutex
quit if present (maybe notify)

create /tmp/ mutex 

if voice control NOT enabled
- enable it
- remember needs to be disabled
pause

run shortcut, wait to finish
- timeout 5 minutes ?
-- 30 seconds warning, vibrate x3

if /tmp/ mutex still exists
- reprimand
- stop voice control
'

MUTEX_FILE="/tmp/time_journal"
#MUTEX_FILE="$(mktemp /tmp/time_journal.XXXXXXXX)"

if [[ -f "${MUTEX_FILE}" ]] ; then
    springcuts -r "Notification" -p "mutex locked: ${MUTEX_FILE}";
    exit 1;
fi
touch "${MUTEX_FILE}"
echo taking mutex...

# springcuts -s > /dev/null # (optional) could be called again later anyway

Source_="$(activator current-app | tr -d '\n')"
Stop_VC=""

# if Voice Control was running beforehand, leave it running when we're done
ps aux | grep -q '[ ]/System/Library/CoreServices/CommandAndControl.app/CommandAndControl' && Stop_VC="false" || Stop_VC="true"
echo Stop_VC: "$Stop_VC"

# build json dictionary for Shortcuts input {string:string,string:bool}
input_dict="$(printf '{"Source":"%s","Stop_VC":%s}' "${Source_}" "${Stop_VC}" )"

springcuts -r "TJ_Bash" -p "${input_dict}" -w &
shortcut_pid="$!"

#timeout_epoch="$(date +'%s' -d '+15 seconds')"
timeout_epoch="$(date +'%s' -d '+5 minutes')"

timed_out(){ 
    [[ "$(date +'%s')" -gt "$timeout_epoch" ]]
}

mutex_released(){
    [[ ! -f "$MUTEX_FILE" ]]
}

shortcut_stopped(){
    ps -p "$shortcut_pid" &>/dev/null;
    [[ $? -ne 0 ]]
}

until shortcut_stopped || timed_out; do
#    echo -n "* ";
    sleep 1;
done

printf "\n---\n";
if timed_out ; then echo timed_out; fi
if mutex_released ; then echo mutex_released; fi
if shortcut_stopped ; then echo shortcut_stopped; fi
echo "---"

springcuts -s;  # stop running shortcuts

if timed_out ; then
    # Error / Timeout
    echo timed out: logging ERROR
    springcuts -r "_TJ_Append" -p "ERROR";
else
    if mutex_released; then
        # Logged Successfully
        echo mutex released: do nothing;
    else
        # IGNORED
        echo mutex locked: logging IGNORED;
        springcuts -r "_TJ_Append" -p "IGNORED";
        # TODO: reprimand
        activator send libactivator.system.homebutton
    fi
fi


[[ "$Stop_VC" == "true" ]] && { sleep 15 ; springcuts -r "Voice Control OFF" ; } &
rm "$MUTEX_FILE";
activator send libactivator.system.vibrate;
exit;
