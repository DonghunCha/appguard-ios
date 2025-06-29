import hashlib
import subprocess
import plistlib
from subprocess import STDOUT
from Unzipper    import *
from Bundler     import *
from Config      import target_dir
from Config      import workspace
from TargetMachO import *
from Logger import *


class Resigner:
    def __init__(self, app_name):
        self.app_name = app_name
        self.signer   = None
        self.framework_entitlement = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n<plist version=\"1.0\">\n<dict/>\n</plist>".encode()

    
    def export_entitlement(self):
        print("[+] Resigner: export_entitlement() Start")
        entitle_export_cmd = [f"codesign", f"-d", f"--entitlements", f":-", f"{workspace}/Payload/{self.app_name}"]
        # entitle_result     = subprocess.check_output(entitle_export_cmd)
        entitle_result = self.quite_cmd(entitle_export_cmd)

        with open(f"{workspace}/entitlements.plist", "wb+") as f:
            f.write(entitle_result)
        with open(f"{workspace}/framework_entitlement.plist", "wb+") as f:
            f.write(self.framework_entitlement)


    def export_singer(self):
        print("[+] Resigner: export_singer() Start")
        codesign_cmd = [f"codesign", f"-dvv", f"{workspace}/Payload/{self.app_name}"]
        sign_info    = subprocess.check_output(codesign_cmd, stderr=STDOUT, shell = False).decode().split("\n")

        for info in sign_info:
            if info.find("Authority=") != -1:
                self.signer = info[10:]
                break
        content_log("Signer : " + self.signer)
        return self.signer


    def resign_only_main_binanry(self):
        print("[+] Resigner: resign() Start")
        resign_cmd = ["codesign", "-f", "-s", f"{self.signer}", "--entitlements", f"{workspace}/entitlements.plist", f"{workspace}/Payload/{self.app_name}"]
        # result     = subprocess.check_output(resign_cmd)
        result = self.quite_cmd(resign_cmd)


    def sign_with_frameworks(self):
        print("[+] Resigner: sign_with_frameworks() Start")
        frameworks = []
        
        file_list = os.listdir(f"{workspace}/Payload/{self.app_name}/Frameworks/")
        for fname in file_list:
            content_log(f"framework : {fname}")
            frameworks.append(fname)
                
        for framework in frameworks:
            subprocess.check_output(["codesign", "-f", "-s", f"{self.signer}", "--entitlements", f"{workspace}/framework_entitlement.plist", f"{workspace}/Payload/{self.app_name}/Frameworks/{framework}"])
                        
        subprocess.check_output(["codesign", "-f", "-s", f"{self.signer}", "--entitlements", f"{workspace}/entitlements.plist", f"{workspace}/Payload/{self.app_name}"])


    def quite_cmd(self, cmd):
        output = None
        with open(os.devnull, 'w') as devnull:
            output = subprocess.check_output(
                cmd, stderr=devnull
            )
        return output
        