import lief
import hashlib
import sys, getopt
from lief.MachO import CPU_TYPES
from IpaManager import *
# from SignerChecker import *
from Config import HASH_SIGNATURE_DICT
from Config import SIGNER_SIGNATURE_DICT
from Config import UNITY_HASH_SIGNATURE_DICT
from Config import UNITY_IL2CPP_HASH_SIGNATURE_DICT
from Config import NUM_OF_LC_SIGNATURE_DICT
from Config import PROTECT_LEVEL_SIGNATURE_DICT
from Config import DEFAULT_POLICY_SIGNATURE_DICT
from Config import DEFAULT_JSON_POLICY_SIGNATURE_DICT
from Config import PROTECT_LEVEL_REPLACE_SIGNATURE
from Config import INFO_PLIST_SIGNATURE_DICT
from Config import INFO_PLIST_REPLACE_SIGNATURE
from Config import SDK_VERSION_SIGNATURE
from Config import PROTECTOR_VERSION_SIGNATURE
from Config import APPKEY_SIGNATURE_DICT
from Config import APPKEY_REPLACE_SIGNATURE
from Config import REACTNATIVE_SIGNATURE_DICT
from Config import FLUTTER_SIGNATURE_DICT
from Config import STARTUP_MESSAGE_SIGNATURE_DICT
from Config import STARTUP_MESSAGE_REPLACE_SIGNATURE
from Config import DEFAULT_STARTUP_MESSAGE_DELAY, DEFAULT_STARTUP_MESSAGE_DURATION
from Config import DETECTION_POPUP_MODE_SIGNATURE_DICT, DETECTION_POPUP_MODE_REPLACE_SIGNATURE
# from Config import SIGNATURE_SIZE
from ClassObfuscator import *
from Config import APPGUARD_PROTECT_VER
from Config import text_section, il2cpp_section
from Config import const_section
from Config import cstring_section
from Config import APPGUARD_PATH
from Config import workspace
from Logger import *
from datetime import datetime
import argparse
import subprocess
import urllib.request
import urllib.error
import struct
import traceback
from AppGuardExit import exitWithCode
from Util import *
from AppGuardReactNativeJSBundleManager import *
from AppGuardFlutterManager import *


class AppGuard:
    def __init__(self, args, output):
        
        self.args              = args
        self.ipa_manager       = IpaManager(args.ipa, output)
        self.fat_binary        = None
        self.is_it_fat         = False

        self.arm64_offset      = 0x00
        self.arm64_text_offset = 0x00
        self.arm64_text_size   = 0x00
        self.arm64_text_data   = None
        self.isExistIl2cppSection = None
        self.arm64_il2cpp_offset = 0x00
        self.arm64_il2cpp_size = 0x00
        self.arm64_il2cpp_data = None
        self.arm64_binary      = None

        self.signer            = args.signer
        self.arm64_signatures_dict = None
        self.level = "0"
        self.sdk_version = ""
    def init_mach_o_parse(self, target):
        print("[+] AppGuard: init_mach_o_parse() Start")
        self.fat_binary = lief.MachO.parse(target)
        for binary in self.fat_binary:
            if binary.header.cpu_type == CPU_TYPES.ARM:
                self.is_it_fat = True
                content_log("IT IS FAT")
                
            elif binary.header.cpu_type == CPU_TYPES.ARM64:
                self.arm64_offset = binary.fat_offset
                self.arm64_binary = binary
        
        if self.arm64_binary == None:
            content_log("ARM64 is None")
            exitWithCode(1)


    def calc_text_section_offset(self):
        print("[+] AppGuard: calc_text_section_offset() Start")
        text_section_offset    = self.arm64_binary.get_section(text_section).offset 
        self.arm64_text_size   = self.arm64_binary.get_section(text_section).size
        self.arm64_text_offset = self.arm64_offset + text_section_offset

        content_log( f"ARM64 __text Offset : {(self.arm64_text_offset)} " )
        content_log( f"ARM64 __text Size   : {(self.arm64_text_size)} "   )

    def calc_il2cpp_section_offset(self):
        print("[+] AppGuard: calc_il2cpp_section_offset() Start")
        if self.isExistIl2cppSection:
            il2cpp_section_offset    = self.arm64_binary.get_section(il2cpp_section).offset
            self.arm64_il2cpp_size   = self.arm64_binary.get_section(il2cpp_section).size
            self.arm64_il2cpp_offset = self.arm64_offset + il2cpp_section_offset

            content_log( f"ARM64 il2cpp Offset : {(self.arm64_il2cpp_offset)} " )
            content_log( f"ARM64 il2cpp Size   : {(self.arm64_il2cpp_size)} "   )
        else:
            content_log( f"ARM64 Can't find il2cpp section." )
          
    def read_text_section_in_mach_o(self, target_mach_o):
        print("[+] AppGuard: read_text_section_in_mach_o() Start")
        self.calc_text_section_offset()

        with open(target_mach_o, "rb+") as f:
            f.seek(self.arm64_text_offset)
            self.arm64_text_data = f.read(self.arm64_text_size)
            content_log("textSec Start 4Bytes data : " + str( self.arm64_text_data[0:4].hex() ) )
            
    def read_il2cpp_section_in_mach_o(self, target_mach_o):
        print("[+] AppGuard: read_il2cpp_section_in_mach_o() Start")
        self.calc_il2cpp_section_offset()
        if self.isExistIl2cppSection:
            with open(target_mach_o, "rb+") as f:
                f.seek(self.arm64_il2cpp_offset)
                self.arm64_il2cpp_data = f.read(self.arm64_il2cpp_size)
                content_log("il2cppSec Start 4Bytes data : " + str( self.arm64_il2cpp_data[0:4].hex() ) )
   

    def get_section_info(self, section_name):
        if self.arm64_offset == None or self.arm64_binary == None:
            content_log("(self.arm64_offset is None) or (self.arm64_binary is None)")

        section_offset   = self.arm64_offset + self.arm64_binary.get_section(section_name).offset 
        section_size     = self.arm64_binary.get_section(section_name).size 
        return section_offset, section_size

    def make_result_type(self, result_key_list):
        result = {}
        for result_key in result_key_list:
            result[result_key] = None
        return result


    # target_mach_o: Input mach-o path
    # section_names: Where to find section
    # signature_list: What to find siganture
    # result_key_list: What to make key (for 'key:value' type)
    def find_signature_offset(self, target_mach_o, section_names, signature_list, result_key_list):
        print("[+] AppGuard: find_signature_offset() Start")
        arm64_signature_offset = None
    
        result = self.make_result_type(result_key_list)

        for section_name in section_names:
            section_offset, section_size = self.get_section_info(section_name) 

            content_log("section_name   : " + section_name)
            content_log("section_offset   : " + str(hex(section_offset)))
            content_log("section_size     : " + str(hex(section_size)))
            with open(target_mach_o, "rb+") as f:
                
                for signature_dic in signature_list:
                    for i in range(section_size):
                        f.seek(section_offset + i, 0)
                        check_sig_data = f.read(signature_dic["size"])

                        if check_sig_data == signature_dic["value"]:
                            arm64_signature_offset = section_offset + i

                            if check_sig_data == HASH_SIGNATURE_DICT["value"]:
                                content_log("ARM64 HASH_SIGNATURE Offset : " + str(hex(arm64_signature_offset)))
                                result["hash_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset, 0)
                                data = f.read(HASH_SIGNATURE_DICT["size"])
                                content_log("[hash_signature] : " + str(data))
                                continue
                                
                            if check_sig_data == SIGNER_SIGNATURE_DICT["value"]:
                                content_log("ARM64 SIGNER_SIGNATURE Offset : " + str(hex(arm64_signature_offset)))
                                result["signer_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(SIGNER_SIGNATURE_DICT["size"])
                                content_log("[signer_signature] : " + str(data))
                                continue
                            
                            if check_sig_data == UNITY_HASH_SIGNATURE_DICT["value"]:
                                content_log("ARM64 UNITY_HASH_SIGNATURE Offset : " + str(hex(arm64_signature_offset)))
                                result["unity_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(UNITY_HASH_SIGNATURE_DICT["size"])
                                content_log("[unity_hash_signature] : " + str(data))
                                continue
                                                        
                            if check_sig_data == NUM_OF_LC_SIGNATURE_DICT["value"]:
                                content_log("ARM64 NUM_OF_LC_SIGNATURE Offset : " + str(hex(arm64_signature_offset)))
                                result["num_of_lc_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(NUM_OF_LC_SIGNATURE_DICT["size"])
                                content_log("[num_of_lc_signature_offset] : " + str(data))
                                continue

                            if check_sig_data == DEFAULT_POLICY_SIGNATURE_DICT["value"]:
                                content_log("ARM64 DEFAULT_POLICY_SIGNATURE_DICT Offset : " + str(hex(arm64_signature_offset)))
                                result["default_policy_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(DEFAULT_POLICY_SIGNATURE_DICT["size"])
                                content_log("[default_policy_signature_offset] : " + str(data))
                                continue

                            if check_sig_data == PROTECT_LEVEL_SIGNATURE_DICT["value"]:
                                content_log("ARM64 PROTECT_LEVEL_SIGNATURE_DICT Offset : " + str(hex(arm64_signature_offset)))
                                result["protect_level_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(PROTECT_LEVEL_SIGNATURE_DICT["size"])
                                content_log("[protect_level_signature_offset] : " + str(data))
                                continue

                            if check_sig_data == SDK_VERSION_SIGNATURE["value"]:
                                content_log("ARM64 SDK_VERSION_SIGNATURE Offset : " + str(hex(arm64_signature_offset)))
                                result["sdk_version_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(SDK_VERSION_SIGNATURE["size"])
                                content_log("[sdk_version_signature_offset] : " + str(data))
                                continue

                            if check_sig_data == PROTECTOR_VERSION_SIGNATURE["value"]:
                                content_log("ARM64 PROTECTOR_VERSION_SIGNATURE Offset : " + str(hex(arm64_signature_offset)))
                                result["protector_version_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(PROTECTOR_VERSION_SIGNATURE["size"])
                                content_log("[protector_version_signature_offset] : " + str(data))
                                continue

                            if check_sig_data == INFO_PLIST_SIGNATURE_DICT["value"]:
                                content_log("ARM64 INFO_PLIST_SIGNATURE_DICT Offset : " + str(hex(arm64_signature_offset)))
                                result["info_plist_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(INFO_PLIST_SIGNATURE_DICT["size"])
                                content_log("[info_plist_signature_offset] : " + str(data))
                                continue
                                
                            if check_sig_data == UNITY_IL2CPP_HASH_SIGNATURE_DICT["value"]:
                                content_log("ARM64 UNITY_IL2CPP_HASH_SIGNATURE_DICT Offset : " + str(hex(arm64_signature_offset)))
                                result["unity_il2cpp_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(UNITY_IL2CPP_HASH_SIGNATURE_DICT["size"])
                                content_log("[unity_il2cpp_hash_signature] : " + str(data))
                                continue
                                
                            if check_sig_data == APPKEY_SIGNATURE_DICT["value"]:
                                content_log("ARM64 APPKEY_SIGNATURE_DICT Offset : " + str(hex(arm64_signature_offset)))
                                result["appkey_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(APPKEY_SIGNATURE_DICT["size"])
                                content_log("[appkey_signature] : " + str(data))
                                continue

                            if check_sig_data == REACTNATIVE_SIGNATURE_DICT["value"]:
                                content_log("ARM64 REACTNATIVE_SIGNATURE_DICT Offset : " + str(hex(arm64_signature_offset)))
                                result["reactnative_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(REACTNATIVE_SIGNATURE_DICT["size"])
                                content_log("[reactnative_signature_offset] : " + str(data))
                                continue

                            if check_sig_data == FLUTTER_SIGNATURE_DICT["value"]:
                                content_log("ARM64 FLUTTER_SIGNATURE_DICT Offset : " + str(hex(arm64_signature_offset)))
                                result["flutter_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(FLUTTER_SIGNATURE_DICT["size"])
                                content_log("[FLUTTER_SIGNATURE_DICT] : " + str(data))
                                continue
                            if check_sig_data == DEFAULT_JSON_POLICY_SIGNATURE_DICT["value"]:
                                content_log("ARM64 DEFAULT_JSON_POLICY_SIGNATURE_DICT Offset : " + str(hex(arm64_signature_offset)))
                                result["default_json_policy_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(DEFAULT_JSON_POLICY_SIGNATURE_DICT["size"])
                                content_log("[DEFAULT_JSON_POLICY_SIGNATURE_DICT] : " + str(data))
                                continue
                            if check_sig_data == STARTUP_MESSAGE_SIGNATURE_DICT["value"]:
                                content_log("ARM64 STARTUP_MESSAGE_SIGNATURE_DICT Offset : " + str(hex(arm64_signature_offset)))
                                result["startup_message_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(STARTUP_MESSAGE_SIGNATURE_DICT["size"])
                                content_log("[STARTUP_MESSAGE_SIGNATURE_DICT] : " + str(data))
                                continue
                            if check_sig_data == DETECTION_POPUP_MODE_SIGNATURE_DICT["value"]:
                                content_log("ARM64 DETECTION_POPUP_MODE_SIGNATURE_DICT Offset : " + str(hex(arm64_signature_offset)))
                                result["detection_popup_mode_signature_offset"] = arm64_signature_offset
                                f.seek(arm64_signature_offset,0)
                                data = f.read(DETECTION_POPUP_MODE_SIGNATURE_DICT["size"])
                                content_log("[DETECTION_POPUP_MODE_SIGNATURE_DICT] : " + str(data))
                                continue

        return result
                    
                    
    def update_signature(self, target_mach_o, arm64_signature_offset, signature_size, update_value):
        print("[+] AppGuard: update_signature() Start")
        null_padding = b"\x00"
        padding_size = signature_size - len(update_value)
        null_padding = b"\x00" * padding_size
        update_value_with_null = update_value + null_padding
    
        if arm64_signature_offset != None and update_value != None:
            with open(target_mach_o, "rb+") as f:
                f.seek(arm64_signature_offset)
                for_signature_check = f.read(signature_size)

                f.seek(arm64_signature_offset,0)
                f.write(update_value_with_null)
                content_log("ARM64 Signature Update Success")
                content_log(f"{str(for_signature_check)} -> {str(update_value)}")
        else:
            content_log("arm64_signature_offset != None and update_value != None:")
            return


    def generate_hash(self):
        print("[+] AppGuard: generate_hash() Start")
        arm64_text_sha256 = None
        sha256 = hashlib.sha256()
        sha256.update( self.arm64_text_data )
        arm64_text_sha256 = sha256.hexdigest().encode()
        if arm64_text_sha256 != None:
            content_log("ARM64 Hash : " + str(arm64_text_sha256)  )
        return arm64_text_sha256
    
    def generate_il2cpp_hash(self):
        print("[+] AppGuard: generate_il2cpp_hash() Start")
        arm64_il2cpp_sha256 = None
        if self.isExistIl2cppSection:
            sha256 = hashlib.sha256()
            sha256.update( self.arm64_il2cpp_data )
            arm64_il2cpp_sha256 = sha256.hexdigest().encode()
            if arm64_il2cpp_sha256 != None:
                content_log("ARM64 il2cpp Hash : " + str(arm64_il2cpp_sha256)  )
        return arm64_il2cpp_sha256
    
    def clear_current_job_workspace(self):
        print(f"[+] clear_current_job_workspace()")
        if not self.args.leave_current_workspace :
            clear_workspace_cmd = [f"rm", f"-rf", f"{workspace}"]
            subprocess.check_output(clear_workspace_cmd)
            content_log( f"Current workspace is cleared.: {workspace}")
        else :
            content_log( f"Current workspace not is cleared.: {workspace}")
        return

    def setProtectionLevel(self):
        if self.args.levelBusiness == True:
            self.level = "4" #"--business"   
            if self.args.class_obf:
                print('\n[!] You cannot use --class_obf at the Business Plan.')
                exitWithCode(1)
                return
        elif self.args.levelEnterprise == True:
            self.level = "5" #"--enterprise"
        elif self.args.levelGame == True:
            self.level = "6" #"--game"
        elif self.args.levelObsolete == True:
            self.level = "0" #"--levelObsolete"
        else:
            print('\n[!] protection level is not set.')
            exitWithCode(1)
        return
    
  
    def getRemotePolicy(self, policy_file_name):
        policy_url = f"https://adam.cdn.toastoven.net"
      
        if self.args.alphaServerEnv == True:
            content_log("The Policy CDN is Alpha.")
            policy_url += "/alpha/ios"
        elif self.args.betaServerEnv == True:
            content_log("The Policy CDN is Beta.")
            policy_url += "/beta/ios"
        else:
            content_log("The Policy CDN is Real.")
            policy_url += "/ios"
        
        policy_url+= f"/{self.args.appkey}/{policy_file_name}"
     
        content_log( f"App Key : {self.args.appkey}")
        content_log( f"Policy URL : {policy_url}")

        try:
            response = urllib.request.urlopen(policy_url)
            content_log( f"Response Status code : {response.status}")
            packData = response.read()
       
        except urllib.error.HTTPError as e:
            content_log( f"Policy request is failed(HTTPError code={e.code})")
            content_log( f"reason: {e.reason}")
            content_log( f"headers: {e.headers}")
            return None
        except urllib.error.URLError as e:
            content_log( f"Policy request is failed(URLError)")
            content_log( f"reason: {e.reason}")
            return None
        except:
            content_log( f"Policy request is failed(code=)")
            content_log("generic exception: " + traceback.format_exc())
            return None
        
        return packData

    def update_default_policy(self, protect_target_mach_o, signature_offset, policy_file_name):
        print("[+] AppGuard: Update Default Policy Start")
        
        packData =  self.getRemotePolicy(policy_file_name)
        if packData == None:
            return False
        dataSize = len(packData)
        sig = struct.pack('>H', 0x0101)
        packedDataSize = struct.pack('<L', dataSize)

        self.update_signature(protect_target_mach_o, 
                                signature_offset, 
                                2, 
                                sig)
        self.update_signature(protect_target_mach_o, 
                               signature_offset+4, 
                                4, 
                                packedDataSize)
        self.update_signature(protect_target_mach_o, 
                                signature_offset+8, 
                                dataSize, 
                                packData)

        # warning! 다음 출력 문장으로 서버에서는 기본정책 적용 여부를 판단함. 수정시 서버와 협의 필요.
        content_log(f"policy update data size:{dataSize} data:{packData}") 
        return True
    
    # sdk 버전 시그니처뒤에 버전을 가져옴
    def get_sdk_version_from_signature(self, protect_target_mach_o, signature_offset):
        with open(protect_target_mach_o, "rb+") as f:
            f.seek(signature_offset+ SDK_VERSION_SIGNATURE["size"]+1)
            major_ver = struct.unpack(">h", f.read(2))[0]
            minor_ver = struct.unpack(">h", f.read(2))[0]
            patch_ver = struct.unpack(">h", f.read(2))[0]
            reserved_ver_string = f.read(32).decode('utf-8').rstrip('\x00')
            self.sdk_version = f"{major_ver}.{minor_ver}.{patch_ver} {reserved_ver_string}"
            content_log(f"iOS AppGuard SDK Version : {self.sdk_version}")
            f.close()
        return

    def isExistSectionByName(self, binary, sectionName):
        if binary:
            return binary.get_section(sectionName)
        return None

    def do_process(self):
        self.setProtectionLevel()
        self.ipa_manager.do_unzip()
        main_binary_mach_o = os.path.join(workspace, self.ipa_manager.get_main_binary_mach_o())
        
        if self.ipa_manager.is_it_unity():
            protect_target_mach_o = self.ipa_manager.get_unity_binary_path()
        else:
            protect_target_mach_o = main_binary_mach_o
        
        arm64_il2cpp_hash = None
        # For checking text section hash
        self.init_mach_o_parse(protect_target_mach_o)
        self.read_text_section_in_mach_o(protect_target_mach_o)

        ## For Unity il2cpp
        if self.ipa_manager.is_it_unity():
            self.isExistIl2cppSection = self.isExistSectionByName(self.arm64_binary, il2cpp_section)
            if self.isExistIl2cppSection:
                self.read_il2cpp_section_in_mach_o(protect_target_mach_o)
                arm64_il2cpp_hash = self.generate_il2cpp_hash()
            else:
                print(f"[!] Unity app but can't find the il2cpp section.")

        arm64_hash  = self.generate_hash()

        UPDATE_SIGNATURE_LIST = [HASH_SIGNATURE_DICT, 
                                 SIGNER_SIGNATURE_DICT, 
                                 UNITY_HASH_SIGNATURE_DICT,
                                 NUM_OF_LC_SIGNATURE_DICT, 
                                 PROTECT_LEVEL_SIGNATURE_DICT, 
                                 DEFAULT_POLICY_SIGNATURE_DICT, 
                                 PROTECTOR_VERSION_SIGNATURE, 
                                 SDK_VERSION_SIGNATURE, 
                                 INFO_PLIST_SIGNATURE_DICT, 
                                 UNITY_IL2CPP_HASH_SIGNATURE_DICT, 
                                 APPKEY_SIGNATURE_DICT, 
                                 REACTNATIVE_SIGNATURE_DICT,
                                 FLUTTER_SIGNATURE_DICT,
                                 DEFAULT_JSON_POLICY_SIGNATURE_DICT,
                                 STARTUP_MESSAGE_SIGNATURE_DICT,
                                 DETECTION_POPUP_MODE_SIGNATURE_DICT
                                 ]
        
        WHAT_TO_MAKE_LIST = ["hash_signature_offset", 
                             "signer_signature_offset", 
                             "unity_signature_offset", 
                             "num_of_lc_signature_offset", 
                             "protect_level_signature_offset", 
                             "default_policy_signature_offset", 
                             "protector_version_signature_offset", 
                             "sdk_version_signature_offset", 
                             "info_plist_signature_offset", 
                             "unity_il2cpp_signature_offset", 
                             "appkey_signature_offset", 
                             "reactnative_signature_offset",
                             "flutter_signature_offset",
                             "default_json_policy_signature_offset",
                             "startup_message_signature_offset",
                             "detection_popup_mode_signature_offset"
                             ]
        
        arm64_signatures_dict = self.find_signature_offset(protect_target_mach_o,            # Input mach-o path
                                                         [const_section, cstring_section],   # Where to find
                                                         UPDATE_SIGNATURE_LIST,              # What to find
                                                         WHAT_TO_MAKE_LIST)                
        # Get SDK Version and Replace
        if arm64_signatures_dict["sdk_version_signature_offset"] != None:
            print(f"[+] Gets the applied SDK version.")
            self.get_sdk_version_from_signature(protect_target_mach_o, arm64_signatures_dict["sdk_version_signature_offset"])
        else:
            print(f"[!] The SDK Version is unknown.(sdk version signature is not found. (<1.3.0))")

        #  Insert Protector Version Signature
        if arm64_signatures_dict["protector_version_signature_offset"] != None:
            protector_version_bytes = bytes(APPGUARD_PROTECT_VER.encode())
            self.update_signature(protect_target_mach_o, 
                                  arm64_signatures_dict["protector_version_signature_offset"], 
                                  PROTECTOR_VERSION_SIGNATURE["size"], 
                                  protector_version_bytes)
        else:
            print(f"[!] Protector version signature is not found.")

        # For insert default policy from console.
        if self.args.appkey == None:
            print(f"[+] Skip the Insert Default Policy task. Please input appkey.")
        else:
            if arm64_signatures_dict["default_policy_signature_offset"] != None:
                print(f"[+] The old format default policy is applied.(policy.ag3)")
                if self.update_default_policy(protect_target_mach_o, arm64_signatures_dict["default_policy_signature_offset"], "policy.ag3") == False:
                    print("Fail to update default policy")
                    exitWithCode(1)

            elif arm64_signatures_dict["default_json_policy_signature_offset"] != None:
                print(f"[+] The new json format default policy is applied.(policy.json)")
                if self.update_default_policy(protect_target_mach_o, arm64_signatures_dict["default_json_policy_signature_offset"], "policy.json") == False:
                    print("Fail to update default policy v2")
                    exitWithCode(1)
            else:
                print(f"[+] Skip the Insert Default Policy task. Can't find default policy signature.")
        
        if self.ipa_manager.is_it_unity():
            self.update_signature(protect_target_mach_o, 
                                  arm64_signatures_dict["unity_signature_offset"], 
                                  UNITY_HASH_SIGNATURE_DICT["size"], 
                                  arm64_hash)
                                   
            if arm64_signatures_dict['unity_il2cpp_signature_offset'] != None:
                if arm64_il2cpp_hash != None:
                    self.update_signature(protect_target_mach_o,
                        arm64_signatures_dict["unity_il2cpp_signature_offset"],
                        UNITY_IL2CPP_HASH_SIGNATURE_DICT["size"],
                        arm64_il2cpp_hash)
                else:
                    print(f"[+] Skip the il2cpp section signature. Can't calculate il2cpp hash.")
            else:
                print(f"[+] Skip the il2cpp section signature. Can't find il2cpp signature.")

        else:
            self.update_signature(protect_target_mach_o, 
                                  arm64_signatures_dict["hash_signature_offset"], 
                                  HASH_SIGNATURE_DICT["size"], 
                                  arm64_hash)
            
        self.update_signature(protect_target_mach_o, 
                              arm64_signatures_dict["num_of_lc_signature_offset"], 
                              NUM_OF_LC_SIGNATURE_DICT["size"], 
                              str(self.arm64_binary.header.nb_cmds).encode())
        
        # React Native 
        if len(self.args.jsbundleFile) != 0:
            print(f"[+] Protect react native jsbundle ")
            if arm64_signatures_dict["reactnative_signature_offset"] == None:
                print(f"Unsupport sdk version: {self.sdk_version}")
                exitWithCode(1)

            if self.ipa_manager.is_reactnative_jsbundle_file(self.args.jsbundleFile) == False :
                print(f"Can't find jsbundle {self.args.jsbundleFile}")
                exitWithCode(1)

            jsbundleFilePath = self.ipa_manager.get_reactnative_jsbundle_file_path(self.args.jsbundleFile)
            react_native_bundle_manager = AppGuardReactNativeJSBundleManager(jsbundleFilePath, self.args.appkey)
            if react_native_bundle_manager.process() == False :
                print(f"Unable to process jsbundle file.")
                exitWithCode(1)

            appguard_react_native_engine_header = react_native_bundle_manager.get_packed_appguard_react_native_engine_header()
            if appguard_react_native_engine_header != None:
                self.update_signature(protect_target_mach_o, arm64_signatures_dict["reactnative_signature_offset"], len(appguard_react_native_engine_header), appguard_react_native_engine_header)
        
        # Flutter 
        if self.args.isFlutter :
            print(f"[+] Protect Flutter App")
            if arm64_signatures_dict["flutter_signature_offset"] == None:
                print(f"Unsupport sdk version: {self.sdk_version}")
                exitWithCode(1)
            app_framework_bin_file = self.ipa_manager.get_flutter_app_framework_binary_file_path()
            flutter_framework_bin_file = self.ipa_manager.get_flutter_framework_binary_file_path()
            
            if app_framework_bin_file == None or flutter_framework_bin_file == None :
                print(f"Can't find flutter app.framework or flutter.framework ")
                exitWithCode(1)
            flutter_manager = AppGuardFlutterManager(app_framework_bin_file, flutter_framework_bin_file)
            if flutter_manager.process() :
                flutter_signature_packed = flutter_manager.get_flutter_signature_packed()
                if flutter_signature_packed != None:
                    self.update_signature(protect_target_mach_o, arm64_signatures_dict["flutter_signature_offset"], len(flutter_signature_packed), flutter_signature_packed)
                else:
                    print(f"failed to update flutter signature")
                    exitWithCode(1)
            else:
                print(f"Failed to protect flutter app.")
                exitWithCode(1)

        # For checking Protect Level Info
        if arm64_signatures_dict['protect_level_signature_offset'] is not None: # 시그니처를 갖고있다면 업데이트.
            if (4 <= int(self.level) and int(self.level) <= 6) or (int(self.level) == 0) :
                print(f"protect_level_signature_offset: {hex(arm64_signatures_dict['protect_level_signature_offset'])}")
                protectLevelNewSignature = str(PROTECT_LEVEL_REPLACE_SIGNATURE + self.level).encode()
                self.update_signature(protect_target_mach_o, arm64_signatures_dict["protect_level_signature_offset"], PROTECT_LEVEL_SIGNATURE_DICT["size"], protectLevelNewSignature)
                
                if self.checkProtectLevelSignatureUpdate(protect_target_mach_o, arm64_signatures_dict["protect_level_signature_offset"], PROTECT_LEVEL_SIGNATURE_DICT["size"]) == False :
                        print("The protection operation failed because the protection level update verification failed.")
                        exitWithCode(1)
                print(f"new protectLevelNewSignature: {protectLevelNewSignature}")
        else:
            print(f"Protect Level Signature is not found.")
            if int(self.level) != 0: # 서버에서는 이전버전 사용자만 --obsolete 파라미터를 보장함. 이전버전 SDK를 사용하면서 신규 요금정책을 사용할 수 없음.
                print(f"The protection operation failed because the sdk Version Invalid.")
                exitWithCode(1)
        # For checking Info.plist 
        if arm64_signatures_dict['info_plist_signature_offset'] is not None:
            self.updateInfoPlistSignatureUpdate(protect_target_mach_o, arm64_signatures_dict["info_plist_signature_offset"])
        else:
            print(f"Info.plist Signature is not found.")

        # For checking Signer Info
        if self.signer != "":
            self.signer = self.signer[1:-1] # CLI에서 서명자를 인자로 받아 서버로 보내는 과정에서 큰 따옴표가 붙어있기 때문에 이를 제거
            content_log(f"signer : {self.signer}")
            signerSha256 = hashlib.sha256( self.signer.encode() ).hexdigest().encode()
            
            content_log(f"signer hash : {signerSha256}")
            self.update_signature(protect_target_mach_o, arm64_signatures_dict["signer_signature_offset"], 128, signerSha256)

        # For checking Appkey
        if len(self.args.appkey) < 512:
            if arm64_signatures_dict['appkey_signature_offset'] is not None:
                self.updateAppkeySignature(protect_target_mach_o, arm64_signatures_dict["appkey_signature_offset"])
            else:
                print(f"[!] Appvkey signauture is not found.")
        else:
            print(f"[!] App Key length is over (512).")

        # Class Name Obfuscation
        if self.args.class_obf and not self.ipa_manager.is_it_unity() and len(self.args.jsbundleFile) == 0 and self.args.isFlutter == False :
            class_obf = ClassObfuscator(main_binary_mach_o, self.arm64_binary, None, None, [])
            class_obf.do_process()
        
        # For checking Startup Message
        if self.args.show_startup_message:
            if arm64_signatures_dict['startup_message_signature_offset'] is not None:
                startup_message = str(STARTUP_MESSAGE_SIGNATURE_DICT["value"]).encode()
                self.update_startup_message_signature(protect_target_mach_o, arm64_signatures_dict["startup_message_signature_offset"])
            else:
                print(f"[!] Startup Message Signature is not found.")
        else:
            print(f"[!] Skip the Startup Message Signature Update.")

        # For detection popup mode
        if self.args.detectionPopupMode is not None:
            if arm64_signatures_dict['detection_popup_mode_signature_offset'] is not None:
                self.update_detection_popup_mode_signature(protect_target_mach_o, arm64_signatures_dict['detection_popup_mode_signature_offset'])
            else:
                print(f"[!] detection popup mode Signature is not found.")
        else:
            print(f"[!] Skip the detection popup mode Signature Update.")
            
        # Repackaging (finsih protection)
        self.ipa_manager.do_resign()
        self.ipa_manager.do_bundling()

        # Clear current workspace (by -lw)
        self.clear_current_job_workspace()

        print("Protection completed.")
        exitWithCode(0)
    
    def getInfoPlistSignature(self):
        info_plist_path = self.ipa_manager.get_bundle_info_plist_path()
        signature = None
        
        with open(info_plist_path, "rb") as f:
            pl = plistlib.load(f)
            values = ""
            plistKeys = [CFBundleExecutable, CFBundleIdentifier, CFBundleVersion, CFBundleShortVersionString]
            for key in plistKeys:
                if key in pl:
                    values += f"{pl[key]}|"
                else:
                    values += "|"
            signature = hashlib.sha256(values.encode('utf-8')).hexdigest()
        return signature
        
    def updateInfoPlistSignatureUpdate(self, target_mach_o, signature_offset):
        print(f"[+] updateInfoPlistSignatureUpdate()")
        content_log( f"Info.plist offset: {signature_offset}")
        offset = signature_offset
        info_plist_hash = self.getInfoPlistSignature()
        resource_type = struct.pack('<i', 4837) # AGResourceTypeInfoPlist
        info_plist_size = 0 # reserved
        info_plist_size_packed = struct.pack('<Q', info_plist_size) # unsigned long long
        content_log( f"Info.plist resource_type: {resource_type}")
        content_log( f"Info.plist hash: {info_plist_hash}")
        content_log( f"Info.plist size: {info_plist_size} bytes")

        ## 8바이트 align을 맞춤.
        self.update_signature(target_mach_o, offset, 64 + 8, str(INFO_PLIST_REPLACE_SIGNATURE).encode('utf-8'))
        offset = offset + 64 + 8
        self.update_signature(target_mach_o, offset, 64 + 8, str(info_plist_hash).encode('utf-8'))
        offset = offset + 64 + 8
        self.update_signature(target_mach_o, offset , 8, info_plist_size_packed)
        offset = offset + 8
        self.update_signature(target_mach_o, offset , 4, resource_type)

        return 
    
    def updateAppkeySignature(self, target_mach_o, signature_offset):
        print(f"[+] updateAppkeySignature()")
        content_log( f"App key signature offset: {signature_offset}")
        offset = signature_offset
        appkey_length = len(self.args.appkey)

        ## replace signature
        self.update_signature(target_mach_o, offset, 128 + 8, str(APPKEY_REPLACE_SIGNATURE).encode('utf-8'))
        content_log( f"Update App key Signature: {str(APPKEY_REPLACE_SIGNATURE)}")

        ## appkey encoding by first character (XOR) but null character is not.
        encAppkey =  bytearray(self.args.appkey.encode('utf-8')) 
        xorKey = encAppkey[0]
        for i in range(appkey_length):
            if encAppkey[i] ^ xorKey != 0x00:
                encAppkey[i] = encAppkey[i] ^ xorKey
        offset = offset + 128 + 8
        self.update_signature(target_mach_o, offset, appkey_length,  encAppkey)
        offset = offset + 512 + 8

        ## insert original api key string length as packed int
        appkey_len_packed = struct.pack('<i', appkey_length)
        self.update_signature(target_mach_o, offset, 4,  appkey_len_packed)
        content_log( f"Update App key : {str(self.args.appkey)} encoded: {encAppkey} App key length: {appkey_length}")
        return
    
    def update_startup_message_signature(self, target_mach_o, signature_offset):
        print(f"[+] update_startup_message_signature()")
        content_log( f"Startup message signature offset: {signature_offset}")
        offset = signature_offset
        AGStarupMessageReplaceSignature = {
            'signature': STARTUP_MESSAGE_REPLACE_SIGNATURE,
            'duration': self.args.startup_message_duration,
            'delay': self.args.startup_message_delay
        }
        packedSignature = struct.pack(
            '<68sII', 
            AGStarupMessageReplaceSignature['signature'].encode('utf-8'), 
            AGStarupMessageReplaceSignature['duration'],
            AGStarupMessageReplaceSignature['delay'])
        self.update_signature(target_mach_o, offset, 256, packedSignature)
        content_log( f"Update Startup Message Signature: {AGStarupMessageReplaceSignature}")
        return
        
    def update_detection_popup_mode_signature(self, target_mach_o, signature_offset):
        print(f"[+] update_detection_popup_mode_signature()")
        content_log( f"detection_popup_mode signature offset: {signature_offset}")
        offset = signature_offset
        mode = int(0)
        if self.args.detectionPopupMode == 'simple' :
            mode = int(1)
        elif self.args.detectionPopupMode == 'detailed' :
            mode = int(0)
        else :
            print(f"[!] Invalid detection popup mode set = detailed(0)")
            mode = int(0)

        AGDetectionPopupModeSignature = {
            'signature': DETECTION_POPUP_MODE_REPLACE_SIGNATURE,
            'mode': mode,
        }
        packedSignature = struct.pack(
            '<68sI',
            AGDetectionPopupModeSignature['signature'].encode('utf-8'),
            AGDetectionPopupModeSignature['mode'])
        self.update_signature(target_mach_o, offset, 256, packedSignature)
        content_log( f"Update detection popup mode Signature: {AGDetectionPopupModeSignature}")
        return
        
    def checkProtectLevelSignatureUpdate(self, target_mach_o, signature_offset, signature_size):
        print(f"[+] checkProtectLevelSignatureUpdate()")
        input_update_level_bytes = bytes(self.level.encode())
        with open(target_mach_o, "rb+") as f:
            f.seek(signature_offset)
            updated_protect_level_signature = f.read(signature_size).decode('utf-8').rstrip('\x00')
            newSignitureLen = len(updated_protect_level_signature)
            replaceSignature = updated_protect_level_signature[0:newSignitureLen-1]
            level = updated_protect_level_signature[newSignitureLen-1]
            if replaceSignature == PROTECT_LEVEL_REPLACE_SIGNATURE and self.level == level and newSignitureLen == len(PROTECT_LEVEL_REPLACE_SIGNATURE)+1:
                content_log( f"The protection level is valid. update level:{level} signature:{updated_protect_level_signature}")
                return True
        content_log( f"The protection level is invalid.")
        return False       
        
def output_name_parse(output):
    print(f"[+] output_name_parse()")
    changed_output = output
    if output.find("/") == -1:
        changed_output = "./"+changed_output
    if output.find("ipa") == -1:
        changed_output = changed_output + ".ipa"
    
    if output == changed_output:
        content_log( f"\"{output}\" is Normal" )
    else:
        content_log( f"\"{output}\" => \"{changed_output}\"" )

    return changed_output



# 실행 예) python3 AppGuard.py -c 
def clear_workspace_root():
    print("[+] Start clear_workspace()")
    workspace_dir_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "workspace")
    clear_workspace_cmd = [f"rm", f"-rf", f"{workspace_dir_path}"]
    subprocess.check_output(clear_workspace_cmd)
    
    clear_output_cmd = [f"rm", f"-rf", f"./out"]
    subprocess.check_output(clear_output_cmd)



if __name__ == "__main__":
    
    #인증서 에러 무시 테스트
    # import ssl
    # ssl._create_default_https_context = ssl._create_unverified_context

    parser = argparse.ArgumentParser(description="NHN AppGuard Protector")
    parser.add_argument('--ipa', '-i', help='Input Your IPA', required=True)  # ipa명을 인자로 받는 옵션 (필수)
    parser.add_argument('--appkey', '-v', help='input NHN Cloud appkey', required=False)  # Appkey 을 인자로 받는 옵션 (Appkey가 없으면 콘솔 디폴트 정책 적용하지 않음)
    parser.add_argument('--output', '-o', help='Output Name', default="./out/Protected-App.ipa") # output 명을 입력 (기본값은 "./out/Protected-App.ipa" )
    parser.add_argument('--clear', '-c', help='Clear Workspace root folder before job processing.', action="store_true") # 작업 처리전 workspace root를 정리하기 위한 옵션 (기본값은 False)
    parser.add_argument('--class_obf', help='Class Obfuscation', action="store_true") # 클래스 난독화를 위한 옵션 (기본값은 False)
    parser.add_argument('--signer', '-s', help='Signer Name', default="") # 서명자를 입력받기 위한 옵션 (기본값 "")
   
    protectLevelGroup = parser.add_mutually_exclusive_group(required=False)
    protectLevelGroup.add_argument('--business', action='store_true', dest="levelBusiness", default=False, help='Set Business plan')
    protectLevelGroup.add_argument('--enterprise', action='store_true', dest="levelEnterprise", default=False, help='Set Enterprise plan')
    protectLevelGroup.add_argument('--game', action='store_true', dest="levelGame", default=False, help='Set Game plan')
    protectLevelGroup.add_argument('--obsolete', action='store_true', dest="levelObsolete", default=False, help='Set previous user plan')
    serverEnvGroup = parser.add_mutually_exclusive_group(required=False)
    # 서버 선택
    serverEnvGroup.add_argument('--alpha', action='store_true', dest='alphaServerEnv', default=None,
                                help=argparse.SUPPRESS)
    serverEnvGroup.add_argument('--beta', action='store_true', dest='betaServerEnv', default=None,
                                help=argparse.SUPPRESS)

    # crossplatformApp Protection 
    crossplatformGroup = parser.add_mutually_exclusive_group(required=False)
    # react native
    crossplatformGroup.add_argument('--react-native', '-rn', help="react native jsbundle", type=str, required=False, default="", dest="jsbundleFile") # jsbundle파일을 입력받음.
    # Flutter
    crossplatformGroup.add_argument('--flutter', action='store_true', help="flutter app protection", default=False, required=False, dest="isFlutter") 
    
    # startup message

    # StartUp Message
    parser.add_argument('--show-startup-message', action='store_true', default=False, dest="show_startup_message", help="Show the startup message.")
    parser.add_argument('--show-startup-message-duration', type=int, default=DEFAULT_STARTUP_MESSAGE_DURATION, dest="startup_message_duration", help="Duration (in millisecond) for which the startup message is displayed.")
    parser.add_argument('--show-startup-message-delay', type=int, default=DEFAULT_STARTUP_MESSAGE_DELAY, dest="startup_message_delay", help="Delay (in millisecond) for which the startup message is displayed. Requires --show-startup-message.")

    # simple popup
    parser.add_argument('--detection-popup-mode', default="detailed", dest="detectionPopupMode")
        
    parser.add_argument('--leave_current_workspace', '-lw', default=False, help='Leave the current workspace after processing the job.', action="store_true") # 작업 후 현재 작업 워크스페이스를 지우지 않기
    args = parser.parse_args()
    
    print(f"[+] ---- AppGuard-Protector Version :{ APPGUARD_PROTECT_VER } ----- ")
    print(f"[+] --------- {datetime.now().strftime('%Y-%m-%d-%H-%M-%S')}  -------------- ")
    print(f"[+] --------- Current job workspace : {workspace}  -------------- ")
    
    if args.clear:  
        clear_workspace_root()
        
    appguard = AppGuard(args, output_name_parse(args.output))
    appguard.do_process()

