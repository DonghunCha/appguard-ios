import uuid
import os
from datetime import datetime





APPGUARD_RESIGNER_VER = "1.4.11"




#workspace = os.path.join(os.path.dirname(os.path.abspath(__file__)), "workspace", str(uuid.uuid4())[0:8])
workspace = os.path.join(os.path.dirname(os.path.abspath(__file__)), "workspace", datetime.now().strftime('%Y-%m-%d-%H-%M-%S'))
target_dir      = os.path.join(workspace, "original")


CFBundleExecutable  = "CFBundleExecutable"
MinimumOSVersion    = "MinimumOSVersion"
CFBundleIdentifier  = "CFBundleIdentifier"
CFBundleVersion     = "CFBundleVersion"
CFBundleShortVersionString = "CFBundleShortVersionString"

DEFAULT_STARTUP_MESSAGE_DURATION = 2000
DEFAULT_STARTUP_MESSAGE_DELAY = 1000

