import hashlib
import sys, getopt

from IpaManager import *

from Config import APPGUARD_RESIGNER_VER
from Config import workspace
from Logger import *
from datetime import datetime
import argparse
import subprocess

class AppGuardResigner:
    def __init__(self, ipa, output):
        self.ipaManager = IpaManager(ipa, output)
        self.ipaManager.doUnzip()
    
    def exportSinger(self):
        return self.ipaManager.resigner.exportSinger()
    
    def doProcess(self):
        # self.ipaManager.doUnzip()
        target_macho = os.path.join(workspace, self.ipaManager.getTargetMacho())
        self.ipaManager.doResign()
        self.ipaManager.doBundling()



def outputNameParse(output):
    print(f"[+] outputNameParse()")
    changedOutput = output
    if output.find("/") == -1:
        changedOutput = "./"+changedOutput
    if output.find("ipa") == -1:
        changedOutput = changedOutput + ".ipa"
    
    if output == changedOutput:
        ContentLog( f"\"{output}\" is Normal" )
    else:
        ContentLog( f"\"{output}\" => \"{changedOutput}\"" )

    return changedOutput


# 실행 예) python3 AppGuard.py -c 
def clearWorkspace():
    print("[+] Start clearWorkspace()")
    workspace_dir_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "workspace")
    clear_workspace_cmd = [f"rm", f"-rf", f"{workspace_dir_path}"]
    subprocess.check_output(clear_workspace_cmd)

    clear_output_cmd = [f"rm", f"-rf", f"./out"]
    subprocess.check_output(clear_output_cmd)



if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="NHN AppGuard Protector")
    parser.add_argument('--ipa', '-i', help='Input Your IPA', required=True)  # ipa명을 인자로 받는 옵션 (필수)
    parser.add_argument('--output', '-o', help='Output Name', default="./out/ReSigned-App.ipa") # output 명을 입력 (기본값은 "./out/ReSigned-App.ipa" )
    parser.add_argument('--clear', '-c', help='Clear Workspace', action="store_true") # workspace를 정리하기 위한 옵션 (기본값은 False)
    args = parser.parse_args()

    print("[+] ---- AppGuard-Protector Version : " + APPGUARD_RESIGNER_VER + " ----- ")
    print(f"[+] --------- {datetime.now().strftime('%Y-%m-%d-%H-%M-%S')}  -------------- ")

    if args.clear:
        clearWorkspace()
        
    appguard = AppGuardResigner(args.ipa, outputNameParse(args.output))
    appguard.doProcess()

