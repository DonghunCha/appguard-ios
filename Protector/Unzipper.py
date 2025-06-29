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
        self.ipa           = ipa
        self.app_name      = None
        self.target_mach_o = None
        

    def __keep_org_ipa(self):
        print("[+] Unzipper: __keep_org_ipa() Start")
        mkdir_cmd = [f"mkdir", f"-p", f"{target_dir}"]
        subprocess.check_output(mkdir_cmd)

        cp_cmd = [f"cp", f"{self.ipa}", f"{target_dir}"]
        subprocess.check_output(cp_cmd)


    def __do_unzip(self):
        print("[+] Unzipper: __do_unzip() Start") 
        unzip_cmd = [f"unzip", f"{self.ipa}", f"-d", f"{workspace}"]
        subprocess.check_output (unzip_cmd )
        self.__get_app_name()
        content_log('AppName: ' + self.app_name)

        
    def __get_app_name(self):
        file_list = os.listdir( f"{workspace}/Payload" )
        self.app_name = file_list[0]


    def __get_mach_o_name(self, plist):
        print("[+] Unzipper: get_mach_o_name() Start")
        pl = None
        with open(plist, "rb") as f:
            pl = plistlib.load(f)
            
        self.target_mach_o = TargetMachO()
        self.target_mach_o.binary_name         = pl[CFBundleExecutable]
        self.target_mach_o.deploy_version      = pl[MinimumOSVersion]
        self.target_mach_o.bundle_identifier   = pl[CFBundleIdentifier]
        self.target_mach_o.bundle_version      = pl[CFBundleVersion]
        self.target_mach_o.bundle_shortversion = pl[CFBundleShortVersionString]

        content_log('self.target_mach_o.binaryName:' + self.target_mach_o.binary_name)
        content_log('self.target_mach_o.deployVersion:' + self.target_mach_o.deploy_version)
        content_log('self.target_mach_o.bundleIdentifier:' + self.target_mach_o.bundle_identifier)
        content_log('self.target_mach_o.bundleVersion:' + self.target_mach_o.bundle_version)
        content_log('self.target_mach_o.bundleShortVersion:' + self.target_mach_o.bundle_shortversion)
        return self.target_mach_o.binary_name
        
    
    def __get_mach_o(self):
        print("[+] Unzipper: get_mach_o() Start")
        mach_o_name = self.__get_mach_o_name(f"{workspace}/Payload/{self.app_name}/Info.plist")
        
        rm_cmd = [f"rm", f"-rf", f"{workspace}/{mach_o_name}"]
        subprocess.check_output (rm_cmd)

        cp_cmd = [f"cp", f"{workspace}/Payload/{self.app_name}/{mach_o_name}", f"{workspace}/"]
        subprocess.check_output (cp_cmd)

        # rm_cmd2 = f"rm -rf ./Payload/".split(" ")
        # subprocess.check_output (rm_cmd2)


    def reset(self):
        print("[+] Unzipper: reset() Start")
        rm_cmd1 = [f"rm", f"-rf", f"{target_dir}"]
        subprocess.check_output(rm_cmd1)

        rm_cmd2 = [f"rm", f"-rf", f"{workspace}/Payload/"]
        subprocess.check_output(rm_cmd2)

    def get_name_list(self):
        z = zipfile.ZipFile(f"{self.ipa}")
        return z.namelist()

    def do_process(self):
        self.reset()
        self.__keep_org_ipa()
        self.__do_unzip()
        self.__get_mach_o()
        return self.target_mach_o

