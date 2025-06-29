import subprocess
import os
import zipfile
from Config import target_dir
from Config import workspace
from Logger import *

class Bundler:
    def __init__(self, app_name, target_mach_o, output):
        self.app_name      = app_name
        self.target_mach_o = target_mach_o
        self.output        = output
        
        
    def __make_copy_file_list(self, copyFiles, path):            
        for (root, dirs, files) in os.walk(f"{path}"):
            if len(files) > 0:
                for file_name in files:
                    copyFiles.append(os.path.join(root, file_name))
        
    def __makeNewIPA(self):
        print("[+] Bundler: makeNewIPA() Start")

        mkdir_cmd = [f"mkdir", f"-p", f"{os.path.dirname(self.output)}"]
        subprocess.check_output(mkdir_cmd)

        # zip_cmd    = f"zip -qr {self.output} {workspace}/Payload".split(" ")
        # zip_result = subprocess.check_output(zip_cmd)
        with zipfile.ZipFile(self.output, 'w', compression=zipfile.ZIP_DEFLATED) as zOut:
            copyFiles = []
            workspace_file_list = os.listdir(f"{workspace}")
            for file in workspace_file_list:
                if file == "SwiftSupport":
                    self.__make_copy_file_list(copyFiles, f"{workspace}/SwiftSupport")
                if file == "Symbols":
                    self.__make_copy_file_list(copyFiles, f"{workspace}/Symbols")
                if file == "Payload":
                    self.__make_copy_file_list(copyFiles, f"{workspace}/Payload")
            for i in range(len(copyFiles)):
                if copyFiles[i] == '':
                    break
                zOut.write(copyFiles[i], os.path.relpath(copyFiles[i], f"{workspace}/"))

        # content_log(f"Protected IPA Name: [AppGuard]-{self.app_name[0:-4]}.ipa")
        content_log(f"Protected IPA Name: {self.output}")


    def do_process(self):
        self.__makeNewIPA()