timeout 3 bash -c '

vc_running(){ ps aux | grep -q "[ ]/System/Library/CoreServices/CommandAndControl.app/CommandAndControl"; } ;

vc_on(){ activator activate libactivator.four-finger.spread; } ;

home(){ activator send libactivator.system.homebutton; } ;

vc_running || { vc_on; until vc_running; do sleep 0.1; done; home&home; };

'