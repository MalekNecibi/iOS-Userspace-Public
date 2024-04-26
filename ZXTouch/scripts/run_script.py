import sys
import os
import os.path
from zxtouch.client import zxtouch


if len(sys.argv) <= 1:
    print("err: no script provided")
    exit(1)

script_path=sys.argv[1]

if not os.path.exists(script_path):
    print(f"err: script does not exist: '{script_path}'")
    exit(1)

if script_path != os.path.join(os.getcwd(), script_path):
    print(f"err: please provide the absolute path: '{script_path}'")

device = zxtouch("127.0.0.1")
device.play_script(script_path)

device.disconnect()




