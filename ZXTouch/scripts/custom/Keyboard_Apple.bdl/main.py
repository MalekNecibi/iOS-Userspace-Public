#ZXTouch module documentation on Github: https://github.com/xuan32546/IOS13-SimulateTouch/

from zxtouch.client import zxtouch
# from zxtouch.toasttypes import *
from zxtouch.touchtypes import *
import time

device = zxtouch("127.0.0.1")
device.accurate_usleep("10000");

device.show_keyboard()
#time.sleep(0.25)

# Switch keyboard to Apple (hacky)
# Hold down globe
device.touch(TOUCH_DOWN, 11, 120, 2300)
time.sleep(0.03)
# deadband + tiny sleep otherwise selects left-handed
device.touch(TOUCH_MOVE, 11, 540, 2300)
time.sleep(0.03)
# select apple keyboard (English)
# center (no change) if already showing
device.touch(TOUCH_MOVE, 11, 430, 2100)
time.sleep(0.01)
device.touch(TOUCH_UP, 11, 430, 2100)
time.sleep(0.01)
device.touch(TOUCH_UP, 11, 430, 2100) # just in case
time.sleep(0.1)

device.disconnect()




































