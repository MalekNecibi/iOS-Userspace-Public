#ZXTouch module documentation on Github: https://github.com/xuan32546/IOS13-SimulateTouch/

from zxtouch.client import zxtouch
from zxtouch.toasttypes import *
from zxtouch.touchtypes import *
import time
import subprocess
import sys
import random

device = zxtouch("127.0.0.1")
device.show_toast(TOAST_WARNING, "PermaTemp", 1)
time.sleep(0.1)

from datetime import datetime
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")


device.hide_keyboard()
time.sleep(0.5)
#device.show_keyboard()


## Handy Tools
# device.hide_keyboard()
# device.show_keyboard()
# bundleid = subprocess.check_output(["activator", "current-app"]).strip().decode('utf-8')
# device.play_script("/var/mobile/Library/ZXTouch/scripts/recording/newterm_left.bdl")
"""
if 0 == random.choice([0,1]):
    pass
else:
    pass
"""

device.show_toast(TOAST_WARNING, "PermaTemp Complete", 1)
device.disconnect()

sys.exit()
































