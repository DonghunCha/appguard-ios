import os,sys
import base64
import struct
import string
from ctypes import *
from Crypto.Cipher import AES
import rncryptor
import binascii
import time

# http://rotlogix.com/2015/11/28/writing-a-simple-binary-parser-with-python-ctypes/

class FatHeader(Structure):
    _fields_ = [
        ("magic", c_uint),
        ("nfat_arch", c_uint)
    ]

class FatArch(Structure):
    _fields_ = [
        ("cputype", c_uint),
        ("cpusubtype", c_uint),
        ("offset", c_uint),
        ("size", c_uint),
        ("align", c_uint)
    ]
    
class MachOHeader(Structure):
    _fields_ = [
        ("magic", c_uint),
        ("cputype", c_uint),
        ("cpusubtype", c_uint),
        ("filetype", c_uint),
        ("ncmds", c_uint),
        ("sizeofcmds", c_uint),
        ("flags", c_uint),
    ]
    
class StaticHeader(Structure):
    _fields_ = [
        ("signature", c_ulonglong),
    ]

class SymtabHdr(Structure):
    _fields_ = [
        ("name1", c_ulonglong),
        ("name2", c_ulonglong),
        ("blob1", c_ulonglong),
        ("blob2", c_ulonglong),
        ("blob3", c_ulonglong),
        ("blob4", c_ulonglong),
        #("blob5", c_ulonglong),
        ("size", c_ulonglong),
        ("end_header", c_uint),
    ]

class ObjectHdr(Structure):
    _fields_ = [
        ("name1", c_ulonglong),
        ("name2", c_ulonglong),
        ("blob1", c_ulonglong),
        ("blob2", c_ulonglong),
        ("blob3", c_ulonglong),
        ("blob4", c_ulonglong),
        #("blob5", c_ulonglong),
        ("size", c_ulonglong),
        ("end_header", c_uint),
        ("longname1", c_ulonglong),
        ("longname2", c_ulonglong),
        ("longname3", c_ulonglong),
        ("longname4", c_ulonglong),
        ("longname4", c_uint),
    ]

if __name__ == "__main__":
    
    if len(sys.argv[1]) > 0:
        if len(sys.argv[1]) < 32:
            APPKEY = sys.argv[1]
            for i in range(0,32-len(sys.argv[1])):
                APPKEY  = APPKEY + "X"
        elif len(sys.argv[1]) > 32:
            APPKEY = sys.argv[1][0:31]
    else:
        print "NO APPKEY"
        exit()
        
    # encrypt appkey_check with "appkey" as key
    # appkey max 64 bytes    
    APPKEY_CHECK = "APPKEY__VERIFIEDAPPKEY__VERIFIEDAPPKEY__VERIFIED"
    IV = "NHNENT_SECURITY_"
    
    cryptor = rncryptor.RNCryptor()
    #obj = AES.new(APPKEY, AES.MODE_CBC, IV)
    #appkeyCheckEnc = obj.encrypt(APPKEY_CHECK)
    appkeyCheckEnc = base64.b64encode(cryptor.encrypt(APPKEY_CHECK,APPKEY)) 
    print "appkey msg size: "+str(len(appkeyCheckEnc))
    #print APPKEY
    print cryptor.decrypt(base64.b64decode(appkeyCheckEnc),APPKEY)
    
    # digital watermarking
    FULL_APPKEY = sys.argv[1]
    if len(sys.argv[1])<64:
        for i in range(0,64-len(sys.argv[1])):
            FULL_APPKEY  = FULL_APPKEY + " "
    elif sys.argv[1] == 64:
        FULL_APPKEY = sys.argv[1]
    else:
        print "wrong appkey size"
        exit()
    ts = struct.pack("<f", time.time())          
    WATERMARK = "__APPGUARD__"+FULL_APPKEY+"____TIME"+ts+"TIME____"
    MASTERKEY = "alkdsfj!#432w9da"
    #obj = AES.new(MASTERKEY, AES.MODE_CBC, IV)
    #watermark1 = obj.encrypt(WATERMARK)
    watermark1 = base64.b64encode(cryptor.encrypt(WATERMARK, MASTERKEY))
    print "watermark size : "+str(len(watermark1))
    print cryptor.decrypt(base64.b64decode(watermark1), MASTERKEY) 
 
    b = os.path.join("AppGuard.framework","Versions","A","AppGuard") 
    
    try:
        with open(b,"rb") as f:
            binary = bytearray(f.read())
            print ("[*] Loading : {0}".format(b))
            f.close()
    except IOError:
        print ("[*] Cannot open {0} (!) ".format(b))
    
    fat_header = FatHeader.from_buffer_copy(binary)
    
    if(hex(fat_header.magic).rstrip("L") != "0xbebafeca"):
        print("[*] Not a Fat Binary (!) ")

    fat_arch = []
    tmp = struct.pack("<I",fat_header.nfat_arch)
    nfat = struct.unpack(">I",tmp)[0]
    
    offset = sizeof(FatHeader)
    for i in range(0, nfat):
        fat_arch.append(FatArch.from_buffer_copy(binary[offset+sizeof(FatArch)*i:]))
    
    offset = offset + sizeof(FatArch) * (nfat-1)
    
    static_hdr_offset=[]
    for i in range(0, nfat):
        static_hdr_offset.append(struct.unpack(">I",struct.pack("<I",fat_arch[i].offset))[0])
            
    # traverse each mach header and inject appkey & watermark
    for i in range(0,nfat):
        static_hdr_off = static_hdr_offset[i]
        sthdr = StaticHeader.from_buffer_copy(binary[static_hdr_off:])
                
        symtab_hdr_offset = static_hdr_off + 8
        symtab_hdr = SymtabHdr.from_buffer_copy(binary[symtab_hdr_offset:])

        symtable_offset = symtab_hdr_offset + sizeof(symtab_hdr)
        object_hdr_offset = symtable_offset + int(struct.pack("<Q",symtab_hdr.size))
        
        obj_hdr = ObjectHdr.from_buffer_copy(binary[object_hdr_offset -4:])    
        mach_hdr_offset = object_hdr_offset+sizeof(ObjectHdr) - 12

        mach_hdr = MachOHeader.from_buffer_copy(binary[mach_hdr_offset:])
        
        # write appkey check 
        pattern = mach_hdr_offset+binary[mach_hdr_offset:].find("AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB")
        #binary[pattern:pattern + 0x30]
	#struct.
        binary = binary[:pattern]+appkeyCheckEnc+binary[pattern+176:]
	#print binascii.b2a_hex(appkeyCheckEnc)
        #print binary[pattern:pattern + 0x30]
         
        # write watermark
        pattern = mach_hdr_offset+binary[mach_hdr_offset:].find("DDDDDDDDDDDDDDDDEEEEEEEEEEEEEEEEFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHIIIIIIIIIIIIIIIIGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHIIIIIIIIIIIIIIIIGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHIIIIIIIIIIIIIIIIGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHCCCCCCCCJJJJJJJJKKKKKKKK")
        binary = binary[:pattern]+"_iOS_iOS"+watermark1+binary[pattern+240+8:]
        # print binary[pattern:pattern+0x60]
        # 
    
    fd = open(b,"wb")
    fd.write(binary)
    fd.close()
