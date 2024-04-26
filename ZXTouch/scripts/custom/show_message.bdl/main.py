#This script is created at 02/03/2024 10:57:55
#ZXTouch module documentation on Github: https://github.com/xuan32546/IOS13-SimulateTouch/


from zxtouch.client import zxtouch
from zxtouch.toasttypes import *
import time
import sys
import re

device = zxtouch("127.0.0.1")
TOAST_TYPE = TOAST_MESSAGE
MESSAGES_MAX = 10

# give older messages a chance to finish displaying
time.sleep(0.5)

message_count = len(sys.argv)-1

device.show_toast(TOAST_TYPE, f"Messages Detected: {message_count}", 1)
time.sleep(1)

if message_count <= 0:
    sys.exit(0)



# quickly scroll through each line
for i,line in enumerate(sys.argv[1:1+MESSAGES_MAX]):
    
    # only print first 10 messages
    if i >= 10:
        break
    
    # clean before printing
    _line = re.sub(r'[^0-9a-zA-Z_:\.=]', '_', line)
    device.show_toast(TOAST_TYPE, f"{_line}", 1)
    time.sleep(0.7)
    

if message_count > MESSAGES_MAX:
        device.show_toast(TOAST_WARNING, f"skipped {message_count - MESSAGES_MAX} messages", 1)
time.sleep(1)

device.disconnect()



































