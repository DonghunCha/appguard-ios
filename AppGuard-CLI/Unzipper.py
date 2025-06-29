import subprocess
import plistlib
import os
import zipfile
from Config import workspace
from Config import target_dir
from Config import CFBundleExecutable
from Config import MinimumOSVersion
from Config import CFBundleIdentifier
from Config import CFBundleVersion
from Config import CFBundleShortVersionString
from TargetMachO import *
from Logger import *

class Unzipper:
    def __init__(self, ipa):
        self.ipa         = ipa
        self.app_name    = None
        self.targetMachO = None
        

    def __keepOrgIpa(self):
        print("[+] Extract IPA files: Backing up original files.")
        mkdir_cmd = [f"mkdir", f"-p", f"{target_dir}"]
        subprocess.check_output(mkdir_cmd)

        cp_cmd = [f"cp", f"{self.ipa}", f"{target_dir}"]
        subprocess.check_output(cp_cmd)


    def __doUnzip(self):
        print("[+] Extract IPA files: Extracting..") 
        unzip_cmd = [f"unzip", f"-o" ,f"{self.ipa}", f"-d", f"{workspace}"]
        subprocess.check_output (unzip_cmd )
        self.__getAppName()
        ContentLog('AppName: ' + self.app_name)

        
    def __getAppName(self):
        file_list = os.listdir( f"{workspace}/Payload" )
        self.app_name = file_list[0]


    def __getMachoName(self, plist):
        print("[+] Extract IPA files: Analyze Mach-O files")
        pl = None
        with open(plist, "rb") as f:
            pl = plistlib.load(f)
            
        self.targetMachO = TargetMachO()
        self.targetMachO.binaryName         = pl[CFBundleExecutable]
        self.targetMachO.deployVersion      = pl[MinimumOSVersion]
        self.targetMachO.bundleIdentifier   = pl[CFBundleIdentifier]
        self.targetMachO.bundleVersion      = pl[CFBundleVersion]
        self.targetMachO.bundleShortVersion = pl[CFBundleShortVersionString]

        ContentLog('Binary Name: ' + self.targetMachO.binaryName)
        ContentLog('Deploy Version: ' + self.targetMachO.deployVersion)
        ContentLog('Bundle Identifier: ' + self.targetMachO.bundleIdentifier)
        ContentLog('Bundle Version: ' + self.targetMachO.bundleVersion)
        ContentLog('Bundle ShortVersion: ' + self.targetMachO.bundleShortVersion)
        return self.targetMachO.binaryName
        
    
    def __getMacho(self):
        print("[+] Extract IPA files: Import Mach-O files")
        macho_name = self.__getMachoName(f"{workspace}/Payload/{self.app_name}/Info.plist")
        rm_cmd = [f"rm", f"-rf", f"{workspace}/{macho_name}"]
        subprocess.check_output (rm_cmd)

        cp_cmd = [f"cp", f"{workspace}/Payload/{self.app_name}/{macho_name}", f"{workspace}/"]
        subprocess.check_output (cp_cmd)

        # rm_cmd2 = f"rm -rf ./Payload/".split(" ")
        # subprocess.check_output (rm_cmd2)


    def reset(self):
        print("[+] Extract IPA files: Initializing workspace")
        rm_cmd = [f"rm", f"-rf", f"{workspace}/"]
        subprocess.check_output(rm_cmd)

    def getNameList(self):
        z = zipfile.ZipFile(f"{self.ipa}")
        return z.namelist()

    def doProcess(self):
        self.reset()
        self.__keepOrgIpa()
        self.__doUnzip()
        self.__getMacho()
        return self.targetMachO

