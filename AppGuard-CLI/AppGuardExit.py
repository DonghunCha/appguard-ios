import sys

def exitWithCode(code = 0):
    if code != 0:
        sys.stderr.write(f"\033[91mThe task is failed. Exit({code})\033[0m\n")
    sys.exit(code)
