import hashlib
import subprocess
import plistlib
from Resigner    import *
from Unzipper    import *
from Bundler     import *
from Config      import target_dir
from TargetMachO import *
from Logger import *
from AppGuardExit import exitWithCode

class IpaManager:
    def __init__(self, ipa, output):
        print("[+] IpaManager Start")
        if not os.path.isfile(ipa):
            content_log(f"\"{ipa}\" is not exist")
            exitWithCode(1)
    
        self.unzipper      = Unzipper(ipa)
        self.app_name      = None
        self.resigner      = None
        self.output        = output
        self.bundler       = None
        self.target_mach_o = None
        self.unity_flag    = None
        self.unziped       = False

    # 유니티 앱인지 체크하기위한 함수
    def is_it_unity(self):
        print("[+] IpaManager: is_it_unity() Start")
        
        # 중복 실행 방지
        if self.unity_flag == True or self.unity_flag == False:
            return self.unity_flag

        for file_name in self.unzipper.get_name_list():
            if file_name.find("/Frameworks/UnityFramework.framework") != -1:
                content_log(f"It is Unity")
                self.unity_flag = True
                return self.unity_flag

        content_log(f"It is Not Unity")
        self.unity_flag = False
        return self.unity_flag
    
    def get_unity_binary_path(self):
        if self.is_it_unity():
            unity_binary_path = f"{workspace}/Payload/{self.app_name}/Frameworks/UnityFramework.framework/UnityFramework"
            return unity_binary_path
        else:
            return None

    def is_reactnative_jsbundle_file(self, jsbundleFile):
        jsbundleFileFullPath =  f"{workspace}/Payload/{self.app_name}/{jsbundleFile}"
        if not os.path.exists(jsbundleFileFullPath):
            return False
        return True

    def get_reactnative_jsbundle_file_path(self, jsbundleFile):
        jsbundleFileFullPath =  f"{workspace}/Payload/{self.app_name}/{jsbundleFile}"
        if not os.path.exists(jsbundleFileFullPath):
            return None
        return jsbundleFileFullPath
    
    def get_flutter_app_framework_binary_file_path(self):
        app_framework_bin_path =  f"{workspace}/Payload/{self.app_name}/Frameworks/App.framework/App"
        if not os.path.exists(app_framework_bin_path):
            return None
        return app_framework_bin_path
    
    def get_flutter_framework_binary_file_path(self):
        flutter_framework_bin_path =  f"{workspace}/Payload/{self.app_name}/Frameworks/Flutter.framework/Flutter"
        if not os.path.exists(flutter_framework_bin_path):
            return None
        return flutter_framework_bin_path
    
    def reset_target_for_unity(self):
        print("[+] IpaManager: reset_target_for_unity() Start")
        pl = None
        unity_plist_path = f"{workspace}/Payload/{self.app_name}/Frameworks/UnityFramework.framework/Info.plist"
        with open(unity_plist_path, "rb") as f:
            pl = plistlib.load(f)
            self.target_mach_o = TargetMachO()
            self.target_mach_o.binary_name          = pl[CFBundleExecutable]
            self.target_mach_o.deploy_version       = pl[MinimumOSVersion]
            self.target_mach_o.bundle_identifier    = pl[CFBundleIdentifier]
            self.target_mach_o.bundle_version       = pl[CFBundleVersion]
            self.target_mach_o.bundle_short_version = pl[CFBundleShortVersionString]
 
    def get_bundle_info_plist_path(self):
        info_plist_path = f"{workspace}/Payload/{self.app_name}/Info.plist"
        if not os.path.isfile(info_plist_path):
            return None
        return info_plist_path
        
    def move_to_target(self):
        print("[+] IpaManager: move_to_target() Start")
        rm_cmd    = [f"rm", f"-rf", f"{workspace}/Payload/{self.app_name}/{self.target_mach_o.binary_name}"]
        rm_result = subprocess.check_output(rm_cmd)

        cp_cmd    = [f"cp", f"{workspace}/{self.target_mach_o.binary_name}", f"{workspace}/Payload/{self.app_name}/"]
        cp_result = subprocess.check_output(cp_cmd)

    def do_unzip(self):
        print("[+] IpaManager: do_unzip() Start")
        self.target_mach_o = self.unzipper.do_process()
        self.app_name = self.unzipper.app_name
        self.resigner = Resigner(self.app_name)
        self.unziped = True
        content_log(f"unziped")


    def get_main_binary_mach_o(self):
        print("[+] IpaManager: get_main_binary_mach_o() Start")

        content_log(f"App   Name : {self.app_name}")
        content_log(f"Macho Name : {self.target_mach_o.binary_name}")
        return self.target_mach_o.binary_name
        


    def do_bundling(self):
        print("[+] IpaManager: do_bundling() Start")
        if self.target_mach_o != None:
            self.bundler = Bundler(self.app_name, self.target_mach_o.binary_name, self.output)
            self.bundler.do_process()
        else:
            content_log("There is no mach_o")
            exitWithCode(1)



    def do_resign(self):
        print("[+] IpaManager: do_resign() Start")
        self.move_to_target()
        # self.resigner.export_singer()
        # self.resigner.export_entitlement()
        # self.resigner.sign_with_frameworks()


