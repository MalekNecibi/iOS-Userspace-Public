#!/usr/bin/env bash

MUTEX_FILE="/tmp/time_journal"
#MUTEX_FILE="$(mktemp /tmp/time_journal.XXXXXXXX)"

if [[ -f "${MUTEX_FILE}" ]] ; then
    springcuts -r "Notification" -p "mutex locked: ${MUTEX_FILE}";
    exit 1;
fi
touch "${MUTEX_FILE}"
echo taking mutex...

# Stop any running shortcut to avoid race conditions
# springcuts -s > /dev/null # (optional) big side effect, but may be called later anyway

BundleId="$(activator current-app)"

# TODO: preserve playback state
activator send us.necibi.mediacontrols.pause;
activator send libactivator.system.homebutton; 
#activator send libactivator.system.rotate.portrait;

Stop_VC="false" # default minimize change

# if Voice Control was running beforehand, leave it running when we're done
ps aux | grep -q '[ ]/System/Library/CoreServices/CommandAndControl.app/CommandAndControl' && Stop_VC="false" || Stop_VC="true"
echo Stop_VC: "$Stop_VC"

activator send switch-on.us.necibi.voicecontrol;

# build json dictionary for Shortcuts input {string:string,string:bool}
input_dict="$(printf '{"Source":"%s","Stop_VC":%s}' "${BundleId}" "${Stop_VC}" )"

activator send us.necibi.mediacontrols.pause &
activator send libactivator.system.homebutton &

# Bring up the prompt
springcuts -r "TJ_Bash" -p "${input_dict}" -w &
shortcut_pid="$!"

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
    sleep 2;
done


# stop shortcuts triggered by springcuts
# TODO: find more selective alternative for specific shortcut
springcuts -s;

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
        # TODO: reprimand further
        activator send libactivator.system.homebutton;
    fi
fi

rm "$MUTEX_FILE";

[[ "$Stop_VC" == "true" ]] && {
    sleep 15;
    activator send libactivator.system.vibrate;
    sleep 0.75;
    activator send switch-off.us.necibi.voicecontrol;
}
