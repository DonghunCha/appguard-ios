import lief
import hashlib
from lief.MachO import CPU_TYPES

class AppGuardMachOLoader:
    __machOBinary = None
    __arm64_binary = None
    __arm64_offset = None
    __is_fat_binary = False
    __arm_binary = None
    __arm_offset = None
    __machOFilePath = None

    def __init__(self, binary_path):
        self.__machOFilePath = binary_path
        self.__machOBinary = lief.MachO.parse(binary_path)
        # if  self.__machOBinary.FatBinary:
        #     self.__is_fat_binary = True
        for binary in self.__machOBinary:
            if binary.header.cpu_type == CPU_TYPES.ARM:
                self.__is_fat_binary = True
                self.__arm_binary = binary.fat_offset
            elif binary.header.cpu_type == CPU_TYPES.ARM64:
                self.__arm64_offset = binary.fat_offset
                self.__arm64_binary = binary

    def __get_bytes(self, offset, size):
        with open(self.__machOFilePath, "rb") as f:
            f.seek(offset)
            return f.read(size)
        return None
    
    def get_section(self, section_name, arch = CPU_TYPES.ARM64):
        [binary, binary_offset] = self.__get_binary_and_offset_by_arch(arch)
        if binary is None:
            return None
        
        section = binary.get_section(section_name)
        if section is None:
            return None
        return section
    
    def get_section_bytes(self, section_name, arch = CPU_TYPES.ARM64):
        [binary, binary_offset] = self.__get_binary_and_offset_by_arch(arch)

        if binary is None:
            return None
        
        section = binary.get_section(section_name)
        if section is None:
            return None
        
        return self.__get_bytes(binary_offset+section.offset, section.size)
    
    def __get_binary_and_offset_by_arch(self, arch=CPU_TYPES.ARM64):
        if arch == CPU_TYPES.ARM64:
            return [self.__arm64_binary, self.__arm64_offset]
        if arch == CPU_TYPES.ARM:
            return [self.__arm_binary, self.__arm_offset]
        return [None, None]
    
    def get_section_sha256_hash_string(self, section_name, arch = CPU_TYPES.ARM64):
       
        section_data = self.get_section_bytes(section_name, arch)
        if section_data is None:
            return None
        
        sha256 = hashlib.sha256()
        sha256.update(section_data)
        return sha256.hexdigest()
      
    def get_section_sha256_hash_digest(self, section_name, arch = CPU_TYPES.ARM64):
        section_data = self.get_section_bytes(section_name, arch)
        if section_data is None:
            return None
        
        sha256 = hashlib.sha256()
        sha256.update(section_data)
        return sha256.digest()