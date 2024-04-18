#!/usr/bin/env bash

_shortcut=${1:-"Voice Control OFF"}
_total_time=${2:-300}
_interval=${3:-300}

# TODO : parameter validation
if ! [[ "$_total_time" =~ ^[0-9]+$ && "$_interval" =~ ^[0-9]+$ ]] ; then
  echo ERROR: invalid parameter provided 1>&2
  exit 1
fi

if [[ ! "$_interval" -ge 10 ]]; then
  echo "WARNING: minimum interval is 10 seconds" 1>&2
  _interval=10
fi

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