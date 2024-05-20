#!/usr/bin/env bash

APP_BundleId="com.google.Maps"
APP_UUID="BCF57D63-7FEB-480E-BCE8-E449C6005275" # TODO: auto-update

AppsDir="/var/mobile/Containers/Data/Application"

# Fetch App UUID (slow)
# APP_UUID="$(basename "$(dirname "$(find /var/mobile/Containers/Data/Application/ -maxdepth 2 -name '.com.apple.mobile_container_manager.metadata.plist' -exec grep -l 'com.google.Maps' {} \; | head -1)")")"

[[ -d ${AppsDir}/${APP_UUID} ]] || exit 1

# Verify UUID matches target app
2>&1 plutil -show "${AppsDir}/${APP_UUID}/.com.apple.mobile_container_manager.metadata.plist" | grep -q "MCMMetadataIdentifier = \"${APP_BundleId}\"" || exit 2

GoogleMaps_plist="${AppsDir}/${APP_UUID}/Library/Preferences/com.google.Maps.plist"
[[ -f ${GoogleMaps_plist} ]] || exit 3;

# plutil -useDebug ...
plutil -kAZDefaultKeyMuteState -int 0 "${GoogleMaps_plist}";

# Verify updated value 
# 2>&1 plutil -show "${GoogleMaps_plist}" | grep "kAZDefaultKeyMuteState" || { echo plist file/key not found; exit 1; }