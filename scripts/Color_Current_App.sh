#!/usr/bin/env bash

# Dependants:
# ~/Malek/scripts/Quick_Color.sh
# Color Current App (Shortcut)


current_app="$(activator current-app)"

# x: match whole line
# q: don't print matches (optional)
grep -xq "${current_app}" <<EOF
com.apple.camera
com.apple.DocumentsApp
com.apple.facetime
com.apple.iBooks
com.apple.InCallService
com.apple.Maps
com.apple.mobilephone
com.apple.mobileslideshow
com.chess.iphone
com.chesstempo.mobile
com.google.Maps
com.pakdata.QuranMajeedLite
com.tigisoftware.Filza
InCallService
org.lichess.mobileapp.official
ws.hbang.Terminal
EOF

if [[ $? -eq 0 ]] ; then
  # Set Color
  activator send switch-off.com.PS.GrayscaleFS

else
  # Set Grayscale
  activator send switch-on.com.PS.GrayscaleFS
fi

exit 0



## BELOW IS NEVER CALLED, LEAVING HERE FOR FUTURE PROTOTYPING ##



# leading/trailing new lines required for search
color_apps="
com.apple.camera
com.apple.DocumentsApp
com.apple.facetime
com.apple.iBooks
com.apple.InCallService
com.apple.Maps
com.apple.mobilephone
com.chess.iphone
com.chesstempo.mobile
com.google.Maps
com.pakdata.QuranMajeedLite
com.tigisoftware.Filza
InCallService
org.lichess.mobileapp.official
ws.hbang.Terminal
"

current_app="$(activator current-app)"

# surrounded by newlines for complete match (not substring of line)
current_app_query="
${current_app}
"

if [[ ${color_apps} == *"${current_app_query}"* ]]; then
  # Set Color
  activator send switch-off.com.PS.GrayscaleFS
else
  # Set Grayscale
  activator send switch-on.com.PS.GrayscaleFS
fi