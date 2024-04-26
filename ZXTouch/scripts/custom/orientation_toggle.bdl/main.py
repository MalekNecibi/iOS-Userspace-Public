#This script is created at 11/19/2023 12:11:10
#ZXTouch module documentation on Github: https://github.com/xuan32546/IOS13-SimulateTouch/


# based on examples:
# Device Info
# Touch Simulation

from zxtouch.client import zxtouch
# from zxtouch.toasttypes import *
import os # trigger activator

device = zxtouch("127.0.0.1")


# screen orientation
orientation_tuple = device.get_screen_orientation()
if not orientation_tuple[0]:
    device.show_toast(TOAST_ERROR, "Cannot get screen orientation. Error " + orientation_tuple[1], 2)
    device.disconnect()
    exit(0)

orientation = int(float(orientation_tuple[1][0]))
# 1 : "up",
# 2 : "down",
# 3 : "right",
# 4 : "left",

if 1 == orientation:
    # initially up
    os.system('activator send libactivator.system.rotate.landscape-right')
else:
    # initially left/right/down
    os.system('activator send libactivator.system.rotate.portrait')

device.disconnect()


"""
if 1 == orientation:
    # initially up
    os.system('activator send libactivator.system.rotate.landscape-right')
elif 3 == orientation:
    # initially right
    os.system('activator send libactivator.system.rotate.landscape-left')
else:
    # initially left or down
    os.system('activator send libactivator.system.rotate.portrait')

device.disconnect()
"""































