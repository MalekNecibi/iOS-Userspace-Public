#!/usr/bin/env bash

# Notify user that the device's Physical ringer switch is off WITHOUT modifying the existing Virtual ringer state

shopt -s expand_aliases;

RINGER_RESET="libactivator.audio.reset-ringer-state"
RINGER_ON="switch-on.com.a3tweaks.switch.ringer"
RINGER_OFF="switch-off.com.a3tweaks.switch.ringer"
RINGER_FLIP="switch-flip.com.a3tweaks.switch.ringer"

SLEEP_TIME="0.1";

alias a_send_safe='sleep "${SLEEP_TIME}"; activator send ';


a_send_safe "${RINGER_ON}";
virtual_ringer_on=$(echo $?);
# echo virtual_ringer_on="${virtual_ringer_on}"

a_send_safe "${RINGER_RESET}";

a_send_safe "${RINGER_ON}";
physical_ringer_on=$(echo $?);
# echo physical_ringer_on="${physical_ringer_on}"

# restore initial virtual state before warning
if [[ ${virtual_ringer_on} -eq 1 ]] ;
then
  #echo turning virtual ringer ON
  a_send_safe "${RINGER_ON}";
else
  #echo turning virtual ringer OFF
  a_send_safe "${RINGER_OFF}";
fi

# warn 
if [[ ${physical_ringer_on} -eq 0 ]] ;
then
  springcuts -r "Notification_Silent" -p "WARNING: Physical Ringer is Off";
fi