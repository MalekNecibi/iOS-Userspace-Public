#!/usr/bin/env bash

_shortcut=${1:-"Notification"}
_total_time=${2:-300}
_interval=${3:-300}

# Parameter Validation
all_shortcuts(){ springcuts -l | tail -c +19 | sed "$ s/$/,/" | sed "s/,$//"; }

# NOTE: newline not allowed in shortcut name, but treated as "special" character by grep -F
all_shortcuts | grep -xFq "${_shortcut}"; # match whole shortcut name as literal string
if [[ $? -ne 0 || "$_shortcut" =~ [$'\r\n'] ]] ; then
    _shortcut_clean=$(printf %q "$_shortcut")
    echo "ERROR: invalid parameter provided, shortcut=$_shortcut_clean" 1>&2
  exit 1
fi

if ! [[ "$_total_time" =~ ^[0-9]+$ ]] ; then
  echo "ERROR: invalid parameter provided, total_time=$_total_time" 1>&2
  exit 1
fi

if ! [[ "$_interval" =~ ^[0-9]+$ ]] ; then
  echo "ERROR: invalid parameter provided, interval=$_interval" 1>&2
  exit 1
fi

if ! [[ "$_interval" -ge 10 ]]; then
  echo "WARNING: minimum interval is 10 seconds" 1>&2
  _interval=10
fi


# Validated, Sleeplock until scheduled time

_stop_time=$(date +"%s" -d "+ "$_total_time" sec") ;

_interval_str="+ ${_interval} sec" ;

# keep sleeping interval time increments until we are fairly close to target time, then stop ...
until [[ "$(date +"%s" -d "$_interval_str")" -ge "$_stop_time" ]] ; do 
  sleep "$_interval" ; 
done

# so we can sleep just the precise time remaining
_remaining=$(("$_stop_time" - $(date +"%s")))
if [[ "$_remaining" -ge 0 ]] ; then
  sleep "$_remaining" ;
else
  echo WARNING: overshot target time by $((-"$_remaining")) seconds : "$_shortcut", "$_total_time", "$_interval"
fi

springcuts -r "$_shortcut" ;
echo -n 'now=    ' ;
date +%s ;
echo target= "$_stop_time" ;