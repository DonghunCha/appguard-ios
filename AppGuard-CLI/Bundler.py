import subprocess
import os
import zipfile
from Config import target_dir
from Config import workspace
from Logger import *

class Bundler:
    def __init__(self, app_name, target_macho, output):
        self.app_name     = app_name
        self.target_macho = target_macho
        self.output = output
        
        
    def __makeNewIPA(self):
        print("[+] IPA Bundling: Making new IPA file.")

        mkdir_cmd = [f"mkdir", f"-p", f"{os.path.dirname(self.output)}"]
        subprocess.check_output(mkdir_cmd)
        zip_cmd = ""
        workspace_file_list = os.listdir(f"{workspace}")
        ContentLog(workspace_file_list)
        
        if "Symbols" in workspace_file_list and "SwiftSupport"  in workspace_file_list and "Payload" in workspace_file_list:
            zip_cmd    = f"cd {workspace} && zip -qr ./new.ipa ./Payload ./Symbols ./SwiftSupport" 
        elif "Symbols" in workspace_file_list and "Payload" in workspace_file_list: 
            zip_cmd    = f"cd {workspace} && zip -qr ./new.ipa ./Payload ./Symbols" 
        elif "SwiftSupport" in workspace_file_list and "Payload" in workspace_file_list:
            zip_cmd    = f"cd {workspace} && zip -qr ./new.ipa ./Payload ./SwiftSupport" 
        else:
            zip_cmd    = f"cd {workspace} && zip -qr ./new.ipa ./Payload" 
            
        proc = subprocess.Popen(zip_cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        out, err = proc.communicate()
        print(out.decode('latin-1'))

        mv_cmd = [f"mv", f"{workspace}/new.ipa", f"{self.output}"]
        subprocess.check_output(mv_cmd)
        ContentLog(f"Protected IPA Name: {self.output}")
        


    def doProcess(self):
        self.__makeNewIPA()