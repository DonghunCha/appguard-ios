import hashlib
import subprocess
import plistlib
from Resigner    import *
from Unzipper    import *
from Bundler     import *
from Config      import target_dir
from TargetMachO import *
from Logger import *

class IpaManager:
    def __init__(self, ipa, output):
        print("[+] IPA Analysis: Start analyzing IPA files.")
        if not os.path.isfile(ipa):
            ContentLog(f"\"{ipa}\" is not exist")
            exitWithCode(1)
    
        self.unzipper    = Unzipper(ipa)
        self.app_name    = None
        self.resigner    = None
        self.output      = output
        self.bundler     = None
        self.targetMachO = None
        self.unityFlag = None
        self.unziped = False

    # 유니티 앱인지 체크하기위한 함수
    def isItUnity(self):
        print("[+] IPA Analysis: Check Unity app.")
        
        # 중복 실행 방지
        if self.unityFlag == True or self.unityFlag == False:
            return self.unityFlag

        for fileName in self.unzipper.getNameList():
            if fileName.find("/Frameworks/UnityFramework.framework") != -1:
                ContentLog(f"It is Unity")
                self.unityFlag = True
                return self.unityFlag

        ContentLog(f"It is Not Unity")
        self.unityFlag = False
        return self.unityFlag
            

    def resetTargetForUnity(self):
        print("[+] IPA Analysis: Start the analysis with the Unity app.")
        pl = None
        unityPlistPath = f"{workspace}/Payload/{self.app_name}/Frameworks/UnityFramework.framework/Info.plist"
        with open(unityPlistPath, "rb") as f:
            pl = plistlib.load(f)
            self.targetMachO = TargetMachO()
            self.targetMachO.binaryName         = pl[CFBundleExecutable]
            self.targetMachO.deployVersion      = pl[MinimumOSVersion]
            self.targetMachO.bundleIdentifier   = pl[CFBundleIdentifier]
            self.targetMachO.bundleVersion      = pl[CFBundleVersion]
            self.targetMachO.bundleShortVersion = pl[CFBundleShortVersionString]
 

    def moveToTarget(self):
        print("[+] IPA Analysis: Move to target")
        rm_cmd    = [f"rm", f"-rf", f"{workspace}/Payload/{self.app_name}/{self.targetMachO.binaryName}"]
        rm_result = subprocess.check_output(rm_cmd)

        cp_cmd    = [f"cp", f"{workspace}/{self.targetMachO.binaryName}", f"{workspace}/Payload/{self.app_name}/"]
        cp_result = subprocess.check_output(cp_cmd)

    def doUnzip(self):
        print("[+] IPA Analysis: Extracting")
        self.targetMachO = self.unzipper.doProcess()
        self.app_name = self.unzipper.app_name
        self.resigner = Resigner(self.app_name)
        self.unziped = True
        ContentLog(f"unziped")


    def getTargetMacho(self):
        print("[+] IPA Analysis: Mach-O Analysis")
        ContentLog(f"App   Name : {self.app_name}")
        ContentLog(f"MachO Name : {self.targetMachO.binaryName}")
        return self.targetMachO.binaryName
        


    def doBundling(self):
        print("[+] IPA Analysis: Bundling")
        if self.targetMachO != None:
            self.bundler = Bundler(self.app_name, self.targetMachO.binaryName, self.output)
            self.bundler.doProcess()
        else:
            ContentLog("There is no macho")
            exitWithCode(1)



    def doResign(self):
        print("[+] IPA Analysis: Re-signing")
        self.moveToTarget()
        self.resigner.exportSinger()
        self.resigner.exportEntitlement()
        self.resigner.signWithFrameworks()
        