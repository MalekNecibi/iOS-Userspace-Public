#!/usr/bin/env bash

MUTEX_FILE="/tmp/time_journal"
TIME_LIMIT="+5 min" # date -d format


if [[ -f "${MUTEX_FILE}" ]] ; then
    springcuts -r "Notification" -p "mutex locked: ${MUTEX_FILE}";
    exit 1;
fi
touch "${MUTEX_FILE}"

# Stop any running shortcut to avoid race conditions
# springcuts -s > /dev/null # (optional) big side effect, but may be called later anyway

# Preserve Initial State/defaults
BundleId="$(activator current-app)"
Stop_VC="false"
Resume="false"

activator send switch-on.us.necibi.voicecontrol && {
    Stop_VC="true";
    screen -dm bash -c '/private/var/mobile/Malek/scripts/shortcut_scheduler.sh "Voice Control OFF" 330 15;' # optional: force turn off Voice Control after ~5 minutes
    # TODO: generate from $TIME_LIMIT
}

# Go home if orientation is landscape (keyboard unusable)
orientation="$(python3 -c '
from zxtouch.client import zxtouch;
d=zxtouch("127.0.0.1");
print(d.get_screen_orientation()[1][0]);
d.disconnect();')"
if [[ "1" != "${orientation}" ]] ; then
    activator send libactivator.system.homebutton &
fi

activator send switch-off.us.necibi.mediacontrols && Resume="true";
activator send libactivator.system.vibrate &

# build json dictionary for Shortcut input {str:str,str:bool}
input_dict="$(printf '{"Source":"%s","Resume":%s}' "${BundleId}" "${Resume}" )"

# Bring up the prompt
springcuts -r "TJ_Bash" -p "${input_dict}" -w &
shortcut_pid="$!"

timeout_epoch="$(date +'%s' -d "${TIME_LIMIT}")"

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
    sleep 1;
done


# stop shortcuts triggered by springcuts
# TODO: find more selective alternative for specific shortcut
springcuts -s;

if timed_out ; then
    # Error / Timeout
    springcuts -r "_TJ_Append" -p "ERROR";
else
    if mutex_released; then
        # Logged Successfully
#        activator send "${BundleId}";
#        [[ "true" == "${Resume}" ]] && {
#            activator send switch-on.us.necibi.mediacontrols;
#        }
        true;

    else
        # IGNORED
        springcuts -r "_TJ_Append" -p "IGNORED";
        activator send libactivator.system.homebutton;
        activator send libactivator.system.lock-and-wipe-credentials;
    fi
fi

rm "$MUTEX_FILE";
[[ "true" == "$Stop_VC" ]] && {
    sleep 15;
    activator send libactivator.system.vibrate;
    activator send switch-off.us.necibi.voicecontrol;
    springcuts -r "_unschedule" -p "Voice Control OFF"
}
