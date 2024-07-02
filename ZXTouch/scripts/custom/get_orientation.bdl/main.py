#This script is created at 11/19/2023 12:11:10
#ZXTouch module documentation on Github: https://github.com/xuan32546/IOS13-SimulateTouch/


# based on examples:
# Device Info
# Touch Simulation

from zxtouch.client import zxtouch
from zxtouch.toasttypes import *
# import os # trigger activator

device = zxtouch("127.0.0.1")

def error_exit(err="-"):
    device.show_toast(TOAST_ERROR, f"Cannot get screen orientation. Error {err}", 3)
    device.disconnect()
    print("ERROR", end="")
    exit(0)
    

# screen orientation
orientation_tuple = device.get_screen_orientation()
if not orientation_tuple[0]:
    error_exit(orientation_tuple[1])

orientation = int(float(orientation_tuple[1][0]))
# print(orientation)

orientation_strs = {
    1 : "up",
    2 : "down",
    3 : "right",
    4 : "left",
}
if orientation not in orientation_strs:
    error_exit(orientation)
print(orientation_strs[orientation], end="")


device.disconnect()
exit()



































