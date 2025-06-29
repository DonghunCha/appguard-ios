import lief
import os
import random
from Logger import *


class ClassObfuscator:
    def __init__(self, mach_o, arm64_binary, output, level=None, custom_exception_class_list=[]):
        self.mach_o                 = mach_o
        self.arm64_binary           = arm64_binary
        self.output                 = output
        self.objc_classname_section = None
        self.classname_list         = []
        self.exception_class_list   = ["ns", "ui", "delegate", "system", "animation", "view", "web", "core", "scene", "app", "window", "gad", "apm", "pod", "fir", "kit"]
        self.exception_class_list.extend(custom_exception_class_list)
        self.obfuscation_list = []
        self.words_dir_path   = os.path.join(os.path.dirname(os.path.abspath(__file__)), "words")
        self.level  = level
        self.word4  = [] # 네 글자 랜덤문자열
        self.word5  = [] # 다섯 글자 랜덤문자열 
        self.word6  = []
        self.word7  = []
        self.word8  = []
        self.word9  = []
        self.word10 = []
        self.word11 = []
        self.word12 = []
        self.word13 = []
        self.word14 = []
        self.word15 = []
        self.word16 = []
        self.word17 = []
        self.word18 = []
        self.word19 = []
        self.word20 = []
        self.word21 = []
        self.word22 = []
        self.word23 = []
        self.word24 = [] # 스물 네 글자 랜덤문자열

    
    # Only For developer 
    # 문자열 파일을 읽어서, 글자 개수별로 sort 하여 파일을 만들어줌. ex. 네 글자로 이뤄진 문자열은 words4.txt
    def make_words_file(self): 
        with open(f'{self.words_dir_path}/words.txt') as word_file:
            words = word_file.read().split()
            english_words = sorted(words, key=len)

        for i in range(4, 25):
            with open(f'words{i}.txt', "w") as word_file:
                for word in english_words:
                    if len(word) == i:
                        word_file.write(word+"\n")


    def read_all_words(self):
        words_dir_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "words")
        k = 0
        for i in range(4, 25):
            with open(f'{words_dir_path}/words{i}.txt', "r") as word_file:
                words = word_file.read().split()
                setattr(self, f'word{i}', words)


    def do_process(self):
        print("[+] ClassObfuscator: do_process() Start")
        self.read_all_words()

        self.objc_classname_section = self.arm64_binary.get_section("__objc_classname")
        self.objc_classname_section.offset += self.arm64_binary.fat_offset      
        
        content_log("__objc_classname offset : " + str(hex(self.objc_classname_section.offset)))
        content_log("__objc_classname size   : " + str(hex(self.objc_classname_section.size)))

        self.get_class_name_list()

        print("[+] Class Obfuscation Start")
        obfuscation_index = 0
        class_list_count = len(self.classname_list)
        for bClassname in self.classname_list:
            classname_len = len(bClassname)
    
            if self.is_valid_bytes(bClassname) and \
             self.it_has_val(classname_len) and    \
             not self.used_in_other_section(bClassname) and \
             not self.is_it_exception_class(bClassname):
                    
                words_list = self.get_word_list(classname_len)
                words_list_length = len(words_list)
                
                obfuscation_word = self.generate_obfuscation_word(words_list, words_list_length)
                if obfuscation_word != None:
                    tmp_string1 = obfuscation_word[:1].upper() 
                    tmp_string2 = obfuscation_word[1:]
                    obfuscation_word = tmp_string1 + tmp_string2
                    self.classname_list[obfuscation_index] = bytes(obfuscation_word, "utf-8")
                    content_log(f"{bClassname.decode()} -> {self.classname_list[obfuscation_index].decode()}")
                    
            obfuscation_index+=1

        self.set_class_name_list()


    def used_in_other_section(self, target):
        for section in self.arm64_binary.sections:
            if section.name == "__objc_classname":
                continue
            
            if bytes(section.content).find(target) != -1:
                # content_log(f"{target} is used in {section.name} section")
                return True
            
        # content_log(f"{target} can be obfuscated")
        return False
        
    
    def get_class_name_list(self):
        print("[+] ClassObfuscator: get_class_name_list() Start")
        
        with open(self.mach_o, "rb+") as f:
            f.seek(self.objc_classname_section.offset)
            classname = f.read(self.objc_classname_section.size)
            self.classname_list = classname.split(b"\x00")

        if self.level is not None:
            self.apply_obfuscate_level()
  
  
    # Need to test
    def apply_obfuscate_level(self):
        print("[+] ClassObfuscator: apply_obfuscate_level() Start")
        try:
            if self.level.find("%") != -1:
                level = int(self.level[:-1])
                class_name_count = len(self.classname_list)
                adjust_class_name_count = (class_name_count*level)/100
                self.classname_list = self.classname_list[:adjust_class_name_count]
            else:
                content_log("failed. Can't find \"%\".")

        except:
            content_log("failed")


    def set_class_name_list(self): 
        print("[+] ClassObfuscator: set_class_name_list() Start")
        with open(self.mach_o, "rb+") as f:
            f.seek(self.objc_classname_section.offset)
            for obf_class_name in self.classname_list: # obfuscated class name list
                obf_class_name += b"\x00"
                f.write(obf_class_name)


    # 영문자, 숫자, _로 이루어진 클래스명만 난독화 하기위한 검사
    def is_valid_bytes(self, bClassname):
        if bClassname == None: 
            return False

        for byte in bClassname:
            if (65 <= byte and byte <= 90) or (97 <= byte and byte <= 122) or (48 <= byte and byte <= 57) or (byte == 95):
                continue
            else:
                return False
        return True


    # self.word{문자길이} 와 같은 이름의 멤버변수가 존재하는지 확인
    def it_has_val(self, classname_len):
        return hasattr(self, f"word{classname_len}")
    

    # 예외처리 시켜야하는 클래스명인지 확인
    def is_it_exception_class(self, bClassname):
        classname = bClassname.decode().lower()
        
        for exception_class in self.exception_class_list:
            if classname.find( exception_class.lower() ) != -1:
                return True
        
        return False
        

    # self.word{문자길이} 와 같은 명칭의 멤버변수를 get
    def get_word_list(self, classname_len):
        return getattr(self, f'word{classname_len}')


    # 난독화된 문자열을 가져오기 위한 함수. self.obfuscation_list 에 이미 존재하는 문자열인 경우 다시 생성하도록 로직 구현
    def generate_obfuscation_word(self, words_list, list_length):
        index = random.randrange(0, list_length-1)
        try_count = 0
        while words_list[index] in self.obfuscation_list:
            index = random.randrange(0, list_length-1)
            try_count+=1
            if try_count == 20:
                return None

        word = words_list[index]
        self.obfuscation_list.append(word)
        return word
    
    