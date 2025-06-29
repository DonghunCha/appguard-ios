import struct
import os
import hashlib
import lief
from AppGuardMachOLoader import *
FLUTTER_SIGNATURE_MAGIC_UINT64 = 0x251203E103BF3E31

class AppGuardFlutterManager:
    __app_framework_path = None
    __flutter_framework_path = None
    __app_framework_macho_loader = None
    __flutter_framework_macho_loader = None
    __app_framework_const_section_hash = None
    __app_framework_text_section_hash = None
    __flutter_framework_text_section_hash = None
   

    def __init__(self, app_framework_path, flutter_framework_path):
        self.__app_framework_path = app_framework_path
        self.__flutter_framework_path = flutter_framework_path
        return
    
    def __get_app_framework_const_section_hash(self):
        if self.__app_framework_path == None:
            return None
        
        return None
    def __get_app_framework_text_section_hash(self):
        if self.__app_framework_path == None:
            return None
        
        return None
    def __get_flutter_framework_text_section_hash(self):
        
        return None
    
    def __get_flutter_signature(self):
        appguard_flutter_signature = {
            'magic' : FLUTTER_SIGNATURE_MAGIC_UINT64,
            'flutterFrameworkTextSectionHash': self.__flutter_framework_text_section_hash.encode('utf-8'),
            'appFrameworkConstSectionHash':  self.__app_framework_const_section_hash.encode('utf-8'),
            'appFrameworkTextSectionHash': self.__app_framework_text_section_hash.encode('utf-8')
        }
        print(appguard_flutter_signature)
        return appguard_flutter_signature
    
    def get_flutter_signature_packed(self):
        pack_format_string = "<Q68s68s68s"
        appguard_flutter_signature = self.__get_flutter_signature()
        appguard_flutter_signature_packed_data = struct.pack(pack_format_string, 
                                                            appguard_flutter_signature['magic'],
                                                            appguard_flutter_signature['flutterFrameworkTextSectionHash'],
                                                            appguard_flutter_signature['appFrameworkConstSectionHash'],
                                                            appguard_flutter_signature['appFrameworkTextSectionHash'],
                                                            )
        return appguard_flutter_signature_packed_data

    def process(self):
        self.__app_framework_macho_loader = AppGuardMachOLoader(self.__app_framework_path)
        if self.__app_framework_macho_loader == None:
            return False
        
        self.__flutter_framework_macho_loader = AppGuardMachOLoader(self.__flutter_framework_path)
        if self.__flutter_framework_macho_loader == None:
            return False
        
        self.__app_framework_const_section_hash = self.__app_framework_macho_loader.get_section_sha256_hash_string("__const")
        if self.__app_framework_const_section_hash is None:
            return False
        print(f"app_framework_const_section_hash: {self.__app_framework_const_section_hash} ")

        self.__app_framework_text_section_hash = self.__app_framework_macho_loader.get_section_sha256_hash_string("__text")
        if self.__app_framework_text_section_hash is None:
            return False
        print(f"app_framework_text_section_hash: {self.__app_framework_text_section_hash} ")

        self.__flutter_framework_text_section_hash = self.__flutter_framework_macho_loader.get_section_sha256_hash_string("__text")
        if self.__flutter_framework_text_section_hash is None:
            return False
     
        print(f"flutter_framework_text_section_hash: {self.__flutter_framework_text_section_hash} ")
        return True
