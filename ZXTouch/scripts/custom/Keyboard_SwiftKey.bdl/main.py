#ZXTouch module documentation on Github: https://github.com/xuan32546/IOS13-SimulateTouch/

from zxtouch.client import zxtouch
# from zxtouch.toasttypes import *
from zxtouch.touchtypes import *
import time

device = zxtouch("127.0.0.1")
device.accurate_usleep("10000");

device.show_keyboard()
#time.sleep(0.25)

# Switch keyboard to SwiftKey (hacky)
device.touch(TOUCH_DOWN, 11, 120, 2280)
# deadband ~33
device.touch(TOUCH_MOVE, 11, 120, 2313)
time.sleep(0.01)
device.touch(TOUCH_MOVE, 11, 675, 1850)
time.sleep(0.01)
device.touch(TOUCH_UP, 11, 675, 1850)
time.sleep(0.01)
device.touch(TOUCH_UP, 11, 675, 1850) # just in case
time.sleep(0.1)

device.disconnect()




































