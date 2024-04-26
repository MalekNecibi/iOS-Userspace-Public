#ZXTouch module documentation on Github: https://github.com/xuan32546/IOS13-SimulateTouch/

from zxtouch.client import zxtouch
from zxtouch.touchtypes import *
from zxtouch.toasttypes import *
import subprocess
import time

device = zxtouch("127.0.0.1")

subprocess.check_output(["activator", "send", "libactivator.system.activate-switcher"])

device.disconnect()



# Per-App Customization (disabled)
"""
bundleid = subprocess.check_output(["activator", "current-app"])
bundleid = bundleid.strip().decode('utf-8')

# device.show_toast(TOAST_MESSAGE, bundleid, 1)
# time.sleep(1)


if "ws.hbang.Terminal" == bundleid:
    device.show_toast(TOAST_SUCCESS, f"NewTerm", 1)
    #subprocess.check_output(["springcuts", "-r", "NewTerm Delete"])
    device.insert_text("[3~")

elif "" == bundleid:
    # springboard
    device.show_toast(TOAST_SUCCESS, f"Springboard", 1)

else:
    device.show_toast(TOAST_WARNING, f"{bundleid} not remapped", 2)
    device.switch_to_app("com.zjx.zxtouch")

time.sleep(2)
device.disconnect()
"""

































