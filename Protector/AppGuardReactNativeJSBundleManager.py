import struct
from CryptoUtil import encryptAES256EBC
import struct
import hashlib
from Config import APPGUARD_REACTNATIVE_HEADER_MAGIC
import os
from os import SEEK_END
from Logger import *

REACTNATIVE_RAMBUNDLE_MAGIC_UINT32 = 0xFB0BD1E5 
REACTNATIVE_HERMES_BC_BUNDLE_MAGIC_UINT64 = 0x1F1903C103BC1FC6
REACTNATIVE_BUNDLE_HEADER_SIZE = 12
BUNDLE_NAME_XOR_KEY = 24
BUNDLE_NAME_MAX_LEN = 128

class AGReactNativeJsbundleHeaderOptions:
    Compressed = 1 << 0  # 1
    Encrypted = 1 << 1  # 2

class AGReactNativeBundleTypes:
    HermesBCBundle = 0
    StringBundle = 1
    RamBundle = 2

class AppGuardReactNativeJSBundleManager:
    __bundle_path = None
    __file_size = 0
    __is_ram_bundle = False
    __is_hermes_Bundle = False
    __bundle_file_name = ""
    __original_payload_length = 0
    __original_payload = None
    __compressed_payload_length = 0
    __jsbundle_header = None
    __original_hash = None
    __appkey = ""
    __original_hash_string = ""
    __encrypt_key = None
    __encrypt_payload_length = 0

    def __init__(self, bundlePath, appkey):
        self.__bundle_path = bundlePath
        self.__appkey = appkey
        self.__bundle_file_name = os.path.basename(self.__bundle_path)
    
    def __check_hermes_bc_bundle(self, fd): 
        prev_fd_ptr = fd.tell()
        fd.seek(0)
        header = fd.read(8)
        fd.seek(0, prev_fd_ptr)

        magic = struct.unpack('<Q', header)[0]
        if magic == REACTNATIVE_HERMES_BC_BUNDLE_MAGIC_UINT64:
            return True
        return False
  
    def __check_rambundle(self, fd): 
        prev_fd_ptr = fd.tell()
        fd.seek(0)
        header = fd.read(4)
        fd.seek(0, prev_fd_ptr)
        
        magic = struct.unpack('<I', header)[0]
        if magic ==  REACTNATIVE_RAMBUNDLE_MAGIC_UINT32:
            return True
        return False

    def __xor_bundle_name(self):
        string_bytes =  self.__bundle_file_name.encode('utf-8')

        result = bytearray(b'\x00' * BUNDLE_NAME_MAX_LEN)
        for i in range(len(self.__bundle_file_name)):
            result[i] = string_bytes[i] ^ BUNDLE_NAME_XOR_KEY;
        
        return bytes(result);
    
    def process(self):
        with open(self.__bundle_path, 'rb') as file:
            file.seek(0, SEEK_END)  
            self.__file_size = file.tell()
            file.seek(0)
            self.__is_ram_bundle = self.__check_rambundle(file)
            self.__is_hermes_Bundle = self.__check_hermes_bc_bundle(file)

            content_log(f"__is_hermes_Bundle: {self.__is_hermes_Bundle}")
            content_log(f"__is_ram_bundle: {self.__is_ram_bundle}")

            if self.__is_hermes_Bundle == True and self.__is_ram_bundle == False:
                file.seek(0)
                self.__jsbundle_header = file.read(REACTNATIVE_BUNDLE_HEADER_SIZE)
            file.seek(0)

            self.__original_payload_length = self.__file_size
            content_log(f"File Size: {self.__original_payload_length}")
            self.__original_payload = file.read(self.__original_payload_length)
            

            hashObject = hashlib.sha256()
            hashObject.update(self.__original_payload)
            self.__original_hash = hashObject.digest()
            self.__original_hash_string = hashObject.hexdigest()
            content_log(f"Original Payload Hash : {self.__original_hash_string} {self.__original_hash}")
            if self.__is_ram_bundle == True:
                return
            
            key_string = self.__appkey +  self.__original_hash_string
            hashObject = hashlib.sha256()
            hashObject.update(key_string.encode('utf-8'))
            self.__encrypt_key = hashObject.digest()
            encrypted_payload = encryptAES256EBC(self.__original_payload, self.__original_payload_length, self.__encrypt_key)
            self.__encrypt_payload_length = len(encrypted_payload)

            output_file = f"{self.__bundle_path}.enc"

            with open(output_file, 'wb') as file:
                if self.__is_hermes_Bundle:
                    file.write(self.__jsbundle_header)
                file.write(self.get_packed_appguard_react_native_bundle_header())
                file.write(encrypted_payload)

            os.unlink(self.__bundle_path)
            os.rename(output_file, self.__bundle_path)
        return True
    
    def get_appguard_react_native_bundle_header(self):
        AGReactNativeJsbundleHeader = {
            'ag_magic' : APPGUARD_REACTNATIVE_HEADER_MAGIC,
            'original_hash': b'\00' * 32,
            'original_payload_length': 0,
            'encrypted_payload_length': 0,
            'compressed_payload_length': 0, 
            'options' : 0,
            'reserved' :0,
        }
        AGReactNativeJsbundleHeader['original_hash'] = self.__original_hash
        AGReactNativeJsbundleHeader['original_payload_length'] = self.__original_payload_length
        AGReactNativeJsbundleHeader['encrypted_payload_length'] = self.__encrypt_payload_length
        ## 압축안함.
        #AGReactNativeJsbundleHeader['options'] |= AGReactNativeJsbundleHeaderOptions.Compressed
        if self.__encrypt_payload_length != 0:
            AGReactNativeJsbundleHeader['options'] |= AGReactNativeJsbundleHeaderOptions.Encrypted

        content_log(f"AGReactNativeJsbundleHeader : {AGReactNativeJsbundleHeader}")
        return AGReactNativeJsbundleHeader
    
    def get_packed_appguard_react_native_bundle_header(self):
        format_string = "<Q32sQQQIQ"
        AGReactNativeJsbundleHeader = self.get_appguard_react_native_bundle_header()
        AGReactNativeJsbundleHeader_packed_data = struct.pack(format_string, 
                                  AGReactNativeJsbundleHeader['ag_magic'],
                                  AGReactNativeJsbundleHeader['original_hash'], 
                                  AGReactNativeJsbundleHeader['original_payload_length'], 
                                  AGReactNativeJsbundleHeader['encrypted_payload_length'], 
                                  AGReactNativeJsbundleHeader['compressed_payload_length'], 
                                  AGReactNativeJsbundleHeader['options'],
                                  AGReactNativeJsbundleHeader['reserved']
                                )
        
        content_log(f"AGReactNativeJsbundleHeader_packed_data : {AGReactNativeJsbundleHeader_packed_data}")
        
        return AGReactNativeJsbundleHeader_packed_data
    def get_appguard_react_native_engine_header(self):
        
        AGReactNativeEngineHeader = {
            "ag_magic" : APPGUARD_REACTNATIVE_HEADER_MAGIC,
            "xor_js_bundle_name": b'\00' * BUNDLE_NAME_MAX_LEN,
            "bundle_type": 0,
            "integrity_check_only": 0,
            "appguard_react_native_jsbundle_header" : self.get_appguard_react_native_bundle_header()
        }
        xor_bundle_name = self.__xor_bundle_name()
        if xor_bundle_name == None:
            AGReactNativeEngineHeader["xor_js_bundle_name"] = b'\00' * BUNDLE_NAME_MAX_LEN
        else:
            AGReactNativeEngineHeader["xor_js_bundle_name"] = xor_bundle_name

        if self.__is_ram_bundle:
            AGReactNativeEngineHeader["bundle_type"] = AGReactNativeBundleTypes.RamBundle
            AGReactNativeEngineHeader["integrity_check_only"] = 1
        elif self.__is_hermes_Bundle:
            AGReactNativeEngineHeader["bundle_type"] = AGReactNativeBundleTypes.HermesBCBundle
        else:
            AGReactNativeEngineHeader["bundle_type"] = AGReactNativeBundleTypes.StringBundle

        content_log(f"AGReactNativeEngineHeader : {AGReactNativeEngineHeader}")
        return AGReactNativeEngineHeader
    
    def get_packed_appguard_react_native_engine_header(self):
        format_string = "<Q128sIIQ32sQQQIQ"
        AGReactNativeEngineHeader = self.get_appguard_react_native_engine_header()

        AGReactNativeEngineHeader_packed_data = struct.pack(format_string,
                                                AGReactNativeEngineHeader["ag_magic"],
                                                AGReactNativeEngineHeader["xor_js_bundle_name"],
                                                AGReactNativeEngineHeader["bundle_type"],
                                                AGReactNativeEngineHeader["integrity_check_only"],
                                                AGReactNativeEngineHeader["appguard_react_native_jsbundle_header"]["ag_magic"],
                                                AGReactNativeEngineHeader["appguard_react_native_jsbundle_header"]["original_hash"],
                                                AGReactNativeEngineHeader["appguard_react_native_jsbundle_header"]["original_payload_length"],
                                                AGReactNativeEngineHeader["appguard_react_native_jsbundle_header"]["encrypted_payload_length"],
                                                AGReactNativeEngineHeader["appguard_react_native_jsbundle_header"]["compressed_payload_length"],
                                                AGReactNativeEngineHeader["appguard_react_native_jsbundle_header"]["options"],
                                                AGReactNativeEngineHeader["appguard_react_native_jsbundle_header"]["reserved"]
                                                ) 
        
        content_log(f"AGReactNativeEngineHeader_packed_data : {AGReactNativeEngineHeader_packed_data}")
        return AGReactNativeEngineHeader_packed_data