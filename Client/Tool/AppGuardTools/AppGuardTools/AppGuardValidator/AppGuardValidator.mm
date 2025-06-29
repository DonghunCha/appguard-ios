//
//  AppGuardValidator.m
//  AppGuardMySample
//
//  Created by NHN on 2023/01/26.
//

#import "AppGuardValidator.hpp"
#include <mach-o/dyld.h>
#include <mach-o/loader.h>
#include <mach-o/fat.h>
#include <sys/mman.h>
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <string>
typedef struct _AG_SDK_VERSION{
    char signature[65];
    short major;
    short minor;
    short patch;
    char reserved[32];
    char protectorVersion[65];
}AG_SDK_VERSION, *PAG_SDK_VERSION;

//API Key
struct ProtectorInjectedApiKeySignature {
    char signature[128+8];
    char encApiKey[512+8];
    int apiKeyStrlen;
};

typedef NS_ENUM(int, ProtectorUpdateSignatureIndex){
    kTextSectionSignature = 0,
    kUnityTextSectionSignature,
    kSignerSignature,
    kNumOfLCSignature,
    kDefaultPolicySignature,
    kDefaultProtectLevelSignature,
    kProtectLevelSignature4,
    kProtectLevelSignature5,
    kProtectLevelSignature6,
    kProtectLevelSignature0,
    kSDKVersionSignature,
    kProtectorVersionSignature,
    kInfoPlistSignature,
    kInfoPlistReplacedSignature,
    kUnityIl2cppSectionSignature,
    kApiKeySignature,
    kApiKeyReplaceSignature,
    kNewDefaultPolicySignature,
    kStartupMessageSignature,
    kStartupMessageReplaceSignature,
    kDetectionPopupModeSignature,
    kDetectionPopupModeReplaceSignature,
};

typedef struct _ProtectorUpdateSignatureInfo {
    ProtectorUpdateSignatureIndex signatureIndex;
    NSString* base64encodedSignature;
    const char* sectionName;
    size_t size;
}ProtectorUpdateSignatureInfo;

typedef struct _MMAP_CONTEXT {
    NSString* filePath;
    int fd;
    size_t size;
    void * fileData;
}MMAP_CONTEXT;

// AGResourceIntegrityManager.hpp
#define AG_SHA256_SIGNATURE_LEN 64
#define AG_UPDATED_RESOURCE_SIGNATRUE_LEN AG_SHA256_SIGNATURE_LEN
#define AG_MAX_RESOURCE_SIGNATURE_DATA_LEN 512
typedef struct _AGInfoPlistSignatureInfo {
    char updatedSignature[AG_UPDATED_RESOURCE_SIGNATRUE_LEN+8];
    char sha256Hash[AG_SHA256_SIGNATURE_LEN+8];
    unsigned long long resouceSize;
    int type;
    unsigned char dummy[1]; //더미
}AGInfoPlistSignatureInfo;

#define STARTUP_SIGNATURE_MAX_LEN 256
union StartupMessageSignature {
    unsigned char rawData[STARTUP_SIGNATURE_MAX_LEN];
    struct {
        char signature[68];
        unsigned int durationMillisec;
        unsigned int delayMillisec;
    };
};

#define AG_ALERT_SIMPLE_MODE_SIGNATURE_MAX_LEN 256
typedef NS_ENUM(int, AGAlertMode) {
    AGAlertModeDetailed = 0,
    AGAlertModeSimple = 1
};
union AGAlertModeSignature {
    unsigned char rawData[AG_ALERT_SIMPLE_MODE_SIGNATURE_MAX_LEN];
    struct {
        char signature[68];
        AGAlertMode mode;
    };
};

const ProtectorUpdateSignatureInfo protectorUpdateSignatureInfo[] = {
    {kTextSectionSignature, @"MDQ0NWM4MDE0NDMzMzA1Y2UxNDJkYTNjYmE5Y2JlZDQ1NmQ1ODU3ODljMjI0YzIzMWEzZjhjMjA1Yjk2NDNkZA==","__cstring", 64 }, //0445c8014433305ce142da3cba9cbed456d585789c224c231a3f8c205b9643dd
    {kUnityTextSectionSignature, @"YjRiMWE4MDQ0NDMyMzA1Y2UyMzJkYTNjYmE5OGJlZDQ1NjA1ODU3ODljMjI3YzIzMWFjZjhjMjM1YTI2NDFkMw==","__cstring",  64 }, //b4b1a8044432305ce232da3cba98bed4560585789c227c231acf8c235a2641d3
    {kSignerSignature, @"MTIzNWM4MDE0NDMzMzA1Y2UxNDJkYTNjYmE5Y2JlZDQ1NmQ1ODU3ODljMjI0YzIzMWEzZjhjMjA1Yjk2NDNkMTEyMzVjODAxNDQzMzMwNWNlMTQyZGEzY2JhOWNiZWQ0NTZkNTg1Nzg5YzIyNGMyMzFhM2Y4YzIwNWI5NjQzZDE=", "__cstring", 128 }, //1235c8014433305ce142da3cba9cbed456d585789c224c231a3f8c205b9643d11235c8014433305ce142da3cba9cbed456d585789c224c231a3f8c205b9643d1
    {kNumOfLCSignature,@"MTIzOTk0ODg1ODI0OTU5NTAyMDIxMzU4NTQ0MzkyOTI0ODQ4OTQ5NDk0MTEyMzEyMzQ4","__cstring",  51 }, //123994885824959502021358544392924848949494112312348
    {kDefaultPolicySignature, @"MDc4NThhZTY3ZTY3NjUwMzZiNWY5MjNhZWE5YTVjYWRhZmRmMDJlNWM4MzBiMWVlYTM5Yzk2MzBmZjM4NmYxZTk1OTI0YjU4NWZkZjE4MTRkMDA5ZWIxM2EyNzhlOTkwYzZlNzFlYzk5ZWZkMzcyN2Q4YTNjMWI5Mzc4MTc1YTc=","__const",  128 }, //07858ae67e6765036b5f923aea9a5cadafdf02e5c830b1eea39c9630ff386f1e95924b585fdf1814d009eb13a278e990c6e71ec99efd3727d8a3c1b9378175a7
    {kDefaultProtectLevelSignature, @"ZmJlZjNjZmRhZTMwNTM1YzlkNjE3NjRjYTNiMmI5MGQ0ZWQxOTY5MDk3YmFmYTM2MTkyZGMyMWRmM2NlMzY4NjVmZjAxZmUyODhmZDJiYzY3YTJmZTllZDdlMjc3ODZlMmNhYjhlMmMwZjMxZjI2MmNiNzFmYjkzMzQ2ZTM0MDY0","__cstring",  129 }, //fbef3cfdae30535c9d61764ca3b2b90d4ed1969097bafa36192dc21df3ce36865ff01fe288fd2bc67a2fe9ed7e27786e2cab8e2c0f31f262cb71fb93346e34064
    {kProtectLevelSignature4, @"YzlmYTVlMTgxNjBhNWUzN2FmYTdkZjEyNjcxNTQ4OGY1ZGY2YmE1ZDRjYWEzODcwYTY3NDk4NDNmNTE1MzNlZTQ=","__cstring",  65 }, //c9fa5e18160a5e37afa7df126715488f5df6ba5d4caa3870a6749843f51533ee4
    {kProtectLevelSignature5, @"YzlmYTVlMTgxNjBhNWUzN2FmYTdkZjEyNjcxNTQ4OGY1ZGY2YmE1ZDRjYWEzODcwYTY3NDk4NDNmNTE1MzNlZTU=","__cstring",  65 }, //c9fa5e18160a5e37afa7df126715488f5df6ba5d4caa3870a6749843f51533ee5
    {kProtectLevelSignature6, @"YzlmYTVlMTgxNjBhNWUzN2FmYTdkZjEyNjcxNTQ4OGY1ZGY2YmE1ZDRjYWEzODcwYTY3NDk4NDNmNTE1MzNlZTY=","__cstring",  65 }, //c9fa5e18160a5e37afa7df126715488f5df6ba5d4caa3870a6749843f51533ee6
    {kProtectLevelSignature0, @"YzlmYTVlMTgxNjBhNWUzN2FmYTdkZjEyNjcxNTQ4OGY1ZGY2YmE1ZDRjYWEzODcwYTY3NDk4NDNmNTE1MzNlZTA=","__cstring",  65 }, //c9fa5e18160a5e37afa7df126715488f5df6ba5d4caa3870a6749843f51533ee0
    { kSDKVersionSignature, @"YjM5MzZhZGFhNjI0MGE5Y2Y3MDZkMDNhYTAxMTQxNjg5ZmY0MGZjZTQwYmViNWYzZTBhMzUzY2VkNDg1NTVmNw==","__const",  64 }, //b3936adaa6240a9cf706d03aa01141689ff40fce40beb5f3e0a353ced48555f7
    { kProtectorVersionSignature,@"MGJhM2U1YjEwMTdiODEwNjYyMjU2MDI5ZGQ4MmZlMWE2OTY5Y2Q1MmUyMjQ3ZGI4YjZjNjQyODQ0MzE4MzFmYQ==","__const",  64 },
    //0ba3e5b1017b810662256029dd82fe1a6969cd52e2247db8b6c64284431831fa
    { kInfoPlistSignature, @"MDg5OTcxOTdjYzk2YjNhNzQ4N2Q1ZWNmYmY5MGFkMzBlOTc3ODY5MWE0MzIwYWE0NTkyZjkzMzFlODVmYTMzMTNmODg3MWFkMjJkNDQ2MTkxZWUzYmViNWM5NjUwYzliM2VmYjgyMDQ1MjkyMmQ2NWIyMTRhZWRmODcwMDBiNzk=", "__const", 128 },
    //08997197cc96b3a7487d5ecfbf90ad30e9778691a4320aa4592f9331e85fa3313f8871ad22d446191ee3beb5c9650c9b3efb820452922d65b214aedf87000b79
    { kInfoPlistReplacedSignature, @"ZGM3YTQyZjM2ZjVhYTY2OWQ1YTg2NThhMzIyZWYzN2NiM2VjM2EzZjk5MzliMjI3OGJhOTQ3YmY3YTYxYTNlZQ==", "__const", 64 },
    //dc7a42f36f5aa669d5a8658a322ef37cb3ec3a3f9939b2278ba947bf7a61a3ee
    { kUnityIl2cppSectionSignature, @"ZDY0YjdiNzNkMGIxNjI3NzVlMDg3MzcxOWQzYWU1ODk4NzMyMzg4NTBjZTllYjIwMGQ3ZTBiYjlkMGI4OTVkOA==","__cstring",  64},
    //d64b7b73d0b162775e0873719d3ae589873238850ce9eb200d7e0bb9d0b895d8
    { kApiKeySignature, @"ZDI0YzNhODg3NWJiYzhmN2YyZmZiOWZlZjRkNzRiZWNiM2Q0ZjhmODliOWE4YWFmMDMzZDcwYjYyMGVmYjM1YmU0NGRmYjE4NzMzOTUyOWI5YzIzZTQ4MGI4ZGRkMDYzZTc0NjQ4MjUxZTAzM2UzZDIwMGYxNTZkMTcxNmM4NWE=","__const",  128},
    //d24c3a8875bbc8f7f2ffb9fef4d74becb3d4f8f89b9a8aaf033d70b620efb35be44dfb187339529b9c23e480b8ddd063e74648251e033e3d200f156d1716c85a
    { kApiKeyReplaceSignature, @"MmEwMmE1NTJhYjc1YzVkZTEzNjdiNjlkMTM1YTRmZmZiMTIxYmVkZDJiZDkzNDQ0MDU2MDAzNWU4M2QxZDBjNw==", "__const", 64},
    //2a02a552ab75c5de1367b69d135a4fffb121bedd2bd934440560035e83d1d0c7
    { kNewDefaultPolicySignature, @"NzhlYzBjNTMyMGJiODFiMTVjOGVjOWY5ODRiNDNiMzgwMzlmMDllMTg2MGY5Yjk1YTQxM2FjN2Y2YzU3NGUyZTYzZjA3NjljN2I1MGVhODY5YjFkMGRmZDBhMjZjYmQxNjdmOWI5YjIxOGUxMDY4ZmNkMGJmMWM4NTNhOGUzNjk=", "__const", 128},
    //78ec0c5320bb81b15c8ec9f984b43b38039f09e1860f9b95a413ac7f6c574e2e63f0769c7b50ea869b1d0dfd0a26cbd167f9b9b218e1068fcd0bf1c853a8e369
    { kStartupMessageSignature, @"MzdiOTJhODUzNGEzOTk0NmFhZTgzM2YwOGYyODdhY2I1MjBiZjNmN2ZlMDYzYzUwMzhjMDdlZmIwNzc5NjliNWEyMzM0ZTAxMjQ5NjhmOTU0MzUyMzBiZjk5YTM3MTU0YjNiMmQxOWZjN2M5NzliNzMzODJhYzNkZWRhZjZlYjM=", "__const", 128}, // 37b92a8534a39946aae833f08f287acb520bf3f7fe063c5038c07efb077969b5a2334e0124968f95435230bf99a37154b3b2d19fc7c979b73382ac3dedaf6eb3
    { kStartupMessageReplaceSignature, @"YmNiZmNlOGQ1YjY0YWFjZWZlMGFmOGJmZmU4NzM2OTlhN2YyMTU2ZDI4ZmVjNjQ5OGFhZDUxNjBjMzhiNWY2ZA==", "__const", 64}, //bcbfce8d5b64aacefe0af8bffe873699a7f2156d28fec6498aad5160c38b5f6d
    { kDetectionPopupModeSignature, @"OGMwYjNkOTA5NDZlZjA3YmIwNDdmMmNjMzVmYjVlYTdhNDMzOWQzMzUzYWU3OTE3M2QzNTQzNWZiMzhmZGQ4Y2UwMjg3OWI0YzVhOGU0ZmRjN2UxMDM5NzAwOTgzNDQxZGE4MzEzYjg1NjZkNTg4ZGQzODFkNmE3NzFlNzQ5OTI=", "__const", 128},
    { kDetectionPopupModeReplaceSignature, @"ZTdhNDM4YmQxYjdiZDBjMTUxY2E0MmFjODdlZjcyMDI5NGY2NjY3Nzg3NWI4N2RlN2U1NDZhMmI1MGM4MTdhYQ==", "__const", 64},
    
};

@interface AppGuardValidator()

@end

@implementation AppGuardValidator

+ (NSString*)decodeBase64:(NSString*)encoded {
    NSData *encodedData = [[NSData alloc]initWithBase64EncodedString:encoded options:0];
    NSString *decodedText = [[NSString alloc] initWithData:encodedData encoding:NSUTF8StringEncoding];
    return decodedText;
}

+ (uint8_t*)findSignatureWithTextSectionPtr:(uint8_t*) sectionPtr :(uint64_t)size :(const ProtectorUpdateSignatureInfo&)signatureInfo{
    
    NSString* decoded = [AppGuardValidator decodeBase64:signatureInfo.base64encodedSignature];
    const char* decodedStr = [decoded UTF8String];
    
    for(uint8_t* offset = sectionPtr; offset< sectionPtr+size-signatureInfo.size; offset++) {
        if(memcmp((void*)offset, decodedStr, signatureInfo.size) == 0) {
            NSLog(@"sectionPtr: %p %s",sectionPtr, (char*)(offset));
            return offset;
       }
    }
    return 0;
}

+ (int)getTargetImageIndex {
    
    const char *processName = [[[NSProcessInfo processInfo] processName] cStringUsingEncoding:NSUTF8StringEncoding];
    uint32_t imageCount = _dyld_image_count();
    int imageIndex = 0;
    for(int i=0; i<imageCount; i++)
    {
        const char * name = _dyld_get_image_name(i);
        if(strstr(name, "UnityFramework")!=0)
        {
            NSLog(@"Found UnityFramework");
            imageIndex = i; // Target is unity
            return imageIndex;
        }
    }
    
    for(int i=0; i<imageCount; i++)
    {
        const char * name = _dyld_get_image_name(i);
        if(strstr(name, processName)!=0)
        {
            NSLog(@"Found %s",processName);
            imageIndex = i;
            break;
        }
    }
    
    return imageIndex;
}

+ (struct mach_header_64*)getMachOHeader:(void*) fileData {
    struct mach_header_64 * header = nullptr;
    struct fat_header* fatHeader = (struct fat_header*)fileData;
    if(fatHeader->magic == FAT_CIGAM) {
        NSLog(@"is fat binary");
        struct fat_arch* fatArch = (struct fat_arch*)((unsigned char*)fileData + sizeof(struct fat_header));
        uint32_t nfat = NXSwapLong(fatHeader->nfat_arch);
        for(int i = 0; i< nfat;i++) {
            if(NXSwapLong(fatArch[i].cputype) == CPU_TYPE_ARM64) {
                header = (struct mach_header_64 *)((unsigned char*)fileData+ NXSwapLong(fatArch[i].offset));
                break;
            }
        }
    } else if(fatHeader->magic == MH_MAGIC_64){
        header = (struct mach_header_64 *)fileData;
    }
    return header;
}

+ (uint8_t *)FindSignatureOffsetWithIndex:(ProtectorUpdateSignatureIndex)sigIndex :(NSString*)machOFile{
    MMAP_CONTEXT mmapCtx;
    mmapCtx.filePath = machOFile;
    if([AppGuardValidator mmapMachO:&mmapCtx] == nullptr) {
        NSLog(@"error mmapMachO %@",machOFile);
        return nil;
    }
    struct mach_header_64 * header = [AppGuardValidator getMachOHeader: mmapCtx.fileData];
    if(header == nullptr) {
        [AppGuardValidator unmapMachO:mmapCtx];
        NSLog(@"error can't find mach-o header %@",machOFile);
        return nil;
    }
  
    struct load_command * lc_cmd = (struct  load_command*)(header + 1);
    struct segment_command_64 * segment;
    for(int i = 0; i < header->ncmds; i++) {
        segment = (struct segment_command_64 *)lc_cmd;
        if( segment->cmd == LC_SEGMENT_64 ) {
            if(strstr(segment->segname, "__TEXT") != 0) {
             
                struct section_64 * section = (struct section_64 *)(segment +1);
              
                for(int j=0; j< segment->nsects; j++ ) {
                    if(strstr(section->sectname, protectorUpdateSignatureInfo[sigIndex].sectionName ) != 0) {
                        NSLog(@"Segment Name : %s", segment->segname);
                        NSLog(@"Section Name : %s", section->sectname);
                        NSLog(@"Section Size : %llu", section->size);
                        uint64_t sectionSize = section->size;
                        uint8_t * sectionPtr = (uint8_t *)((uint64_t)header + section->addr - segment->vmaddr);
                        uint8_t * signatureOffset = [AppGuardValidator findSignatureWithTextSectionPtr: sectionPtr :sectionSize :protectorUpdateSignatureInfo[sigIndex]];
                        if(signatureOffset!=0) {
                            NSLog(@"find signature : %s", (char*)signatureOffset);
                            return signatureOffset;
                        }
                    }
                    section = section + 1;
                }
            }
        }
        
        lc_cmd = (struct  load_command*)((uint8_t*)lc_cmd + segment->cmdsize);
    }
    return 0;
}

+ (NSString *)FindSignatureWithIndex:(ProtectorUpdateSignatureIndex)sigIndex :(NSString*)machOFile{
    
    MMAP_CONTEXT mmapCtx;
    mmapCtx.filePath = machOFile;
    if([AppGuardValidator mmapMachO:&mmapCtx] == nullptr) {
        NSLog(@"error mmapMachO %@",machOFile);
        return nil;
    }
    struct mach_header_64 * header = [AppGuardValidator getMachOHeader: mmapCtx.fileData];
    if(header == nullptr) {
        [AppGuardValidator unmapMachO:mmapCtx];
        NSLog(@"error can't find mach-o header %@",machOFile);
        return nil;
    }
  
    struct load_command * lc_cmd = (struct  load_command*)(header + 1);
    struct segment_command_64 * segment;
    for(int i = 0; i < header->ncmds; i++) {
        segment = (struct segment_command_64 *)lc_cmd;
        if( segment->cmd == LC_SEGMENT_64 ) {
            if(strstr(segment->segname, "__TEXT") != 0) {
             
                struct section_64 * section = (struct section_64 *)(segment +1);
              
                for(int j=0; j< segment->nsects; j++ ) {
                    if(strstr(section->sectname, protectorUpdateSignatureInfo[sigIndex].sectionName ) != 0) {
                        NSLog(@"Segment Name : %s", segment->segname);
                        NSLog(@"Section Name : %s", section->sectname);
                        NSLog(@"Section Size : %llu", section->size);
                        uint64_t sectionSize = section->size;
                        uint8_t * sectionPtr = (uint8_t *)((uint64_t)header + section->addr - segment->vmaddr);
                        uint8_t * signatureOffset = [AppGuardValidator findSignatureWithTextSectionPtr: sectionPtr :sectionSize :protectorUpdateSignatureInfo[sigIndex]];
                        if(signatureOffset!=0) {
                            NSLog(@"find signature : %s", (char*)signatureOffset);
                            NSString* foundSignature = [NSString stringWithFormat:@"%s",(char*)signatureOffset];
                            [AppGuardValidator unmapMachO:mmapCtx];
                            
                            return foundSignature;
                        }
                    }
                    section = section + 1;
                }
            }
        }
        
        lc_cmd = (struct  load_command*)((uint8_t*)lc_cmd + segment->cmdsize);
    }
    return nil;
}

+ (BOOL)validClassName: (NSString*)className {
    
    BOOL valid = YES;
    NSArray *exceptClass = @[@"ns", @"ui", @"delegate", @"system", @"animation", @"view", @"web", @"core", @"scene", @"app", @"window", @"gad", @"apm", @"pod", @"fir", @"kit"];
    
    for(NSString* str in exceptClass) {
        if([className rangeOfString:str options:NSCaseInsensitiveSearch].location != NSNotFound) {
            valid = NO;
            return valid;
        }
    }
    
    if([className length] == 0) {
        valid = NO;
        return valid;
    }
    
    for(int i = 0; i < [className length]; i++) {
        char ch = [className characterAtIndex:i];
        if(ch < 65 || ch > 122 ) {
          valid = NO;
          break;
        }
    }
    
    return valid;
}

+ (unsigned char*)mmapMachO:(MMAP_CONTEXT*)mmapCtx {
    int fd = open([mmapCtx->filePath cStringUsingEncoding:NSUTF8StringEncoding], O_RDONLY);
    if (fd == -1) {
        return nullptr;
    }
    mmapCtx->fd = fd;
    struct stat sb;
    if (fstat(fd, &sb) == -1) {
        mmapCtx->fd = 0;
        close(fd);
        return nullptr;
    }
    mmapCtx->size = sb.st_size;
    void *fileData = mmap(NULL, sb.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
    if (fileData == MAP_FAILED) {
        mmapCtx->fd = 0;
        mmapCtx->size = 0;
        close(fd);
        return nullptr;
    }
    mmapCtx->fileData = fileData;
    return (unsigned char*)fileData;
}

+ (void)unmapMachO:(MMAP_CONTEXT&)mmapCtx {
    if(mmapCtx.fileData && mmapCtx.size != 0 && mmapCtx.fd) {
        munmap(mmapCtx.fileData, mmapCtx.size);
        close(mmapCtx.fd);
    }
}


+ (NSArray*)getClassList:(NSString*)machOFile {
    
   
    
    NSMutableArray* classList = [[NSMutableArray alloc]init];
    MMAP_CONTEXT mmapCtx;
    mmapCtx.filePath = machOFile;
    if([AppGuardValidator mmapMachO:&mmapCtx] == nullptr) {
        NSLog(@"error mmapMachO %@",machOFile);
        return classList;
    }
    struct mach_header_64 * header = [AppGuardValidator getMachOHeader: mmapCtx.fileData];
    if(header == nullptr) {
        [AppGuardValidator unmapMachO:mmapCtx];
        NSLog(@"error can't find mach-o header %@",machOFile);
        return nil;
    }
    struct load_command * lc_cmd = (struct  load_command*)(header + 1);
    struct segment_command_64 * segment;
    for(int i = 0; i < header->ncmds; i++) {
        segment = (struct segment_command_64 *)lc_cmd;
        if( segment->cmd == LC_SEGMENT_64 ) {
            if(strstr(segment->segname, "__TEXT") != 0) {
             
                struct section_64 * section = (struct section_64 *)(segment +1);
              
                for(int j=0; j< segment->nsects; j++ ) {
                    if(strstr(section->sectname, "__objc_classname" ) != 0) {
                        NSLog(@"Segment Name : %s", segment->segname);
                        NSLog(@"Section Name : %s", section->sectname);
                        NSLog(@"Section Size : %llu", section->size);
                        uint64_t sectionSize = section->size;
                        uint8_t* sectionPtr = (uint8_t *)((uint64_t)header + section->addr - segment->vmaddr);
                        uint64_t offset = 0;
                        while(offset<sectionSize) {
                            NSString* className = @"";
                            className = [className stringByAppendingFormat:@"%s", &sectionPtr[offset]];
                            offset+= 1;
                            offset+= [className length];
                     
                            if([AppGuardValidator validClassName: className]) {
                                NSLog(@"classname: %@", className);
                                [classList addObject:className];
                            }
                        }
                    }
                    section = section + 1;
                }
            }
        }
        
        lc_cmd = (struct  load_command*)((uint8_t*)lc_cmd + segment->cmdsize);
    }
    [AppGuardValidator unmapMachO:mmapCtx];
    return classList;
}

+ (NSString*)getNumberOfLCSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kNumOfLCSignature :machOFile];
}

+ (NSString*)getTextSectionSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kTextSectionSignature :machOFile];
}

+ (NSString*)getDefaultPolicySignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kDefaultPolicySignature :machOFile];
}
+ (NSString*)getNewDefaultPolicySignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kNewDefaultPolicySignature :machOFile];
}
+ (NSString*)getSignerSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kSignerSignature :machOFile];
}

+ (NSString*)getUnityTextSectionSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kUnityTextSectionSignature :machOFile];
}
+ (NSString*)getUnityIl2cppSectionSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kUnityIl2cppSectionSignature :machOFile];
}

+ (NSString*)getInfoPlistSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kInfoPlistSignature :machOFile];
}

+ (NSString*)getInfoPlistReplacedSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kInfoPlistReplacedSignature :machOFile];
}

+ (NSString*)getApiKeySignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kApiKeySignature :machOFile];
}

+ (NSString*)getApiKeyReplaceSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kApiKeyReplaceSignature :machOFile];
}

+ (NSString*)getStartupMessageSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kStartupMessageSignature :machOFile];
}

+ (NSString*)getStartupMessageReplaceSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kStartupMessageReplaceSignature :machOFile];
}
+ (NSString*)getDetectionPopupSignatre:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kDetectionPopupModeSignature :machOFile];
}
+ (NSString*)getDetectionPopupReplaceSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kDetectionPopupModeReplaceSignature :machOFile];
}

+ (int)getDetectionPopupMode:(NSString*)machOFile {
    AGAlertModeSignature* signature = (AGAlertModeSignature*)[AppGuardValidator FindSignatureOffsetWithIndex:kDetectionPopupModeReplaceSignature:machOFile];
    if(!signature)
    {
        return -1;
    }
    return (int)signature->mode;
}

+ (unsigned int)getStartupmessageDuration:(NSString*)machOFile {
    
    StartupMessageSignature* signature = (StartupMessageSignature*)[AppGuardValidator FindSignatureOffsetWithIndex:kStartupMessageReplaceSignature:machOFile];
    if(!signature)
    {
        return 0;
    }
    return signature->durationMillisec;
}

+ (unsigned int)getStartupmessageDelay:(NSString*)machOFile {
    StartupMessageSignature* signature = (StartupMessageSignature*)[AppGuardValidator FindSignatureOffsetWithIndex:kStartupMessageReplaceSignature:machOFile];
    if(!signature)
    {
        return 0;
    }
    return signature->delayMillisec;
}

static std::string decodeApiKey(const char* encodedApiKey, int apiKeyLen) {
    char* decodedApiKey = new char[apiKeyLen+1];
    memset(decodedApiKey, '\0', apiKeyLen+1);
    
    for(int i = 0; i < apiKeyLen; i++) {
        char decode = encodedApiKey[0] ^ encodedApiKey[i];
        decodedApiKey[i] = decode == '\0' ? encodedApiKey[i] : decode;
    }
    std::string apikey = decodedApiKey;
    delete[] decodedApiKey;
    
    return apikey;
}

+ (NSString*)getApiKey:(NSString*)machOFile {
    ProtectorInjectedApiKeySignature* apiKeySignaturePtr = nullptr;
    apiKeySignaturePtr = (ProtectorInjectedApiKeySignature*)[AppGuardValidator FindSignatureOffsetWithIndex:kApiKeyReplaceSignature:machOFile];
    if(apiKeySignaturePtr) {
        return [NSString stringWithCString: decodeApiKey(apiKeySignaturePtr->encApiKey,apiKeySignaturePtr->apiKeyStrlen).c_str() encoding:kUnicodeUTF8Format];
    }
    return @"unknown";
}

+ (int)getProtectLevel:(NSString*)machOFile {
    NSString* protectLevel = [AppGuardValidator FindSignatureWithIndex:kProtectLevelSignature4 :machOFile];
    if(protectLevel) {
        return [[protectLevel substringFromIndex:[protectLevel length] - 1] intValue];
    }
    
    protectLevel = [AppGuardValidator FindSignatureWithIndex:kProtectLevelSignature5 :machOFile];
    if(protectLevel) {
        return [[protectLevel substringFromIndex:[protectLevel length] - 1] intValue];
    }
    
    protectLevel = [AppGuardValidator FindSignatureWithIndex:kProtectLevelSignature6 :machOFile];
    if(protectLevel) {
        return [[protectLevel substringFromIndex:[protectLevel length] - 1] intValue];
    }
    
    protectLevel = [AppGuardValidator FindSignatureWithIndex:kProtectLevelSignature0 :machOFile];
    if(protectLevel) {
        return [[protectLevel substringFromIndex:[protectLevel length] - 1] intValue];
    }
    
    return -1;
}

+ (NSString*)getDefaultProtectLevelSignature:(NSString*)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kDefaultProtectLevelSignature :machOFile];
}



+ (NSString*)getSDKVersion:(NSString*)machOFile {
    PAG_SDK_VERSION SDKSignatureOffset = (PAG_SDK_VERSION)[AppGuardValidator FindSignatureOffsetWithIndex:kSDKVersionSignature:machOFile];
    
    if(!SDKSignatureOffset) {
        return nil;
    }
  
    NSString* version = [NSString stringWithFormat:@"%hd.%hd.%hd", SDKSignatureOffset->major, SDKSignatureOffset->minor, SDKSignatureOffset->patch];
    if(SDKSignatureOffset->reserved[0] != '\0') {
        version = [version stringByAppendingFormat:@" %s", SDKSignatureOffset->reserved];
    }
    
    return version;
}

+ (NSString*)getProtectorVersionSignature:(NSString *)machOFile {
    return [AppGuardValidator FindSignatureWithIndex:kProtectorVersionSignature :machOFile];
}

+ (NSString*)getProtectorVersion:(NSString*)machOFile {
    if([AppGuardValidator getProtectorVersionSignature:machOFile]) {
        return nil;
    }
    PAG_SDK_VERSION SDKSignatureOffset = (PAG_SDK_VERSION)[AppGuardValidator FindSignatureOffsetWithIndex:kSDKVersionSignature:machOFile];
    if(!SDKSignatureOffset) {
        return nil;
    }
  
    NSString* version = [NSString stringWithFormat:@"%s", SDKSignatureOffset->protectorVersion];
    return version;
}

+ (NSString*)getPlistInfoHashFromSignature:(NSString*)machOFile {
    if(![AppGuardValidator getInfoPlistReplacedSignature:machOFile]) {
        return nil;
    }
    AGInfoPlistSignatureInfo* infoPlistReplacedSignature = (AGInfoPlistSignatureInfo*)[AppGuardValidator FindSignatureOffsetWithIndex:kInfoPlistReplacedSignature:machOFile];
    if(!infoPlistReplacedSignature) {
        return nil;
    }
  
    NSString* hash = [NSString stringWithFormat:@"%s", infoPlistReplacedSignature->sha256Hash];
    return hash;
}

+ (unsigned long long)getPlistInfoSizeFromSignature:(NSString*)machOFile {
    if(![AppGuardValidator getInfoPlistReplacedSignature:machOFile]) {
        return 0;
    }
    AGInfoPlistSignatureInfo* infoPlistReplacedSignature = (AGInfoPlistSignatureInfo*)[AppGuardValidator FindSignatureOffsetWithIndex:kInfoPlistReplacedSignature:machOFile];
    if(!infoPlistReplacedSignature) {
        return 0;
    }
    return infoPlistReplacedSignature->resouceSize;
}
+ (NSString*)getPlistInfoHashFromIPA {
    return nil;
}


@end
