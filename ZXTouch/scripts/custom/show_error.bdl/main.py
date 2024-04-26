#This script is created at 02/03/2024 10:57:55
#ZXTouch module documentation on Github: https://github.com/xuan32546/IOS13-SimulateTouch/


from zxtouch.client import zxtouch
from zxtouch.toasttypes import *
import time
import sys
import re

device = zxtouch("127.0.0.1")

# give older messages a chance to finish displaying
time.sleep(0.5)

device.show_toast(TOAST_ERROR, f"Errors Detected:", 2)
time.sleep(1.5)

num_lines = "0"

# quickly scroll through each line
for i,line in enumerate(sys.stdin):
    # only print first 3 lines
    if i < 3:
        _line = re.sub(r'[^0-9a-zA-Z_:\.=]', '_', line)
        device.show_toast(TOAST_ERROR, f"{_line}", 1)
        time.sleep(0.5)
    
    # stop counting after 50
    elif i >= 50:
        num_lines = f"{i}+"
        break
    
    # count number of errors
    device.show_toast(TOAST_ERROR, f"...", 1)
    num_lines = f"{i}"

device.show_toast(TOAST_ERROR, f"{num_lines} errors detected", 1.5)
time.sleep(1.5)

device.disconnect()



































