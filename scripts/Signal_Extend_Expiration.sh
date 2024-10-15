#!/usr/bin/env bash

#/var/containers/Bundle/Application/38514E1F-0D06-4998-8743-7EE7DB47B3AF/Signal.app/Info.plist

APP_BundleId="org.whispersystems.signal"
APP_Bundle_UUID="38514E1F-0D06-4998-8743-7EE7DB47B3AF" # TODO: auto-update

BundlesDir="/var/containers/Bundle/Application"

# Fetch App Bundle UUID (slow)

echo ${BundlesDir}/${APP_Bundle_UUID}
[[ -d ${BundlesDir}/${APP_Bundle_UUID} ]] || exit 1

# Verify UUID matches target app
2>&1 plutil -show "${BundlesDir}/${APP_Bundle_UUID}/.com.apple.mobile_container_manager.metadata.plist" | grep -q "MCMMetadataIdentifier = \"${APP_BundleId}\"" || exit 2

Signal_plist="${BundlesDir}/${APP_Bundle_UUID}/Signal.app/Info.plist"
[[ -f ${Signal_plist} ]] || exit 3;

newBuildDate="$(date --date='now -1 week' '+%s')"
valid_epoch_regex='^[0-9]{10}$'
[[ ${newBuildDate} =~ ${valid_epoch_regex} ]] || exit 4;

# plutil -useDebug ...
sudo plutil -BuildDetails -Timestamp -int "${newBuildDate}" "${Signal_plist}";


# Verify updated value 
# 2>&1 plutil -show "${Signal_plist}" | grep "Timestamp" || { echo plist file/key not found; exit 1; }