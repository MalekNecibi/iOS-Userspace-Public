from zxtouch.client import zxtouch
from zxtouch.toasttypes import *
import time
import subprocess
import sys
import os
device = zxtouch("127.0.0.1")

VPNIGNORE_MINS = 15
ABORT_SEC = 7.5

## Wait 3 seconds, then Enable VPN

# Called by Activator:
# Only run when VPN was NOT enabled
# Opens menu with option to Stop ZXTouch scripts
# Give user a few seconds to choose to keep it disabled
# If user exits app that triggered this, keep it disabled


def abort(msg=""):
    if msg is not "":
        device.show_toast(TOAST_MESSAGE, f"{msg[:16]}", 1)
    device.disconnect()
    sys.exit()

network_info = subprocess.check_output(["ifconfig"]).strip().decode('utf-8')
if "type:VPN" in network_info:
    abort()

initial_app = subprocess.check_output(["activator", "current-app"]).strip().decode('utf-8')
if "" == initial_app:
    # Apps only (ignore lockscreen, springboard)
    abort()

# check app-specific ignore file (Ignore for few minutes)
ignore_file = f"/tmp/vpnignore-{initial_app}"
try:
    vpnignore_time = os.path.getmtime(ignore_file)
    now_time = time.time()
    if (now_time - vpnignore_time) < (60 * VPNIGNORE_MINS):
        abort("ignored")
except FileNotFoundError:
    pass
except Exception as e:
    abort("ERROR: Global VPN Ignore")

# ZXTouch VPN Menu
device.run_shell_command("activator send libactivator.menu.3AD3152D-8D27-499E-A996-B13BB784C04D")

device.show_toast(TOAST_WARNING, f"Enabling VPN in 5...", 1)

for i in range(1 + int(ABORT_SEC / 0.5)):
    time.sleep(0.5)
    current_app = subprocess.check_output(["activator", "current-app"]).strip().decode('utf-8')
    if ("" == current_app) or (initial_app != current_app):
        abort("abort")

device.run_shell_command("activator send switch-on.com.a3tweaks.switch.vpn")
device.run_shell_command("activator send libactivator.system.vibrate")
device.show_toast(TOAST_SUCCESS, f"VPN Enabled", 1)

device.disconnect()



































