import sys

def exitWithCode(code = 0):
    if code != 0:
        sys.stderr.write(f"The task is failed. Exit({code})\n")
    sys.exit(code)
