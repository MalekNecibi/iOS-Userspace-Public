#!/usr/bin/env bash

MUTEX_FILE="/tmp/time_journal"

if [[ -f "${MUTEX_FILE}" ]] ; then
    springcuts -r "Notification" -p "mutex locked: ${MUTEX_FILE}";
    exit 1;
fi
touch "${MUTEX_FILE}"
echo taking mutex...

# Stop any running shortcut to avoid race conditions
# springcuts -s > /dev/null # (optional) big side effect, but may be called later anyway

# Preserve Initial State 
BundleId="$(activator current-app)"
Stop_VC=
Resume=

# Go home if orientation is landscape (keyboard unusable)
orientation="$(python3 -c '
from zxtouch.client import zxtouch;
d=zxtouch("127.0.0.1");
print(d.get_screen_orientation()[1][0]);
d.disconnect();')"
if [[ "1" -ne "${orientation}" ]] ; then
    activator send libactivator.system.homebutton &
fi
activator send switch-on.us.necibi.voicecontrol && Stop_VC="true";
activator send switch-off.us.necibi.mediacontrols && Resume="true";

# Bring up the prompt
springcuts -r "TJ_Bash" -p "${BundleId}" -w &
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
    sleep 1;
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
        echo mutex released: return and resume;
        activator send "${BundleId}";
        [[ -n "${Resume}" ]] && {
            activator send switch-on.us.necibi.mediacontrols;
        }

    else
        # IGNORED
        echo mutex locked: logging IGNORED;
        springcuts -r "_TJ_Append" -p "IGNORED";
        # TODO: reprimand further
        activator send libactivator.system.homebutton;
        activator send libactivator.system.lock-and-wipe-credentials;
    fi
fi

rm "$MUTEX_FILE";
[[ -n "$Stop_VC" ]] && {
    sleep 15;
    activator send libactivator.system.vibrate;
    sleep 0.5;
    activator send switch-off.us.necibi.voicecontrol;
}
